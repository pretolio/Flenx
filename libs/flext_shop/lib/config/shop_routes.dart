import 'package:flext/app.dart';

import '../data/products.dart';
import '../views/catalog_page.dart';
import '../views/home_page.dart';
import '../views/product_page.dart';

/// Rotas da loja — cada produto vira uma rota `/produto/<slug>` (com SEO e
/// entrada no sitemap geradas a partir do mesmo RouteMeta).
final shopRoutes = <FlextRoute>[
  FlextRoute(
    const RouteMeta(
      path: '/',
      title: 'Flext Store — periféricos que rendem',
      description: 'Loja de exemplo do Flext: fones, teclados, monitores e mais.',
      priority: 1.0,
      changeFreq: ChangeFreq.daily,
    ),
    (ctx) => const HomePage(),
  ),
  FlextRoute(
    const RouteMeta(
      path: '/produtos',
      title: 'Produtos — Flext Store',
      description: 'Catálogo completo da Flext Store.',
      priority: 0.9,
      changeFreq: ChangeFreq.daily,
    ),
    (ctx) => const CatalogPage(),
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
