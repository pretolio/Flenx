import 'package:flext/flext.dart';
import 'package:jaspr/jaspr.dart';

import 'news_nav.dart';

/// Home do portal: manchete principal + grade das últimas notícias.
/// Recebe os posts (markdown) carregados no main.dart.
class HomePage extends StatelessComponent {
  const HomePage({required this.posts, super.key});

  final List<BlogPost> posts;

  Component _card(BlogPost p) => FlextCard(
        FlextColumn(gap: 8, [
          if (p.category != null)
            FlextText(p.category!.name,
                color: FlextPalette.accent, weight: 700, size: 13),
          FlextHeading(p.title, level: 3),
          FlextText(p.description, color: FlextPalette.muted),
          FlextButton('Ler notícia', href: p.path),
        ]),
      );

  @override
  Component build(BuildContext context) {
    final published = posts.where((p) => !p.draft).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    final destaque = published.isNotEmpty ? published.first : null;
    final restante = published.skip(1).toList();

    return FlextPage([
      const SiteHeader(brand: newsBrand, links: newsLinks),
      const FlextHero(
        eyebrow: 'Portal de notícias',
        title: 'Flext News',
        subtitle: 'Tecnologia, economia e esportes — exemplo de portal feito '
            'só em Dart com o Flext.',
        actions: [FlextButton('Ver todas', href: '/blog')],
      ),
      if (destaque != null)
        FlextSection(
          background: FlextPalette.surface,
          child: FlextColumn(gap: 12, [
            const FlextText('Destaque',
                color: FlextPalette.primary, weight: 700),
            FlextHeading(destaque.title, level: 1),
            FlextText(destaque.description,
                color: FlextPalette.muted, lineHeight: 1.6),
            FlextButton('Ler agora', href: destaque.path),
          ]),
        ),
      FlextSection(
        child: FlextColumn(gap: 24, cross: FlextAlign.stretch, [
          const FlextHeading('Últimas notícias'),
          FlextGrid(
            minItemWidth: 300,
            [for (final p in restante) _card(p)],
          ),
        ]),
      ),
      const NewsFooter(),
    ]);
  }
}
