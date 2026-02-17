// lib/features/auth/presentation/pages/register_page.dart
import 'package:app_clima/features/auth/application/presentation/register/widgets/register_form_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: const SafeArea(
        child: RegisterFormCard(),
      ),
    );
  }
}
