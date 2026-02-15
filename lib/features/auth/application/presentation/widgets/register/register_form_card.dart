// lib/features/auth/presentation/widgets/register/register_form_card.dart
import 'dart:typed_data';

import 'package:app_clima/features/auth/application/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'birthday_field.dart';
import 'profile_photo_field.dart';
import 'register_validators.dart';

class RegisterFormCard extends ConsumerStatefulWidget {
  const RegisterFormCard({super.key});

  @override
  ConsumerState<RegisterFormCard> createState() => _RegisterFormCardState();
}

class _RegisterFormCardState extends ConsumerState<RegisterFormCard> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  // Focus
  final _firstNameFocus = FocusNode();
  final _lastNameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passFocus = FocusNode();
  final _confirmFocus = FocusNode();

  // Extra fields
  DateTime? _birthDate;
  Uint8List? _photoBytes;

  bool _loading = false;
  bool _obscure = true;
  bool _obscure2 = true;

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();

    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _emailFocus.dispose();
    _passFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  String _prettyAuthError(Object e) {
    return e.toString().replaceFirst('Exception: ', '').trim();
  }

  Future<void> _submit() async {
    if (_loading) return;

    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    // Validación adicional (cumpleaños requerido)
    if (_birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona tu fecha de cumpleaños')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final auth = ref.read(authRepoProvider);

      final firstName = _firstNameCtrl.text.trim();
      final lastName = _lastNameCtrl.text.trim();
      final fullName = ('$firstName $lastName').trim();

      // ✅ Registro base (lo que ya tienes)
      await auth.registerWithEmail(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text.trim(),
        displayName: fullName,
      );

      // ✅ Extra recomendado: guardar extras del perfil
      // Si aún no lo tienes en tu AuthRepo, añade este método (te lo dejo más abajo).
      await auth.upsertUserProfileExtras(
        firstName: firstName,
        lastName: lastName,
        birthDate: _birthDate!,
        photoBytes: _photoBytes, // puede ser null
      );

      if (!mounted) return;

      HapticFeedback.lightImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cuenta creada correctamente')),
      );

      context.go('/'); // Home
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_prettyAuthError(e))),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, c) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: c.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  // Header
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: cs.primaryContainer,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.person_add_alt_1,
                          color: cs.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Crea tu cuenta', style: text.titleLarge),
                            const SizedBox(height: 2),
                            Text(
                              'Guarda tus favoritos y sincronízalos en la nube',
                              style: text.bodyMedium?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Card(
                    elevation: 0,
                    color: cs.surfaceContainerHighest.withOpacity(.6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: BorderSide(color: cs.outlineVariant),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('Perfil', style: text.titleMedium),
                            const SizedBox(height: 12),

                            // ✅ Foto
                            ProfilePhotoField(
                              photoBytes: _photoBytes,
                              onChanged: (bytes) => setState(() {
                                _photoBytes = bytes;
                              }),
                            ),

                            const SizedBox(height: 12),

                            // ✅ Nombre
                            TextFormField(
                              controller: _firstNameCtrl,
                              focusNode: _firstNameFocus,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.givenName],
                              decoration: const InputDecoration(
                                labelText: 'Nombre',
                                hintText: 'Ej. Jorge',
                                prefixIcon: Icon(Icons.badge_outlined),
                              ),
                              validator: Validators.firstName,
                              onFieldSubmitted: (_) => FocusScope.of(context)
                                  .requestFocus(_lastNameFocus),
                            ),

                            const SizedBox(height: 12),

                            // ✅ Apellidos
                            TextFormField(
                              controller: _lastNameCtrl,
                              focusNode: _lastNameFocus,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.familyName],
                              decoration: const InputDecoration(
                                labelText: 'Apellidos',
                                hintText: 'Ej. Torres Pastor',
                                prefixIcon: Icon(Icons.badge),
                              ),
                              validator: Validators.lastName,
                              onFieldSubmitted: (_) => FocusScope.of(context)
                                  .requestFocus(_emailFocus),
                            ),

                            const SizedBox(height: 12),

                            // ✅ Cumpleaños
                            BirthdayField(
                              value: _birthDate,
                              onChanged: (d) => setState(() => _birthDate = d),
                            ),

                            const SizedBox(height: 18),
                            Text('Cuenta', style: text.titleMedium),
                            const SizedBox(height: 12),

                            // Correo
                            TextFormField(
                              controller: _emailCtrl,
                              focusNode: _emailFocus,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.email],
                              decoration: const InputDecoration(
                                labelText: 'Correo',
                                hintText: 'correo@dominio.com',
                                prefixIcon: Icon(Icons.mail_outline),
                              ),
                              validator: Validators.email,
                              onFieldSubmitted: (_) => FocusScope.of(context)
                                  .requestFocus(_passFocus),
                            ),

                            const SizedBox(height: 12),

                            // Password
                            TextFormField(
                              controller: _passCtrl,
                              focusNode: _passFocus,
                              obscureText: _obscure,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.newPassword],
                              decoration: InputDecoration(
                                labelText: 'Contraseña',
                                hintText: 'Mín. 6 caracteres',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  tooltip: _obscure
                                      ? 'Mostrar contraseña'
                                      : 'Ocultar contraseña',
                                  onPressed: () =>
                                      setState(() => _obscure = !_obscure),
                                  icon: Icon(_obscure
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                ),
                              ),
                              validator: Validators.password,
                              onFieldSubmitted: (_) => FocusScope.of(context)
                                  .requestFocus(_confirmFocus),
                            ),

                            const SizedBox(height: 12),

                            // Confirm
                            TextFormField(
                              controller: _confirmCtrl,
                              focusNode: _confirmFocus,
                              obscureText: _obscure2,
                              textInputAction: TextInputAction.done,
                              autofillHints: const [AutofillHints.newPassword],
                              decoration: InputDecoration(
                                labelText: 'Confirmar contraseña',
                                prefixIcon:
                                    const Icon(Icons.verified_outlined),
                                suffixIcon: IconButton(
                                  tooltip: _obscure2 ? 'Mostrar' : 'Ocultar',
                                  onPressed: () =>
                                      setState(() => _obscure2 = !_obscure2),
                                  icon: Icon(_obscure2
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                ),
                              ),
                              validator: (v) => Validators.confirmPassword(
                                v,
                                _passCtrl.text.trim(),
                              ),
                              onFieldSubmitted: (_) => _submit(),
                            ),

                            const SizedBox(height: 18),

                            FilledButton(
                              onPressed: _loading ? null : _submit,
                              style: FilledButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: _loading
                                  ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text('Crear cuenta'),
                            ),

                            const SizedBox(height: 10),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '¿Ya tienes cuenta?',
                                  style: text.bodyMedium?.copyWith(
                                    color: cs.onSurfaceVariant,
                                  ),
                                ),
                                TextButton(
                                  onPressed:
                                      _loading ? null : () => context.go('/login'),
                                  child: const Text('Iniciar sesión'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 8),
                    child: Text(
                      'Al crear tu cuenta aceptas el uso de tus datos para sincronizar favoritos.',
                      textAlign: TextAlign.center,
                      style: text.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
