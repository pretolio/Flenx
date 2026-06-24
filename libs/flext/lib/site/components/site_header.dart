import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../models/login_option.dart';
import '../models/menu_link.dart';
import '../models/nav_align.dart';
import '../models/site_brand.dart';
import 'brand_logo.dart';
import 'login_button.dart';
import 'nav_links.dart';
import 'site_header_styles.dart';

/// Header de site institucional: somente top menu. Logo com link home, menu
/// customizável (itens clicáveis ou dropdowns expansíveis) e botão de login
/// (clicável ou expansível). Responsivo: vira hambúrguer (`<details>`) no mobile.
///
/// HTML puro + CSS (sem JS) — renderizado no servidor e indexável.
class SiteHeader extends StatelessComponent {
  const SiteHeader({
    required this.brand,
    required this.links,
    this.loginLabel = 'Entrar',
    this.loginHref,
    this.loginOptions = const [],
    this.align = NavAlign.right,
    super.key,
  });

  final SiteBrand brand;
  final List<MenuLink> links;
  final String loginLabel;
  final String? loginHref;
  final List<LoginOption> loginOptions;

  /// Alinhamento dos menus: à direita (padrão) ou centralizados.
  final NavAlign align;

  @override
  Component build(BuildContext context) {
    final innerClass =
        align == NavAlign.center ? 'header-inner nav-center' : 'header-inner';
    return header(classes: 'site-header', [
      Component.element(tag: 'style', children: [RawText(siteHeaderCss)]),
      div(classes: innerClass, [
        BrandLogo(brand),
        // Checkbox-hack: o label (hambúrguer) alterna o checkbox, e o CSS
        // mostra a .nav-wrap no mobile via `:checked ~`. Sem JavaScript.
        Component.element(tag: 'input', attributes: {
          'type': 'checkbox',
          'id': 'flext-nav-toggle',
          'class': 'nav-toggle',
          'aria-label': 'Abrir menu',
        }),
        label([span([.text('☰')])],
            htmlFor: 'flext-nav-toggle', classes: 'hamburger'),
        div(classes: 'nav-wrap', [
          NavLinks(links),
          LoginButton(
            label: loginLabel,
            href: loginHref,
            options: loginOptions,
          ),
        ]),
      ]),
    ]);
  }
}
