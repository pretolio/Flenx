import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Invólucro de "folha" branca centralizada (A4) para documentos longos —
/// propostas, contratos, cartas. Fundo cinza na tela; imprime limpo em A4.
class FlenxSheet extends StatelessComponent {
  const FlenxSheet(this.child, {this.maxWidthPx = 820, this.padding = 52, super.key});

  final Component child;
  final int maxWidthPx;
  final int padding;

  static const _css = '''
.fxdoc-sheetwrap{background:#e9eef6;padding:26px 16px;min-height:100vh}
.fxdoc-sheet{background:#fff;margin:0 auto;box-shadow:0 10px 40px -12px rgba(7,28,67,.35);
border-radius:4px;font-family:system-ui,-apple-system,"Segoe UI",Roboto,sans-serif;line-height:1.6}
@media print{
.fxdoc-sheetwrap{background:#fff;padding:0}
.fxdoc-sheet{box-shadow:none;max-width:none;width:100%;border-radius:0}
@page{margin:14mm}
}
''';

  @override
  Component build(BuildContext context) {
    return div(classes: 'fxdoc-sheetwrap', [
      Component.element(tag: 'style', children: const [RawText(_css)]),
      div(
        classes: 'fxdoc-sheet',
        styles: Styles(raw: {
          'max-width': '${maxWidthPx}px',
          'padding': '${padding}px',
        }),
        [child],
      ),
    ]);
  }
}
