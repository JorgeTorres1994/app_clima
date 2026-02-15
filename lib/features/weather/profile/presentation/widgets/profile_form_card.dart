import 'package:flutter/material.dart';

class ProfileFormCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameCtrl;
  final TextEditingController lastNameCtrl;
  final DateTime? birthDate;
  final ValueChanged<DateTime> onPickBirthDate;

  const ProfileFormCard({
    super.key,
    required this.formKey,
    required this.firstNameCtrl,
    required this.lastNameCtrl,
    required this.birthDate,
    required this.onPickBirthDate,
  });

  String _fmt(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd/$mm/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Información personal',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),

              TextFormField(
                controller: firstNameCtrl,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
                validator: (v) {
                  final s = (v ?? '').trim();
                  if (s.isEmpty) return 'Ingresa tu nombre';
                  if (s.length < 2) return 'Nombre muy corto';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: lastNameCtrl,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Apellidos',
                  prefixIcon: Icon(Icons.badge),
                ),
                validator: (v) {
                  final s = (v ?? '').trim();
                  if (s.isEmpty) return 'Ingresa tus apellidos';
                  if (s.length < 2) return 'Apellidos muy cortos';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () async {
                  final now = DateTime.now();
                  final picked = await showDatePicker(
                    context: context,
                    initialDate:
                        birthDate ?? DateTime(now.year - 18, now.month, now.day),
                    firstDate: DateTime(1900, 1, 1),
                    lastDate: DateTime(now.year, now.month, now.day),
                  );
                  if (picked != null) onPickBirthDate(picked);
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Fecha de cumpleaños',
                    prefixIcon: Icon(Icons.cake_outlined),
                  ),
                  child: Text(birthDate == null ? 'Seleccionar' : _fmt(birthDate!)),
                ),
              ),

              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(Icons.cloud_done_outlined, color: cs.onSurfaceVariant),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Tus cambios se guardan en tu cuenta para sincronizar en la nube.',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: cs.onSurfaceVariant),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
