import 'package:flenx/flenx.dart';
import 'package:jaspr/jaspr.dart';

import '../data/product.dart';
import 'shop_nav.dart';

/// Página de um produto (`/produto/<slug>`). Detalhe + comprar via WhatsApp.
class ProductPage extends StatelessComponent {
  const ProductPage(this.product, {super.key});

  final Product product;

  @override
  Component build(BuildContext context) {
    final wa = 'https://wa.me/5511999999999?text=Quero%20o%20${product.name}';
    return FlenxPage([
      const SiteHeader(
        brand: shopBrand,
        links: shopLinks,
        loginLabel: 'Minha conta',
        loginOptions: shopLogin,
      ),
      FlenxSection(
        child: FlenxRow(
          gap: 40,
          wrap: true,
          cross: FlenxAlign.start,
          [
            FlenxCard(
              FlenxText(product.emoji, size: 120, align: FlenxTextAlign.center),
              background: FlenxPalette.surface,
              padding: 48,
            ),
            FlenxColumn(gap: 14, maxWidthPx: 480, [
              if (product.tag != null)
                FlenxText(product.tag!, color: FlenxPalette.accent, weight: 700),
              FlenxHeading(product.name, level: 1),
              FlenxText(product.priceLabel,
                  size: 28, weight: 800, color: FlenxPalette.primary),
              FlenxText(product.description,
                  color: FlenxPalette.muted, lineHeight: 1.6),
              FlenxRow(gap: 12, wrap: true, [
                FlenxButton('Adicionar ao carrinho',
                    href: '/carrinho?add=${product.slug}'),
                FlenxButton('Comprar no WhatsApp',
                    href: wa,
                    newTab: true,
                    variant: FlenxButtonVariant.ghost),
                FlenxButton('Voltar ao catálogo',
                    href: '/produtos', variant: FlenxButtonVariant.ghost),
              ]),
            ]),
          ],
        ),
      ),
      const ShopFooter(),
    ]);
  }
}
