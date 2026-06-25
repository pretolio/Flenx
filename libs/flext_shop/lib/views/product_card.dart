import 'package:flext/flext.dart';
import 'package:jaspr/jaspr.dart';

import '../data/products.dart';

/// Card de um produto — montado só com o kit Dart.
class ProductCard extends StatelessComponent {
  const ProductCard(this.product, {super.key});

  final Product product;

  @override
  Component build(BuildContext context) {
    return FlextCard(
      FlextColumn(gap: 8, [
        FlextText(product.emoji, size: 44),
        if (product.tag != null)
          FlextText(product.tag!, color: FlextPalette.accent, weight: 700, size: 13),
        FlextHeading(product.name, level: 3),
        FlextText(product.summary, color: FlextPalette.muted),
        FlextText(product.priceLabel,
            size: 20, weight: 800, color: FlextPalette.primary),
        FlextButton('Ver produto', href: '/produto/${product.slug}'),
      ]),
    );
  }
}
