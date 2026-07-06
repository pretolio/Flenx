import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Contêiner que ocupa a tela inteira (100% × 100vh, sem margem) — usado para
/// hospedar uma ilha Flutter em tela cheia (ex.: o painel admin).
class FlenxFullscreen extends StatelessComponent {
  const FlenxFullscreen(this.child, {super.key});

  final Component child;

  @override
  Component build(BuildContext context) {
    return div(
      styles: Styles(raw: {'width': '100%', 'height': '100vh', 'margin': '0'}),
      [child],
    );
  }
}
