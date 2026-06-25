import 'package:flext/flext.dart';
import 'package:jaspr/jaspr.dart';

import '../data/products.dart';
import 'product_card.dart';
import 'shop_nav.dart';

/// Catálogo: todos os produtos numa grade responsiva.
class CatalogPage extends StatelessComponent {
  const CatalogPage({super.key});

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
