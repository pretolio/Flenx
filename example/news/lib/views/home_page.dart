import 'package:flenx/blog/utils/date_format.dart';
import 'package:flenx/flenx.dart';

import '../config/news_ads.dart';
import 'news_nav.dart';

/// Home do portal no estilo G1: manchete principal, grade de últimas notícias,
/// barra lateral com player de rádio ao vivo e bloco "Mais lidas".
/// Só compõe blocos Flenx — nenhuma tag HTML aqui.
class HomePage extends StatelessComponent {
  const HomePage({required this.posts, required this.settings, super.key});

  final List<BlogPost> posts;
  final SiteSettings settings;

  /// Imagem de capa do post (ou placeholder estável pelo slug).
  String _cover(BlogPost p) =>
      p.image ?? 'https://picsum.photos/seed/${p.slug}/1200/675';

  String _meta(BlogPost p) => [
        if (p.author != null) 'Por ${p.author}',
        DateFormatBr.short(p.date),
      ].join(' · ');

  @override
  Component build(BuildContext context) {
    final published = posts.where((p) => !p.draft).toList()
      ..sort((p1, p2) => p2.date.compareTo(p1.date));
    final destaque = published.isNotEmpty ? published.first : null;
    final restante = published.skip(1).toList();
    final maisLidas = [
      for (final p in published.take(5))
        MenuLink(label: p.title, href: p.path),
    ];

    return FlenxPage(
      primaryColor: '#C4170C',
      primaryDarkColor: '#A01209',
      secondaryColor: '#1A1A1A',
      [
        const FlenxBanner(message: '🔴 Plantão Flenx News — cobertura ao vivo'),
        const FlenxNewsHeader(
          brandPrimary: 'flenx',
          brandSecondary: 'news',
          links: newsLinks,
        ),
        FlenxSection(
          background: '#ffffff',
          paddingY: 28,
          child: FlenxColumn(gap: 36, cross: FlenxAlign.stretch, [
            if (destaque != null)
              FlenxNewsHighlight(
                title: destaque.title,
                imageUrl: _cover(destaque),
                href: destaque.path,
                hat: destaque.category?.name,
                subtitle: destaque.subtitle ?? destaque.description,
                meta: _meta(destaque),
              ),
            FlenxSidebarLayout(
              main: FlenxColumn(gap: 20, cross: FlenxAlign.stretch, [
                const FlenxNewsSectionTitle('Últimas notícias'),
                FlenxGrid(
                  minItemWidth: 240,
                  gap: 28,
                  main: FlenxAlign.start,
                  animation: FlenxAnimation.slideUp,
                  [
                    for (final p in restante)
                      FlenxNewsCard(
                        title: p.title,
                        imageUrl: _cover(p),
                        href: p.path,
                        hat: p.category?.name,
                        description: p.description,
                      ),
                  ],
                ),
                const FlenxSpacer(8),
                const FlenxAds(newsAds, path: '/'),
              ]),
              aside: FlenxColumn(gap: 28, cross: FlenxAlign.stretch, [
                const FlenxAudioPlayer(
                  'https://stream.zeno.fm/0r0xa792kwzuv',
                  title: 'Flenx News Rádio',
                  subtitle: 'Notícias 24h · ao vivo',
                  isRadio: true,
                  accentColor: '#C4170C',
                ),
                FlenxMostRead(maisLidas),
              ]),
            ),
          ]),
        ),
        const NewsFooter(),
      ],
    );
  }
}
