import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../flenx_palette.dart';
import 'commercial_doc.dart';
import 'doc_print_format.dart';
import 'flenx_doc_bar.dart';
import 'flenx_sheet.dart';

/// Página de um documento comercial: barra (voltar + imprimir) + invólucro de
/// impressão conforme [CommercialDoc.format] + o conteúdo do documento.
class FlenxDocPage extends StatelessComponent {
  const FlenxDocPage({
    required this.doc,
    required this.backHref,
    this.accent = FlenxPalette.primary,
    this.barColor = '#071C43',
    super.key,
  });

  final CommercialDoc doc;
  final String backHref;
  final String accent;
  final String barColor;

  /// Regras de impressão do documento:
  /// - mantém as cores de fundo (print-color-adjust: exact);
  /// - esconde elementos que não fazem parte do documento (barra, botão
  ///   flutuante do site, modal de promoção, cabeçalho/rodapé do site);
  /// - evita cortar seções, cards e imagens no meio da página.
  static const _printCss = '''
@media print{
  html,body{background:#fff !important;-webkit-print-color-adjust:exact !important;print-color-adjust:exact !important}
  *{-webkit-print-color-adjust:exact !important;print-color-adjust:exact !important}
  .fxdoc-bar,.flenx-fab,.fxpromo-ov,.site-header,.al-footer,.ant-foot,.med-footer{display:none !important}
  section,.fxspot,.fxck__item,.fxbc,img{break-inside:avoid;page-break-inside:avoid}
  h1,h2,h3{break-after:avoid;page-break-after:avoid}
  a[href]:after{content:'' !important}
}
@page{margin:12mm}
''';

  @override
  Component build(BuildContext context) {
    final content = doc.builder();
    final wrapped = switch (doc.format) {
      DocPrintFormat.sheet => FlenxSheet(content),
      DocPrintFormat.card => content,
      DocPrintFormat.bare => content,
    };
    return Component.fragment([
      Component.element(tag: 'style', children: const [RawText(_printCss)]),
      FlenxDocBar(title: doc.title, backHref: backHref, accent: accent, barColor: barColor),
      wrapped,
    ]);
  }
}
