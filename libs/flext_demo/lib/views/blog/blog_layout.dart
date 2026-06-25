import 'package:flext/flext.dart';
import 'package:jaspr/jaspr.dart';

import '../site/sections/site_footer.dart';
import '../site/site_nav.dart';

/// Moldura do blog do demo: usa o genérico [FlextBlogLayout] da lib, só
/// passando a marca, os menus e o rodapé deste site.
class BlogLayout extends StatelessComponent {
  const BlogLayout({required this.child, super.key});

  final Component child;

  @override
  Component build(BuildContext context) {
    return FlextBlogLayout(
      brand: siteBrand,
      links: siteNavLinks,
      loginOptions: siteLoginOptions,
      footer: const SiteFooter(),
      child: child,
    );
  }
}
