import 'package:flext/flext.dart';
import 'package:jaspr/jaspr.dart';

import 'news_nav.dart';

/// Página "Sobre" do portal.
class AboutPage extends StatelessComponent {
  const AboutPage({super.key});

  @override
  Component build(BuildContext context) {
    return FlextPage([
      const SiteHeader(brand: newsBrand, links: newsLinks),
      FlextSection(
        child: FlextColumn(gap: 14, maxWidthPx: 720, [
          const FlextText('Sobre', color: FlextPalette.primary, weight: 700),
          const FlextHeading('O Flext News', level: 1),
          const FlextText(
              'Portal de notícias de exemplo do Flext: artigos em Markdown, '
              'categorias e tags, busca e SEO/llms.txt automáticos — tudo em Dart.',
              color: FlextPalette.muted,
              lineHeight: 1.6),
        ]),
      ),
      const NewsFooter(),
    ]);
  }
}
