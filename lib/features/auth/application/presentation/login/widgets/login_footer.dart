import 'package:flutter/material.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Text(
        'Al iniciar sesión podrás sincronizar tus ciudades favoritas.',
        textAlign: TextAlign.center,
        style: text.bodySmall?.copyWith(color: cs.onSurfaceVariant),
      ),
    );
  }
}
