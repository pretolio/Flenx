/// Paleta central do Flenx — **fonte única de cores** para o site (CSS) e o
/// painel (tema Flutter). Dart puro (sem Flutter) para poder ser usada também
/// no servidor. Edite aqui e tudo (site claro + admin claro/escuro) acompanha.
class FlenxPalette {
  const FlenxPalette._();

  // Claro
  static const String primary = '#01589B';
  static const String primaryDark = '#01406F';
  static const String accent = '#06B6D4';
  static const String ink = '#0F172A';
  static const String muted = '#64748B';
  static const String surface = '#F8FAFC';
  static const String border = '#E2E8F0';

  // Escuro
  static const String darkBg = '#0B1220';
  static const String darkSurface = '#111A2B';
  static const String darkBorder = '#243245';
  static const String darkInk = '#E2E8F0';

  /// Converte um hex (`#RRGGBB`) no inteiro 0xFFRRGGBB usado por `Color`.
  static int argb(String hex) =>
      int.parse('FF${hex.replaceAll('#', '')}', radix: 16);
}
