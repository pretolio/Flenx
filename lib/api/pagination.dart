/// Parâmetros de paginação de uma listagem (vêm de `?page` e `?perPage`).
class PageRequest {
  const PageRequest({this.page = 1, this.perPage = 20});

  final int page;
  final int perPage;

  /// Quantos registros pular no SQL (`OFFSET`).
  int get offset => (page < 1 ? 0 : (page - 1)) * perPage;

  /// Limite por página (`LIMIT`).
  int get limit => perPage;

  /// Constrói a partir dos parâmetros de query, com limites sãos.
  factory PageRequest.fromQuery(
    Map<String, String> query, {
    int defaultPerPage = 20,
    int maxPerPage = 100,
  }) {
    final page = int.tryParse(query['page'] ?? '') ?? 1;
    var per = int.tryParse(query['perPage'] ?? '') ?? defaultPerPage;
    if (per < 1) per = defaultPerPage;
    if (per > maxPerPage) per = maxPerPage;
    return PageRequest(page: page < 1 ? 1 : page, perPage: per);
  }
}

/// Metadados de paginação devolvidos no envelope (`meta`).
class PageMeta {
  const PageMeta({
    required this.page,
    required this.perPage,
    required this.total,
  });

  final int page;
  final int perPage;
  final int total;

  int get totalPages => total <= 0 ? 1 : ((total + perPage - 1) ~/ perPage);
  bool get hasNext => page < totalPages;
  bool get hasPrev => page > 1;

  factory PageMeta.of(PageRequest req, int total) =>
      PageMeta(page: req.page, perPage: req.perPage, total: total);

  Map<String, dynamic> toJson() => {
    'page': page,
    'perPage': perPage,
    'total': total,
    'totalPages': totalPages,
    'hasNext': hasNext,
    'hasPrev': hasPrev,
  };
}
