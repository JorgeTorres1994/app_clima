// lib/features/auth/presentation/widgets/register/birthday_field.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BirthdayField extends StatelessWidget {
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  const BirthdayField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final ctrl = TextEditingController(
      text: value == null ? '' : DateFormat('yyyy-MM-dd').format(value!),
    );

    return TextFormField(
      controller: ctrl,
      readOnly: true,
      decoration: const InputDecoration(
        labelText: 'Fecha de cumpleaños',
        hintText: 'Selecciona una fecha',
        prefixIcon: Icon(Icons.cake_outlined),
      ),
      validator: (_) => value == null ? 'Selecciona tu cumpleaños' : null,
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime(now.year - 18, now.month, now.day),
          firstDate: DateTime(1900, 1, 1),
          lastDate: DateTime(now.year, now.month, now.day),
        );
        onChanged(picked);
      },
    );
  }
}
