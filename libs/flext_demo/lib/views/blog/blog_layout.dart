import 'package:flext/flext.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../site/sections/site_footer.dart';
import '../site/site_nav.dart';

/// Moldura do blog: usa o [SiteLayout] (header/rodapé/WhatsApp do site) e injeta
/// o CSS do blog, deixando as páginas de blog bonitas e consistentes.
class BlogLayout extends StatelessComponent {
  const BlogLayout({required this.child, this.config = const SiteConfig(), super.key});

  final Component child;
  final SiteConfig config;

  @override
  Component build(BuildContext context) {
    return SiteLayout(
      brand: siteBrand,
      links: siteNavLinks,
      loginOptions: siteLoginOptions,
      footer: const SiteFooter(),
      config: config,
      extraCss: blogCss,
      child: Component.element(tag: 'main', classes: 'blog-main', children: [
        div(classes: 'container', [child]),
      ]),
    );
  }
}
