/// Resultado de uma paginação: itens da página + página atual + total.
typedef PageSlice<T> = ({List<T> items, int current, int totalPages});

/// Utilitário de paginação genérico, usado no índice, categorias e tags.
class Paginate {
  const Paginate._();

  static PageSlice<T> of<T>(List<T> all, {required int page, int perPage = 4}) {
    final totalPages = all.isEmpty ? 1 : (all.length / perPage).ceil();
    final current = page < 1 ? 1 : (page > totalPages ? totalPages : page);
    final items = all.skip((current - 1) * perPage).take(perPage).toList();
    return (items: items, current: current, totalPages: totalPages);
  }
}
