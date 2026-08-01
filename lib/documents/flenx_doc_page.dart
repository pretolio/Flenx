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
  @page{size:A4;margin:0}
  html,body{margin:0 !important;background:#fff !important;-webkit-print-color-adjust:exact !important;print-color-adjust:exact !important}
  *{-webkit-print-color-adjust:exact !important;print-color-adjust:exact !important}
  .fxdoc-bar,.flenx-fab,.fxpromo-ov,.site-header,.al-footer,.ant-foot,.med-footer{display:none !important}
  /* Folheto A4: cada seção ocupa uma página inteira, com o fundo (cor) sangrando
     até as bordas. Conteúdo centralizado na vertical. */
  section{break-before:page;page-break-before:always;break-inside:avoid;
    min-height:100vh;box-sizing:border-box;display:flex;flex-direction:column;
    justify-content:center;padding:16mm 15mm !important;margin:0 !important;width:100%}
  section:first-of-type{break-before:avoid;page-break-before:avoid}
  .fxcover{justify-content:flex-end}
  .fxcover__bg,.fxcover__ov{padding:0 !important}
  .fxspot,.fxck__item,.fxbc,img{break-inside:avoid;page-break-inside:avoid}
  a[href]:after{content:'' !important}
}
''';

  @override
  Component build(BuildContext context) {
    final content = doc.builder();
    final wrapped = switch (doc.format) {
      DocPrintFormat.sheet => FlenxSheet(content),
      DocPrintFormat.card => content,
      DocPrintFormat.bare => content,
    };
    // `bare` já traz o próprio invólucro em tela cheia (ex.: FlenxPdfViewer,
    // com sua própria barra de voltar/baixar/imprimir) — a barra genérica
    // aqui em cima ficaria duplicada.
    return Component.fragment([
      Component.element(tag: 'style', children: const [RawText(_printCss)]),
      if (doc.format != DocPrintFormat.bare) FlenxDocBar(title: doc.title, backHref: backHref, accent: accent, barColor: barColor),
      wrapped,
    ]);
  }
}
