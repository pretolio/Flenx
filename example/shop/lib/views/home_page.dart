import 'package:flenx/flenx.dart';

import '../data/product.dart';
import 'product_card.dart';
import 'shop_nav.dart';

/// Home da loja: banner promo + hero (editável no admin) + destaques animados.
class HomePage extends StatelessComponent {
  const HomePage({required this.products, required this.settings, super.key});

  final List<Product> products;
  final SiteSettings settings;

  @override
  Component build(BuildContext context) {
    final destaques = products.take(3).toList();
    return FlenxPage(
      primaryColor: '#01589B',
      primaryDarkColor: '#02406f',
      secondaryColor: '#0a86e0',
      [
        FlenxBanner(
          message: '🚚 Frete grátis acima de R\$ 299 — em todo o Brasil',
          action: FlenxButton('Ver produtos', href: '/produtos'),
        ),
        const SiteHeader(
          brand: shopBrand,
          links: shopLinks,
          loginLabel: 'Minha conta',
          loginOptions: shopLogin,
        ),
        FlenxHero(
          eyebrow: 'Tecnologia que rende',
          title: settings.get('hero_title', 'Os melhores periféricos, num clique'),
          subtitle: settings.get('hero_subtitle',
              'Loja de exemplo feita 100% em Dart com o Flenx — SSR, SEO e catálogo prontos.'),
          actions: [
            FlenxButton(settings.get('hero_cta', 'Ver produtos'),
                href: '/produtos'),
          ],
        ),
        FlenxSection(
          child: FlenxColumn(gap: 24, cross: FlenxAlign.stretch, [
            const FlenxHeading('Em destaque', align: FlenxTextAlign.center),
            FlenxGrid(
              minItemWidth: 280,
              animation: FlenxAnimation.slideUp,
              [for (final p in destaques) ProductCard(p)],
            ),
          ]),
        ),
        const FlenxCta(
          title: 'Frete grátis acima de R\$ 299',
          subtitle: 'Aproveite e monte seu setup hoje.',
          action: FlenxButton('Comprar agora', href: '/produtos'),
        ),
        const ShopFooter(),
        WhatsappButton(url: 'https://wa.me/5511999999999'),
      ],
    );
  }
}
