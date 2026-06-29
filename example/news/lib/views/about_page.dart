import 'package:flenx/flenx.dart';

import 'news_nav.dart';

/// Página "Sobre" do portal.
class AboutPage extends StatelessComponent {
  const AboutPage({super.key});

  @override
  Component build(BuildContext context) {
    return FlenxPage([
      const SiteHeader(brand: newsBrand, links: newsLinks),
      FlenxSection(
        child: FlenxColumn(gap: 14, maxWidthPx: 720, [
          const FlenxText('Sobre', color: FlenxPalette.primary, weight: 700),
          const FlenxHeading('O Flenx News', level: 1),
          const FlenxText(
              'Portal de notícias de exemplo do Flenx: artigos em Markdown, '
              'categorias e tags, busca e SEO/llms.txt automáticos — tudo em Dart.',
              color: FlenxPalette.muted,
              lineHeight: 1.6),
        ]),
      ),
      const NewsFooter(),
    ]);
  }
}
