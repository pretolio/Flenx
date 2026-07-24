/// Geração de PDF comercial (A4) em Dart puro — importe `package:flenx/pdf.dart`
/// no gerador (lado servidor/tool). Descreva as páginas com os modelos e chame
/// [FlenxPdf.build]. Não exportado pelo barrel principal para não pesar o build
/// web (depende de dart:io/pdf/image).
library;

export 'pdf/flenx_pdf_models.dart';
export 'pdf/flenx_pdf_builder.dart';
export 'pdf/flenx_card_pdf.dart';
