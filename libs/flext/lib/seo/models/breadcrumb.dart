/// Item de trilha de navegação, usado para gerar JSON-LD `BreadcrumbList`
/// (rich result de breadcrumb no SERP). O último item costuma vir sem `path`.
class Breadcrumb {
  const Breadcrumb({required this.name, this.path});

  /// Nome exibido na trilha.
  final String name;

  /// Caminho relativo (ex.: `/blog`). Nulo no item atual (folha).
  final String? path;
}
