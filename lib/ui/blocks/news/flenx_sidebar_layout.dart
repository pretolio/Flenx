import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Layout de duas colunas (estilo portal): conteúdo principal largo + barra
/// lateral. Empilha sozinho no mobile (flex-wrap), sem media query.
class FlenxSidebarLayout extends StatelessComponent {
  const FlenxSidebarLayout({
    required this.main,
    required this.aside,
    super.key,
  });

  final Component main;
  final Component aside;

  @override
  Component build(BuildContext context) {
    return div(classes: 'fnews-cols', [
      div(classes: 'fnews-main', [main]),
      div(classes: 'fnews-aside', [aside]),
    ]);
  }
}
