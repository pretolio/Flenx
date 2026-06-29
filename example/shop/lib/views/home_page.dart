import 'package:flenx/flenx.dart';

import '../data/product.dart';
import 'store_data.dart';

/// Home da loja no layout de marketplace de moda — montada SÓ com componentes
/// Dart do kit de e-commerce do Flenx (FlenxStoreShell, FlenxHeroBanner,
/// FlenxProductShelf, FlenxProductCard...). Nenhum HTML/CSS no app.
class HomePage extends StatelessComponent {
  const HomePage({required this.products, required this.settings, super.key});

  final List<Product> products;
  final SiteSettings settings;

  @override
  Component build(BuildContext context) {
    final cards = [for (final p in products) productCard(p)];
    return FlenxStoreShell(
      brand: 'flenx',
      cep: '01310-100, São Paulo',
      categories: storeCategories,
      promo: 'Ganhe 10% OFF na primeira compra com o cupom PRIMEIRA10',
      accountHref: '/admin',
      footerColumns: storeFooterColumns,
      payments: const ['VISA', 'MASTER', 'ELO', 'PIX', 'BOLETO'],
      copyright:
          '© 2026 Flenx Store — loja de exemplo feita 100% em Dart com o Flenx (SSR + SEO).',
      children: [
        const FlenxHeroCarousel(slides: storeHeroSlides),
        FlenxPricePills(items: storePricePills),
        FlenxBrandStrip(items: storeBrands),
        FlenxProductShelf(
          title: 'Ofertas do dia',
          countdown: '08:45:12',
          subtitle: 'Você não pode perder. Aproveite!',
          products: cards,
        ),
        FlenxProductGrid(title: 'Mais vendidos', products: cards),
        FlenxBenefitsBar(items: storeBenefits),
      ],
    );
  }
}
