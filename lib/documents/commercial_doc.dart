import 'package:jaspr/jaspr.dart';

import 'doc_print_format.dart';

/// Um documento comercial exibido na Central (`FlenxDocHub`) e servido em
/// `/{base}/{slug}` — proposta, cartão de visita, tabela de preços, etc.
///
/// Você escreve o conteúdo em Dart (componentes Flenx). A Central e a página do
/// documento (barra de imprimir, invólucro de folha/cartão, regras de impressão)
/// são geradas automaticamente.
class CommercialDoc {
  const CommercialDoc({
    required this.slug,
    required this.title,
    required this.kind,
    required this.builder,
    this.description = '',
    this.meta,
    this.format = DocPrintFormat.sheet,
  });

  /// Identificador na URL (ex.: `proposta-comercial`).
  final String slug;

  /// Título exibido no card e na barra do documento.
  final String title;

  /// Categoria (vira filtro na Central). Ex.: `'Proposta'`, `'Cartão'`.
  final String kind;

  /// Texto curto no card da Central.
  final String description;

  /// Linha de rodapé opcional do card (ex.: data, formato).
  final String? meta;

  /// Invólucro/impressão do documento.
  final DocPrintFormat format;

  /// Conteúdo do documento (componentes Flenx).
  final Component Function() builder;
}
