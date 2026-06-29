/// Um item do [FlenxAccordion]: título clicável + conteúdo expansível.
class FlenxAccordionItem {
  const FlenxAccordionItem(this.title, this.body, {this.open = false});

  final String title;
  final String body;

  /// Se `true`, começa aberto.
  final bool open;
}
