import 'package:flenx/flenx.dart';

import '../data/product.dart';

/// Card de um produto — montado só com o kit Dart. O botão "Adicionar ao
/// carrinho" leva para `/carrinho?add=<slug>` (a ilha do carrinho processa).
class ProductCard extends StatelessComponent {
  const ProductCard(this.product, {super.key});

  final Product product;

  @override
  Component build(BuildContext context) {
    return FlenxCard(
      FlenxColumn(gap: 8, [
        FlenxText(product.emoji, size: 44),
        if (product.tag != null)
          FlenxText(product.tag!,
              color: FlenxPalette.accent, weight: 700, size: 13),
        FlenxHeading(product.name, level: 3),
        FlenxText(product.summary, color: FlenxPalette.muted),
        FlenxText(product.priceLabel,
            size: 20, weight: 800, color: FlenxPalette.primary),
        FlenxRow(gap: 8, wrap: true, [
          FlenxButton('Adicionar ao carrinho',
              href: '/carrinho?add=${product.slug}'),
          FlenxButton('Ver',
              href: '/produto/${product.slug}',
              variant: FlenxButtonVariant.ghost),
        ]),
      ]),
    );
  }
}
