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

  @override
  Component build(BuildContext context) {
    final content = doc.builder();
    final wrapped = switch (doc.format) {
      DocPrintFormat.sheet => FlenxSheet(content),
      DocPrintFormat.card => content,
      DocPrintFormat.bare => content,
    };
    return Component.fragment([
      FlenxDocBar(title: doc.title, backHref: backHref, accent: accent, barColor: barColor),
      wrapped,
    ]);
  }
}
