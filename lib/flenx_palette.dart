import 'dart:math' as math;

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
  // Texto secundário: slate-600 (contraste AA em fundo claro).
  static const String muted = '#475569';
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

  static double _lin(double c) =>
      c <= 0.03928 ? c / 12.92 : math.pow((c + 0.055) / 1.055, 2.4).toDouble();
  static double _luminance(int r, int g, int b) =>
      0.2126 * _lin(r / 255) + 0.7152 * _lin(g / 255) + 0.0722 * _lin(b / 255);

  /// Escurece [hex] até atingir contraste WCAG [minRatio] (padrão AA 4.5:1)
  /// contra o branco — para usar cores de marca vibrantes como TEXTO em fundo
  /// claro sem falhar acessibilidade. Não altera a cor se ela já passa.
  static String contrastOnLight(String hex, {double minRatio = 4.5}) {
    final m = RegExp(r'^#?([0-9a-fA-F]{6})$').firstMatch(hex.trim());
    if (m == null) return hex;
    final n = int.parse(m.group(1)!, radix: 16);
    var r = (n >> 16) & 255, g = (n >> 8) & 255, b = n & 255;
    for (var i = 0; i < 40; i++) {
      final ratio = 1.05 / (_luminance(r, g, b) + 0.05);
      if (ratio >= minRatio) break;
      r = (r * 0.9).round();
      g = (g * 0.9).round();
      b = (b * 0.9).round();
      if (r == 0 && g == 0 && b == 0) break;
    }
    return '#${((r << 16) | (g << 8) | b).toRadixString(16).padLeft(6, '0')}';
  }
}
