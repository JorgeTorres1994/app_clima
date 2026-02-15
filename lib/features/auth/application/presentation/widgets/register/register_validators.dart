// lib/features/auth/presentation/widgets/register/register_validators.dart
class Validators {
  static String? firstName(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Ingresa tu nombre';
    if (s.length < 2) return 'Nombre muy corto';
    return null;
  }

  static String? lastName(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Ingresa tus apellidos';
    if (s.length < 2) return 'Apellidos muy cortos';
    return null;
  }

  static String? email(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Ingresa un correo';
    if (!s.contains('@')) return 'Correo inválido';
    return null;
  }

  static String? password(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Ingresa una contraseña';
    if (s.length < 6) return 'Mínimo 6 caracteres';
    return null;
  }

  static String? confirmPassword(String? v, String pass) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Confirma tu contraseña';
    if (s != pass) return 'Las contraseñas no coinciden';
    return null;
  }
}
