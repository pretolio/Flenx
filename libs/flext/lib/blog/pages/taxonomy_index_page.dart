import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Um item de índice de taxonomia (categoria ou tag) com contagem de posts.
typedef TaxonomyLink = ({String label, String path, int count});

/// Página índice que lista todas as categorias OU todas as tags, com links
/// para suas páginas de arquivo. Usada em `/blog/categoria` e `/blog/tag`.
class TaxonomyIndexPage extends StatelessComponent {
  const TaxonomyIndexPage({
    required this.title,
    required this.description,
    required this.links,
    super.key,
  });

  final String title;
  final String description;
  final List<TaxonomyLink> links;

  @override
  Component build(BuildContext context) {
    return section(classes: 'taxonomy-index', [
      nav(classes: 'breadcrumb', [
        a(href: '/', [.text('Início')]),
        .text(' / '),
        a(href: '/blog', [.text('Blog')]),
      ]),
      header([
        h1([.text(title)]),
        p([.text(description)]),
      ]),
      if (links.isEmpty)
        p([.text('Nada por aqui ainda.')])
      else
        ul(classes: 'taxonomy-list', [
          for (final link in links)
            li([
              a(href: link.path, [.text(link.label)]),
              span(classes: 'count', [.text(' (${link.count})')]),
            ]),
        ]),
    ]);
  }
}
