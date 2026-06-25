import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../site/site_styles.dart';

/// Raiz de uma página do site — agrupa os blocos (header, seções, footer) e já
/// injeta o estilo-base do Flext por baixo. Use no lugar daquele
/// `div(classes: 'flext-site')` + `<style>` na mão:
/// `FlextPage([SiteHeader(...), FlextHero(...), ...])`.
class FlextPage extends StatelessComponent {
  const FlextPage(this.children, {super.key});

  final List<Component> children;

  @override
  Component build(BuildContext context) {
    return div(classes: 'flext-site', [
      Component.element(tag: 'style', children: [RawText(flextSiteCss)]),
      ...children,
    ]);
  }
}
