import 'package:flenx/app.dart';

import '../data/product.dart';
import '../views/admin/admin_page.dart';
import '../views/cart/cart_page.dart';
import '../views/catalog_page.dart';
import '../views/home_page.dart';
import '../views/product_page.dart';

/// Rotas da loja. Recebe os produtos (do banco) e as configurações da home.
/// Cada produto vira `/produto/<slug>`. `/carrinho` e `/admin` são ilhas
/// Flutter (interativas).
List<FlenxRoute> shopRoutes(List<Product> products, SiteSettings settings) => [
      FlenxRoute(
        const RouteMeta(
          path: '/',
          title: 'Flenx Store — periféricos que rendem',
          description:
              'Loja de exemplo do Flenx: fones, teclados, monitores e mais.',
          priority: 1.0,
          changeFreq: ChangeFreq.daily,
        ),
        (ctx) => HomePage(products: products, settings: settings),
      ),
      FlenxRoute(
        const RouteMeta(
          path: '/produtos',
          title: 'Produtos — Flenx Store',
          description: 'Catálogo completo da Flenx Store.',
          priority: 0.9,
          changeFreq: ChangeFreq.daily,
        ),
        (ctx) => CatalogPage(products: products),
      ),
      FlenxRoute.island(
        const RouteMeta(
          path: '/carrinho',
          title: 'Carrinho — Flenx Store',
          description: 'Seu carrinho de compras.',
          noindex: true,
        ),
        (ctx) => const CartPage(),
      ),
      FlenxRoute.island(
        const RouteMeta(
          path: '/admin',
          title: 'Painel — Flenx Store',
          description: 'Área administrativa da loja.',
          noindex: true,
        ),
        (ctx) => const AdminPage(),
      ),
      for (final p in products)
        FlenxRoute(
          RouteMeta(
            path: '/produto/${p.slug}',
            title: '${p.name} — Flenx Store',
            description: p.summary,
            priority: 0.7,
            changeFreq: ChangeFreq.weekly,
          ),
          (ctx) => ProductPage(p),
        ),
    ];
