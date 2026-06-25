/// ⭐ Loja de exemplo do Flext. Você edita só este arquivo + config/ + views/.
/// Os entrypoints são gerados por `dart run flext:bootstrap`.
library;

import 'package:flext/app.dart';

import 'config/shop_routes.dart';
import 'config/shop_seo.dart';
import 'views/shop_nav.dart';

Future<void> runSite(ServerOptions options) => FlextApp.run(
      options: options,
      seo: shopSeo,
      routes: shopRoutes,
      notFound: const FlextNotFound(
        brand: shopBrand,
        links: shopLinks,
        footer: ShopFooter(),
        actions: [
          MenuLink(label: 'Ir às compras', href: '/produtos'),
          MenuLink(label: 'Início', href: '/'),
        ],
      ),
    );
