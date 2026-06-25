import 'package:flext/flext.dart';
import 'package:jaspr/jaspr.dart';

import '../data/products.dart';
import 'shop_nav.dart';

/// Página de um produto (`/produto/<slug>`). Detalhe + comprar via WhatsApp.
class ProductPage extends StatelessComponent {
  const ProductPage(this.product, {super.key});

  final Product product;

  @override
  Component build(BuildContext context) {
    final wa = 'https://wa.me/5511999999999?text=Quero%20o%20${product.name}';
    return FlextPage([
      const SiteHeader(
        brand: shopBrand,
        links: shopLinks,
        loginLabel: 'Minha conta',
        loginOptions: shopLogin,
      ),
      FlextSection(
        child: FlextRow(
          gap: 40,
          wrap: true,
          cross: FlextAlign.start,
          [
            FlextCard(
              FlextText(product.emoji, size: 120, align: FlextTextAlign.center),
              background: FlextPalette.surface,
              padding: 48,
            ),
            FlextColumn(gap: 14, maxWidthPx: 480, [
              if (product.tag != null)
                FlextText(product.tag!, color: FlextPalette.accent, weight: 700),
              FlextHeading(product.name, level: 1),
              FlextText(product.priceLabel,
                  size: 28, weight: 800, color: FlextPalette.primary),
              FlextText(product.description,
                  color: FlextPalette.muted, lineHeight: 1.6),
              FlextRow(gap: 12, wrap: true, [
                FlextButton('Comprar no WhatsApp', href: wa, newTab: true),
                FlextButton('Voltar ao catálogo',
                    href: '/produtos', variant: FlextButtonVariant.ghost),
              ]),
            ]),
          ],
        ),
      ),
      const ShopFooter(),
    ]);
  }
}
