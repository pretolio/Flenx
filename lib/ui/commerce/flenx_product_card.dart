import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Card de produto estilo marketplace de moda: foto/ícone, selo de desconto,
/// marca, nome, preço antigo riscado, preço, parcelas e botão comprar.
/// Tudo por parâmetros Dart — o componente desenha o HTML por baixo.
class FlenxProductCard extends StatelessComponent {
  const FlenxProductCard({
    required this.name,
    required this.price,
    required this.href,
    this.emoji,
    this.imageUrl,
    this.brand,
    this.oldPrice,
    this.installment,
    this.badge,
    this.buyHref,
    this.buyLabel = 'Comprar',
    super.key,
  });

  final String name;

  /// Preço atual já formatado (ex.: `R$ 299,90`).
  final String price;

  /// Link para a página do produto.
  final String href;

  /// Ícone/emoji exibido como "foto" (use [imageUrl] para foto real).
  final String? emoji;
  final String? imageUrl;
  final String? brand;

  /// Preço antigo formatado (riscado). Nulo = sem desconto.
  final String? oldPrice;

  /// Linha de parcelas (ex.: `10x de R$ 29,99 sem juros`).
  final String? installment;

  /// Selo (ex.: `-20% OFF`).
  final String? badge;

  /// Link de compra (adicionar ao carrinho). Nulo = usa [href].
  final String? buyHref;
  final String buyLabel;

  @override
  Component build(BuildContext context) {
    return div(classes: 'fxz-card', [
      if (badge != null) span(classes: 'fxz-badge', [Component.text(badge!)]),
      span(classes: 'heart', [Component.text('♡')]),
      a([
        div(classes: 'fxz-pic', [
          if (imageUrl != null)
            img(src: imageUrl!, alt: name)
          else
            Component.text(emoji ?? '\u{1F6CD}'),
        ]),
      ], href: href),
      if (brand != null) span(classes: 'brand', [Component.text(brand!)]),
      a([
        div(classes: 'name', [Component.text(name)]),
      ], href: href),
      if (oldPrice != null) span(classes: 'old', [Component.text(oldPrice!)]),
      div(classes: 'price', [Component.text(price)]),
      if (installment != null)
        div(classes: 'inst', [Component.text(installment!)]),
      a([Component.text(buyLabel)], href: buyHref ?? href, classes: 'buy'),
    ]);
  }
}
