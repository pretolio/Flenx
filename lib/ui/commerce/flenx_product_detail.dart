import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../site/models/menu_link.dart';

/// Página de detalhe de um produto (estilo marketplace): trilha, foto grande,
/// marca, nome, preço (antigo/atual), parcelas, selo e botões de compra +
/// descrição. Tudo por parâmetros Dart.
class FlenxProductDetail extends StatelessComponent {
  const FlenxProductDetail({
    required this.name,
    required this.price,
    required this.buyHref,
    this.emoji,
    this.imageUrl,
    this.brand,
    this.oldPrice,
    this.installment,
    this.badge,
    this.description,
    this.buyLabel = 'Adicionar ao carrinho',
    this.secondaryHref,
    this.secondaryLabel,
    this.breadcrumb = const [],
    super.key,
  });

  final String name;
  final String price;
  final String buyHref;
  final String? emoji;
  final String? imageUrl;
  final String? brand;
  final String? oldPrice;
  final String? installment;
  final String? badge;
  final String? description;
  final String buyLabel;
  final String? secondaryHref;
  final String? secondaryLabel;
  final List<MenuLink> breadcrumb;

  @override
  Component build(BuildContext context) {
    return div(classes: 'fxz-wrap', [
      if (breadcrumb.isNotEmpty)
        div(classes: 'fxz-crumb', [
          for (var i = 0; i < breadcrumb.length; i++) ...[
            if (i > 0) Component.text(' / '),
            a([
              Component.text(breadcrumb[i].label),
            ], href: breadcrumb[i].href ?? '#'),
          ],
          Component.text(' / $name'),
        ]),
      div(classes: 'fxz-pd', [
        div(classes: 'fxz-pd-pic', [
          if (badge != null) span(classes: 'b', [Component.text(badge!)]),
          if (imageUrl != null)
            img(src: imageUrl!, alt: name)
          else
            Component.text(emoji ?? '\u{1F6CD}'),
        ]),
        div(classes: 'fxz-pd-info', [
          if (brand != null) span(classes: 'brand', [Component.text(brand!)]),
          Component.element(tag: 'h1', children: [Component.text(name)]),
          if (oldPrice != null)
            div(classes: 'old', [Component.text(oldPrice!)]),
          div(classes: 'price', [Component.text(price)]),
          if (installment != null)
            div(classes: 'inst', [Component.text(installment!)]),
          if (description != null)
            div(classes: 'desc', [Component.text(description!)]),
          div(classes: 'fxz-pd-buys', [
            a([Component.text(buyLabel)], href: buyHref, classes: 'buy'),
            if (secondaryHref != null && secondaryLabel != null)
              a(
                [Component.text(secondaryLabel!)],
                href: secondaryHref!,
                classes: 'ghost',
              ),
          ]),
        ]),
      ]),
    ]);
  }
}
