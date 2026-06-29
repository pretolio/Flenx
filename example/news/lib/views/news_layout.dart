import 'package:flenx/flenx.dart';

import 'news_nav.dart';

/// Moldura das páginas de notícia (/blog*) — usa o FlenxBlogLayout da lib.
class NewsLayout extends StatelessComponent {
  const NewsLayout({required this.child, super.key});

  final Component child;

  @override
  Component build(BuildContext context) {
    return FlenxBlogLayout(
      brand: newsBrand,
      links: newsLinks,
      footer: const NewsFooter(),
      child: child,
    );
  }
}
