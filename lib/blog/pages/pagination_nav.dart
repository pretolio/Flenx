import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Navegação de paginação reutilizável (índice do blog, categorias e tags).
/// [href] monta o link de cada página, preservando filtros/busca quando preciso.
class PaginationNav extends StatelessComponent {
  const PaginationNav({
    required this.current,
    required this.totalPages,
    required this.href,
    super.key,
  });

  final int current;
  final int totalPages;
  final String Function(int page) href;

  @override
  Component build(BuildContext context) {
    return Component.element(
      tag: 'nav',
      classes: 'pagination',
      children: [
        if (current > 1)
          a(
            [.text('‹ Anterior')],
            href: href(current - 1),
            classes: 'page-btn',
          ),
        for (var n = 1; n <= totalPages; n++)
          a(
            [.text('$n')],
            href: href(n),
            classes: n == current ? 'page-btn active' : 'page-btn',
          ),
        if (current < totalPages)
          a([.text('Próxima ›')], href: href(current + 1), classes: 'page-btn'),
      ],
    );
  }
}
