import 'package:flenx/blog/utils/date_format.dart';
import 'package:flenx/flenx.dart';
import 'package:jaspr/dom.dart' show a;
import 'package:jaspr/jaspr.dart';

import '../config/news_ads.dart';
import 'news_nav.dart';

/// Home do portal: manchete principal + grade das últimas notícias.
/// Cada notícia mostra a categoria (com link), quem publicou e quando.
class HomePage extends StatelessComponent {
  const HomePage({required this.posts, required this.settings, super.key});

  final List<BlogPost> posts;
  final SiteSettings settings;

  /// Linha de meta: categoria (linkada) · autor · data.
  Component _meta(BlogPost p) => FlenxRow(gap: 10, wrap: true, [
        if (p.category != null)
          a(href: p.category!.path, [
            FlenxText(p.category!.name,
                color: FlenxPalette.accent, weight: 700, size: 13),
          ]),
        if (p.author != null)
          FlenxText('Por ${p.author!}',
              color: FlenxPalette.muted, size: 13),
        FlenxText(DateFormatBr.short(p.date),
            color: FlenxPalette.muted, size: 13),
      ]);

  Component _card(BlogPost p) => FlenxCard(
        FlenxColumn(gap: 8, [
          FlenxHeading(p.title, level: 3),
          _meta(p),
          FlenxText(p.description, color: FlenxPalette.muted),
          FlenxButton('Ler notícia', href: p.path),
        ]),
      );

  @override
  Component build(BuildContext context) {
    final published = posts.where((p) => !p.draft).toList()
      ..sort((p1, p2) => p2.date.compareTo(p1.date));
    final destaque = published.isNotEmpty ? published.first : null;
    final restante = published.skip(1).toList();

    return FlenxPage([
      const SiteHeader(brand: newsBrand, links: newsLinks),
      FlenxHero(
        eyebrow: 'Portal de notícias',
        title: settings.get('hero_title', 'Flenx News'),
        subtitle: settings.get('hero_subtitle',
            'Tecnologia, economia e esportes — em tempo real.'),
        actions: const [FlenxButton('Ver todas', href: '/blog')],
      ),
      if (destaque != null)
        FlenxSection(
          background: FlenxPalette.surface,
          child: FlenxColumn(gap: 12, [
            const FlenxText('Destaque',
                color: FlenxPalette.primary, weight: 700),
            FlenxHeading(destaque.title, level: 1),
            _meta(destaque),
            FlenxText(destaque.description,
                color: FlenxPalette.muted, lineHeight: 1.6),
            FlenxButton('Ler agora', href: destaque.path),
          ]),
        ),
      FlenxSection(
        child: FlenxColumn(gap: 24, cross: FlenxAlign.stretch, [
          const FlenxAds(newsAds, path: '/'), // anúncio configurado para a home
          const FlenxHeading('Últimas notícias'),
          FlenxGrid(
            minItemWidth: 300,
            [for (final p in restante) _card(p)],
          ),
        ]),
      ),
      const NewsFooter(),
    ]);
  }
}
