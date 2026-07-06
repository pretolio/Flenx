import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../site/models/menu_link.dart';
import '../blocks/flenx_footer.dart' show FlenxFooterColumn;
import 'commerce_styles.dart';

/// Raiz de uma página de loja (marketplace de moda). Injeta o CSS do kit de
/// e-commerce e desenha o cabeçalho (logo, CEP, busca, conta/desejos/carrinho),
/// a barra de categorias, a faixa de cupom e o rodapé. O miolo vem em
/// [children] (hero, pílulas, prateleiras, grade...). O app só passa Dart.
class FlenxStoreShell extends StatelessComponent {
  const FlenxStoreShell({
    required this.brand,
    required this.categories,
    this.children = const [],
    this.searchPlaceholder = 'O que você procura hoje?',
    this.searchAction = '/produtos',
    this.cep,
    this.accountHref = '/conta',
    this.accountLabel = 'Entrar',
    this.wishlistHref = '/produtos',
    this.cartHref = '/carrinho',
    this.cartCount = 0,
    this.promo,
    this.footerColumns = const [],
    this.payments = const [],
    this.copyright,
    super.key,
  });

  final String brand;
  final List<MenuLink> categories;
  final List<Component> children;
  final String searchPlaceholder;
  final String searchAction;
  final String? cep;
  final String accountHref;
  final String accountLabel;
  final String wishlistHref;
  final String cartHref;
  final int cartCount;
  final String? promo;
  final List<FlenxFooterColumn> footerColumns;
  final List<String> payments;
  final String? copyright;

  @override
  Component build(BuildContext context) {
    return div(classes: 'fxz', [
      Component.element(tag: 'style', children: [RawText(flenxCommerceCss)]),
      _topBar(),
      div(classes: 'fxz-nav', [
        nav(classes: 'fxz-wrap fxz-nav-in', [
          for (final c in categories)
            a(
              [Component.text(c.label)],
              href: c.href ?? '#',
              classes: c.label.toLowerCase().contains('oferta') ? 'sale' : null,
            ),
        ]),
      ]),
      if (promo != null) div(classes: 'fxz-promo', [Component.text(promo!)]),
      ...children,
      if (footerColumns.isNotEmpty || payments.isNotEmpty) _footer(),
    ]);
  }

  Component _topBar() => div(classes: 'fxz-top', [
    div(classes: 'fxz-wrap fxz-top-in', [
      a([Component.text(brand)], href: '/', classes: 'fxz-logo'),
      if (cep != null)
        div(classes: 'fxz-cep', [
          span(classes: 'ic', [Component.text('\u{1F4CD}')]),
          span([
            Component.text('Enviar para'),
            Component.element(tag: 'strong', children: [Component.text(cep!)]),
          ]),
        ]),
      form(
        classes: 'fxz-search',
        attributes: {'action': searchAction, 'method': 'get'},
        [
          Component.element(
            tag: 'input',
            attributes: {
              'name': 'q',
              'type': 'text',
              'placeholder': searchPlaceholder,
            },
          ),
          button([Component.text('\u{1F50D}')]),
        ],
      ),
      div(classes: 'fxz-acts', [
        a(
          [
            span(classes: 'ic', [Component.text('♡')]),
            span([Component.text('Desejos')]),
          ],
          href: wishlistHref,
          classes: 'fxz-act',
        ),
        a(
          [
            span(classes: 'ic', [Component.text('\u{1F464}')]),
            span([Component.text(accountLabel)]),
          ],
          href: accountHref,
          classes: 'fxz-act',
        ),
        a(
          [
            span(classes: 'ic', [Component.text('\u{1F6D2}')]),
            if (cartCount > 0)
              span(classes: 'badge', [Component.text('$cartCount')]),
          ],
          href: cartHref,
          classes: 'fxz-act fxz-cart',
        ),
      ]),
    ]),
  ]);

  Component _footer() => footer(classes: 'fxz-foot', [
    div(classes: 'fxz-foot-cols', [
      for (final col in footerColumns)
        div([
          Component.element(tag: 'h4', children: [Component.text(col.title)]),
          for (final l in col.links)
            a([Component.text(l.label)], href: l.href ?? '#'),
        ]),
      if (payments.isNotEmpty)
        div([
          Component.element(tag: 'h4', children: [Component.text('Pagamento')]),
          div(classes: 'fxz-pay', [
            for (final p in payments) span([Component.text(p)]),
          ]),
        ]),
    ]),
    if (copyright != null)
      div(classes: 'fxz-foot-bottom', [Component.text(copyright!)]),
  ]);
}
