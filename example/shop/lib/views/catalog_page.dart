import 'package:flenx/flenx.dart';
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
    return FlenxPage([
      const SiteHeader(
        brand: shopBrand,
        links: shopLinks,
        loginLabel: 'Minha conta',
        loginOptions: shopLogin,
      ),
      FlenxSection(
        child: FlenxColumn(gap: 24, cross: FlenxAlign.stretch, [
          const FlenxText('Catálogo',
              color: FlenxPalette.primary, weight: 700),
          const FlenxHeading('Todos os produtos'),
          FlenxGrid(
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
