import 'package:flext/app.dart';

import '../data/product.dart';
import '../views/admin/admin_page.dart';
import '../views/cart/cart_page.dart';
import '../views/catalog_page.dart';
import '../views/home_page.dart';
import '../views/product_page.dart';

/// Rotas da loja. Recebe os produtos (do banco) e as configurações da home.
/// Cada produto vira `/produto/<slug>`. `/carrinho` e `/admin` são ilhas
/// Flutter (interativas).
List<FlextRoute> shopRoutes(List<Product> products, SiteSettings settings) => [
      FlextRoute(
        const RouteMeta(
          path: '/',
          title: 'Flext Store — periféricos que rendem',
          description:
              'Loja de exemplo do Flext: fones, teclados, monitores e mais.',
          priority: 1.0,
          changeFreq: ChangeFreq.daily,
        ),
        (ctx) => HomePage(products: products, settings: settings),
      ),
      FlextRoute(
        const RouteMeta(
          path: '/produtos',
          title: 'Produtos — Flext Store',
          description: 'Catálogo completo da Flext Store.',
          priority: 0.9,
          changeFreq: ChangeFreq.daily,
        ),
        (ctx) => CatalogPage(products: products),
      ),
      FlextRoute.island(
        const RouteMeta(
          path: '/carrinho',
          title: 'Carrinho — Flext Store',
          description: 'Seu carrinho de compras.',
          noindex: true,
        ),
        (ctx) => const CartPage(),
      ),
      FlextRoute.island(
        const RouteMeta(
          path: '/admin',
          title: 'Painel — Flext Store',
          description: 'Área administrativa da loja.',
          noindex: true,
        ),
        (ctx) => const AdminPage(),
      ),
      for (final p in products)
        FlextRoute(
          RouteMeta(
            path: '/produto/${p.slug}',
            title: '${p.name} — Flext Store',
            description: p.summary,
            priority: 0.7,
            changeFreq: ChangeFreq.weekly,
          ),
          (ctx) => ProductPage(p),
        ),
    ];
