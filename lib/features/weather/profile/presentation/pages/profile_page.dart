import 'dart:typed_data';

import 'package:app_clima/features/auth/application/auth_providers.dart';
import 'package:app_clima/features/auth/application/user_profile_providers.dart';
import 'package:app_clima/features/weather/profile/presentation/widgets/profile_form_card.dart';
import 'package:app_clima/features/weather/profile/presentation/widgets/profile_header_card.dart';
import 'package:app_clima/features/weather/profile/presentation/widgets/profile_save_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();

  DateTime? _birthDate;
  Uint8List? _pendingPhotoBytes;

  bool _initialized = false;
  bool _saving = false;

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    super.dispose();
  }

  Future<void> _changePhoto() async {
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) return;

    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1024,
      );
      if (file == null) return;

      final bytes = await file.readAsBytes();
      if (bytes.isEmpty) return;

      // ✅ Solo previsualizar (NO subir todavía)
      if (mounted) {
        setState(() => _pendingPhotoBytes = bytes);
      }

      HapticFeedback.lightImpact();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto seleccionada (pendiente de guardar)')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo seleccionar la foto: $e')),
      );
    }
  }

  Future<void> _save() async {
    if (_saving) return;

    FocusScope.of(context).unfocus();

    // Valida formulario
    if (!_formKey.currentState!.validate()) return;

    // Valida cumpleaños
    if (_birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona tu fecha de cumpleaños')),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      final repo = ref.read(authRepoProvider);

      // ✅ 1) Subir foto SOLO si hay pendiente
      if (_pendingPhotoBytes != null) {
        await repo.uploadProfilePhoto(photoBytes: _pendingPhotoBytes!);
      }

      // ✅ 2) Guardar datos del perfil (nombre/apellido/cumple)
      await repo.updateUserProfileExtras(
        firstName: _firstNameCtrl.text,
        lastName: _lastNameCtrl.text,
        birthDate: _birthDate!,
      );

      // ✅ 3) Limpiar pendiente + refrescar providers
      if (mounted) {
        setState(() => _pendingPhotoBytes = null);
      }
      ref.invalidate(userProfileProvider);

      if (!mounted) return;
      HapticFeedback.lightImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil guardado')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authUser = ref.watch(authStateProvider).valueOrNull;

    if (authUser == null) {
      return const Scaffold(
        body: Center(child: Text('No has iniciado sesión')),
      );
    }

    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(
            tooltip: 'Guardar',
            onPressed: _saving ? null : _save,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      bottomNavigationBar: ProfileSaveBar(isSaving: _saving, onSave: _save),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (p) {
          final profile = p ?? UserProfile.fromAuth(authUser);

          // Inicializa 1 vez (para no pisar lo que edita el usuario)
          if (!_initialized) {
            _firstNameCtrl.text = profile.firstName;
            _lastNameCtrl.text = profile.lastName;
            _birthDate = profile.birthDate;
            _initialized = true;
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
            children: [
              ProfileHeaderCard(
                profile: profile,
                authFallbackPhotoUrl: authUser.photoURL,
                pendingPhotoBytes: _pendingPhotoBytes, // ✅ preview local
                onChangePhoto: _changePhoto,
              ),
              const SizedBox(height: 16),
              ProfileFormCard(
                formKey: _formKey,
                firstNameCtrl: _firstNameCtrl,
                lastNameCtrl: _lastNameCtrl,
                birthDate: _birthDate,
                onPickBirthDate: (d) => setState(() => _birthDate = d),
              ),
            ],
          );
        },
      ),
    );
  }
}
