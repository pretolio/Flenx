import 'package:flext/flext.dart';
import 'package:jaspr/jaspr.dart';

import '../config/news_ads.dart';
import 'news_nav.dart';

/// Home do portal: manchete principal + grade das últimas notícias.
/// Recebe os posts (markdown + banco) e a config da home (editável no admin).
class HomePage extends StatelessComponent {
  const HomePage({required this.posts, required this.settings, super.key});

  final List<BlogPost> posts;
  final SiteSettings settings;

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
      FlextHero(
        eyebrow: 'Portal de notícias',
        title: settings.get('hero_title', 'Flext News'),
        subtitle: settings.get('hero_subtitle',
            'Tecnologia, economia e esportes — em tempo real.'),
        actions: const [FlextButton('Ver todas', href: '/blog')],
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
          const FlextAds(newsAds, path: '/'), // anúncio configurado para a home
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
