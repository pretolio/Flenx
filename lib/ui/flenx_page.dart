import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../flenx_palette.dart';
import '../site/site_styles.dart';

/// Raiz de uma página do site — agrupa os blocos (header, seções, footer) e já
/// injeta o estilo-base do Flenx por baixo. Use no lugar daquele
/// `div(classes: 'flenx-site')` + `<style>` na mão:
/// `FlenxPage([SiteHeader(...), FlenxHero(...), ...])`.
///
/// Passe [primaryColor] e [secondaryColor] para sobrescrever a paleta padrão
/// (CSS vars `--primary` e `--secondary`) — todos os componentes Flenx
/// usam essas variáveis automaticamente.
class FlenxPage extends StatelessComponent {
  const FlenxPage(
    this.children, {
    this.primaryColor,
    this.primaryDarkColor,
    this.secondaryColor,
    super.key,
  });

  final List<Component> children;

  /// Cor primária do site (ex.: `'#b5602f'`). Sobrescreve `--primary`.
  final String? primaryColor;

  /// Versão escura do primário para hover. Se nulo, escurece automaticamente.
  final String? primaryDarkColor;

  /// Cor secundária (ex.: `'#1A1A1A'`). Sobrescreve `--secondary`.
  final String? secondaryColor;

  String? get _overrideVars {
    if (primaryColor == null && secondaryColor == null) return null;
    final pri = primaryColor;
    final priD =
        primaryDarkColor ?? _darken(primaryColor ?? FlenxPalette.primary);
    final sec = secondaryColor;
    return ':root{'
        '${pri != null ? "--primary:$pri;--primary-d:$priD;" : ""}'
        '${sec != null ? "--secondary:$sec;" : ""}'
        '}';
  }

  /// Escurece um hex #RRGGBB em ~15% (para hover).
  static String _darken(String hex) {
    final h = hex.replaceAll('#', '');
    if (h.length != 6) return hex;
    int r = int.parse(h.substring(0, 2), radix: 16);
    int g = int.parse(h.substring(2, 4), radix: 16);
    int b = int.parse(h.substring(4, 6), radix: 16);
    r = (r * 0.82).round().clamp(0, 255);
    g = (g * 0.82).round().clamp(0, 255);
    b = (b * 0.82).round().clamp(0, 255);
    return '#${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}';
  }

  @override
  Component build(BuildContext context) {
    final override = _overrideVars;

    // Acessibilidade: garante um landmark <main>. Componentes cujo nome de tipo
    // contém "Header"/"Footer" (ex.: SiteHeader, FlenxFooter, AlstopHeader)
    // ficam FORA do <main> — assim os landmarks banner/contentinfo continuam no
    // topo; todo o resto do conteúdo vai DENTRO do <main>.
    final head = <Component>[];
    final foot = <Component>[];
    final body = <Component>[];
    for (final child in children) {
      final name = child.runtimeType.toString();
      if (name.contains('Header')) {
        head.add(child);
      } else if (name.contains('Footer')) {
        foot.add(child);
      } else {
        body.add(child);
      }
    }

    return div(classes: 'flenx-site', [
      Component.element(tag: 'style', children: [RawText(flenxSiteCss)]),
      if (override != null)
        Component.element(tag: 'style', children: [RawText(override)]),
      ...head,
      Component.element(tag: 'main', children: body),
      ...foot,
    ]);
  }
}
