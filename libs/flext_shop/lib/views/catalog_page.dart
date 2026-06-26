import 'package:flext/flext.dart';
import 'package:jaspr/jaspr.dart';

import '../data/product.dart';
import 'product_card.dart';
import 'shop_nav.dart';

/// Catálogo: todos os produtos (do banco) numa grade responsiva.
class CatalogPage extends StatelessComponent {
  const CatalogPage({required this.products, super.key});

  final List<Product> products;

  @override
  Component build(BuildContext context) {
    return FlextPage([
      const SiteHeader(
        brand: shopBrand,
        links: shopLinks,
        loginLabel: 'Minha conta',
        loginOptions: shopLogin,
      ),
      FlextSection(
        child: FlextColumn(gap: 24, cross: FlextAlign.stretch, [
          const FlextText('Catálogo',
              color: FlextPalette.primary, weight: 700),
          const FlextHeading('Todos os produtos'),
          FlextGrid(
            minItemWidth: 280,
            [for (final p in products) ProductCard(p)],
          ),
        ]),
      ),
      const ShopFooter(),
      WhatsappButton(url: 'https://wa.me/5511999999999'),
    ]);
  }
}
