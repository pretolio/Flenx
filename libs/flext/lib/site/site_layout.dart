import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'components/site_header.dart';
import 'components/whatsapp_button.dart';
import 'models/login_option.dart';
import 'models/menu_link.dart';
import 'models/nav_align.dart';
import 'models/site_brand.dart';
import 'models/site_config.dart';
import 'site_styles.dart';

/// Moldura padrão de um site: header + estilo base + conteúdo + rodapé +
/// botão de WhatsApp. Genérica — recebe marca, menus e rodapé por parâmetro,
/// para o app de exemplo (ou qualquer dev) montar com o próprio conteúdo.
class SiteLayout extends StatelessComponent {
  const SiteLayout({
    required this.brand,
    required this.links,
    required this.child,
    this.footer,
    this.loginLabel = 'Entrar',
    this.loginOptions = const [],
    this.navAlign = NavAlign.right,
    this.config = const SiteConfig(),
    this.extraCss = '',
    super.key,
  });

  final SiteBrand brand;
  final List<MenuLink> links;
  final Component child;

  /// Rodapé opcional (o dev fornece o seu).
  final Component? footer;

  final String loginLabel;
  final List<LoginOption> loginOptions;
  final NavAlign navAlign;
  final SiteConfig config;

  /// CSS adicional injetado após o base (ex.: estilos do blog).
  final String extraCss;

  @override
  Component build(BuildContext context) {
    return div(classes: 'flext-site', [
      Component.element(tag: 'style', children: [RawText(flextSiteCss + extraCss)]),
      SiteHeader(
        brand: brand,
        links: links,
        loginLabel: loginLabel,
        loginOptions: loginOptions,
        align: navAlign,
      ),
      child,
      if (footer != null) footer!,
      WhatsappButton(url: config.whatsappUrl),
    ]);
  }
}
