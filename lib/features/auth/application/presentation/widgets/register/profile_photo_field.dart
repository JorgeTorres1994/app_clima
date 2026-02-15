// lib/features/auth/presentation/widgets/register/profile_photo_field.dart
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePhotoField extends StatefulWidget {
  final Uint8List? photoBytes;
  final ValueChanged<Uint8List?> onChanged;

  const ProfilePhotoField({
    super.key,
    required this.photoBytes,
    required this.onChanged,
  });

  @override
  State<ProfilePhotoField> createState() => _ProfilePhotoFieldState();
}

class _ProfilePhotoFieldState extends State<ProfilePhotoField> {
  final _picker = ImagePicker();
  bool _loading = false;

  /*Future<void> _pick() async {
    if (_loading) return;
    setState(() => _loading = true);
    try {
      final file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1024,
      );
      if (file == null) return;
      final bytes = await file.readAsBytes();
      widget.onChanged(bytes);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }*/

  Future<void> _pick() async {
    if (_loading) return;
    setState(() => _loading = true);

    try {
      final file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1024,
      );

      if (file == null) return;

      final bytes = await file.readAsBytes();
      widget.onChanged(bytes);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo abrir la galería: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: cs.surfaceContainerHighest,
          backgroundImage: widget.photoBytes != null
              ? MemoryImage(widget.photoBytes!)
              : null,
          child: widget.photoBytes == null
              ? Icon(Icons.person, color: cs.onSurfaceVariant)
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'Foto de perfil (opcional)',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        OutlinedButton.icon(
          onPressed: _loading ? null : _pick,
          icon: _loading
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.photo_camera),
          label: const Text('Elegir'),
        ),
        if (widget.photoBytes != null) ...[
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'Quitar',
            onPressed: () => widget.onChanged(null),
            icon: const Icon(Icons.close),
          ),
        ],
      ],
    );
  }
}
