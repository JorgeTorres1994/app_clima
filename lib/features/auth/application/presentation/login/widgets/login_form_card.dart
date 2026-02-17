import 'package:flutter/material.dart';

class LoginFormCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailCtrl;
  final TextEditingController passCtrl;
  final FocusNode emailFocus;
  final FocusNode passFocus;

  final bool loading;
  final bool obscure;

  final VoidCallback onToggleObscure;
  final VoidCallback onSubmit;
  final VoidCallback onGoRegister;
  final VoidCallback onFocusPassword;

  const LoginFormCard({
    super.key,
    required this.formKey,
    required this.emailCtrl,
    required this.passCtrl,
    required this.emailFocus,
    required this.passFocus,
    required this.loading,
    required this.obscure,
    required this.onToggleObscure,
    required this.onSubmit,
    required this.onGoRegister,
    required this.onFocusPassword,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      color: cs.surfaceContainerHighest.withOpacity(.6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: cs.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Tu cuenta', style: text.titleMedium),
              const SizedBox(height: 12),

              TextFormField(
                controller: emailCtrl,
                focusNode: emailFocus,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'ej. correo@dominio.com',
                  prefixIcon: Icon(Icons.mail_outline),
                ),
                validator: (v) {
                  final s = (v ?? '').trim();
                  if (s.isEmpty) return 'Ingresa tu email';
                  if (!s.contains('@')) return 'Email inválido';
                  return null;
                },
                onFieldSubmitted: (_) => onFocusPassword(),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: passCtrl,
                focusNode: passFocus,
                obscureText: obscure,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    tooltip: obscure ? 'Mostrar contraseña' : 'Ocultar contraseña',
                    onPressed: onToggleObscure,
                    icon: Icon(
                      obscure ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                ),
                validator: (v) {
                  final s = (v ?? '').trim();
                  if (s.isEmpty) return 'Ingresa tu contraseña';
                  if (s.length < 6) return 'Mínimo 6 caracteres';
                  return null;
                },
                onFieldSubmitted: (_) => onSubmit(),
              ),

              const SizedBox(height: 18),

              FilledButton(
                onPressed: loading ? null : onSubmit,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: loading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Entrar'),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '¿No tienes cuenta?',
                    style: text.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                  ),
                  TextButton(
                    onPressed: loading ? null : onGoRegister,
                    child: const Text('Crear cuenta'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
