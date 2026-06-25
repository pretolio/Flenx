import 'package:flext/flext.dart';
import 'package:jaspr/jaspr.dart';

import '../data/products.dart';
import 'product_card.dart';
import 'shop_nav.dart';

/// Home da loja: hero + produtos em destaque + CTA. Só componentes Dart.
class HomePage extends StatelessComponent {
  const HomePage({super.key});

  @override
  Component build(BuildContext context) {
    final destaques = products.take(3).toList();
    return FlextPage([
      const SiteHeader(
        brand: shopBrand,
        links: shopLinks,
        loginLabel: 'Minha conta',
        loginOptions: shopLogin,
      ),
      const FlextHero(
        eyebrow: 'Tecnologia que rende',
        title: 'Os melhores periféricos, num clique',
        subtitle: 'Loja de exemplo feita 100% em Dart com o Flext — SSR, SEO '
            'e catálogo prontos.',
        actions: [FlextButton('Ver produtos', href: '/produtos')],
      ),
      FlextSection(
        child: FlextColumn(gap: 24, cross: FlextAlign.stretch, [
          const FlextHeading('Em destaque', align: FlextTextAlign.center),
          FlextGrid(
            minItemWidth: 280,
            [for (final p in destaques) ProductCard(p)],
          ),
        ]),
      ),
      const FlextCta(
        title: 'Frete grátis acima de R\$ 299',
        subtitle: 'Aproveite e monte seu setup hoje.',
        action: FlextButton('Comprar agora', href: '/produtos'),
      ),
      const ShopFooter(),
      WhatsappButton(url: 'https://wa.me/5511999999999'),
    ]);
  }
}
