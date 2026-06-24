/// Usuário logado exibido no shell (área de user/admin e menu de perfil).
class AppUser {
  const AppUser({
    required this.name,
    required this.role,
    this.email,
    this.avatarUrl,
  });

  final String name;

  /// Papel exibido (ex.: 'Administrador', 'Usuário').
  final String role;
  final String? email;
  final String? avatarUrl;

  /// Iniciais para o avatar quando não há imagem (ex.: "Ana Lima" → "AL").
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return '?';
    return parts.take(2).map((p) => p[0].toUpperCase()).join();
  }
}
