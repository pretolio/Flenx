import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../flenx_palette.dart';

/// Visualizador de um PDF em tela cheia: barra (voltar + baixar) + o PDF
/// embutido. Usado para servir um documento comercial já gerado em PDF —
/// imprime/baixa sempre igual, sem depender do CSS de impressão do navegador.
class FlenxPdfViewer extends StatelessComponent {
  const FlenxPdfViewer({
    required this.pdfUrl,
    required this.title,
    this.backHref = '/comercial',
    this.backLabel = 'Central',
    this.accent = FlenxPalette.primary,
    this.barColor = '#071C43',
    this.downloadName,
    super.key,
  });

  final String pdfUrl;
  final String title;
  final String backHref;
  final String backLabel;
  final String accent;
  final String barColor;
  final String? downloadName;

  static const _css = '''
.fxpv{position:fixed;inset:0;display:flex;flex-direction:column;background:#525659;
font-family:system-ui,-apple-system,"Segoe UI",Roboto,sans-serif}
.fxpv__bar{display:flex;align-items:center;gap:14px;padding:12px 20px;color:#fff}
.fxpv__back{display:inline-flex;align-items:center;gap:7px;font-weight:700;font-size:.9rem;color:#cfe0ff;text-decoration:none;opacity:.9}
.fxpv__back:hover{opacity:1}
.fxpv__title{flex:1;font-weight:800;font-size:.98rem;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.fxpv__dl{display:inline-flex;align-items:center;gap:8px;padding:9px 18px;border-radius:999px;
font-weight:800;font-size:.9rem;color:#fff;text-decoration:none;transition:transform .15s ease}
.fxpv__dl:hover{transform:translateY(-1px)}
.fxpv__frame{flex:1;border:0;width:100%}
''';

  @override
  Component build(BuildContext context) {
    return div(classes: 'fxpv', [
      Component.element(tag: 'style', children: const [RawText(_css)]),
      div(classes: 'fxpv__bar', styles: Styles(raw: {'background': barColor}), [
        a([Component.text('← $backLabel')], href: backHref, classes: 'fxpv__back'),
        span(classes: 'fxpv__title', [Component.text(title)]),
        a(
          [Component.text('⭳  Baixar PDF')],
          href: pdfUrl,
          classes: 'fxpv__dl',
          styles: Styles(raw: {'background': accent}),
          attributes: {'download': downloadName ?? ''},
        ),
      ]),
      Component.element(
        tag: 'iframe',
        classes: 'fxpv__frame',
        attributes: {'src': '$pdfUrl#toolbar=1&view=FitH', 'title': title},
        children: const [],
      ),
    ]);
  }
}
