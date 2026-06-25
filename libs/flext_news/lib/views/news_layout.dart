import 'package:flext/flext.dart';
import 'package:jaspr/jaspr.dart';

import 'news_nav.dart';

/// Moldura das páginas de notícia (/blog*) — usa o FlextBlogLayout da lib.
class NewsLayout extends StatelessComponent {
  const NewsLayout({required this.child, super.key});

  final Component child;

  @override
  Component build(BuildContext context) {
    return FlextBlogLayout(
      brand: newsBrand,
      links: newsLinks,
      footer: const NewsFooter(),
      child: child,
    );
  }
}
