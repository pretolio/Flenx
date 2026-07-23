/// Como o documento comercial se comporta na tela e na impressão.
enum DocPrintFormat {
  /// Folha A4 branca centralizada (propostas, contratos, cartas).
  sheet,

  /// Palco de cartões 85×55 mm (cartão de visita — frente/verso).
  card,

  /// Sem invólucro: o próprio conteúdo controla o layout (landing/one-pager).
  bare,
}
