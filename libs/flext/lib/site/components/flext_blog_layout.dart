import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../blog_styles.dart';
import '../models/login_option.dart';
import '../models/menu_link.dart';
import '../models/site_brand.dart';
import '../models/site_config.dart';
import '../site_layout.dart';

/// Moldura pronta para as páginas de blog: header + rodapé + WhatsApp do site
/// ([SiteLayout]) já com o CSS do blog injetado. Genérica e editável — passe a
/// marca, os menus e o rodapé do seu site.
class FlextBlogLayout extends StatelessComponent {
  const FlextBlogLayout({
    required this.child,
    required this.brand,
    this.links = const [],
    this.loginOptions = const [],
    this.footer,
    this.config = const SiteConfig(),
    super.key,
  });

  final Component child;
  final SiteBrand brand;
  final List<MenuLink> links;
  final List<LoginOption> loginOptions;
  final Component? footer;
  final SiteConfig config;

  @override
  Component build(BuildContext context) {
    return SiteLayout(
      brand: brand,
      links: links,
      loginOptions: loginOptions,
      footer: footer,
      config: config,
      extraCss: blogCss,
      child: Component.element(tag: 'main', classes: 'blog-main', children: [
        div(classes: 'container', [child]),
      ]),
    );
  }
}
