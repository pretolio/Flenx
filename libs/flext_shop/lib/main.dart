/// ⭐ Loja de exemplo do Flext. Você edita só este arquivo + config/ + views/.
///
/// Agora com banco (catálogo + pedidos + usuários + configurações), carrinho
/// de compras (ilha) e admin completo (produtos, pedidos, permissões, home).
library;

import 'package:flext/app.dart';

import 'config/shop_api.dart';
import 'config/shop_routes.dart';
import 'config/shop_seo.dart';
import 'data/product_repository.dart';
import 'views/shop_nav.dart';

Future<void> runSite(ServerOptions options) async {
  final db = JsonlDbExecutor(directory: 'lib/content/db');

  // Semeia catálogo, configurações da home e usuários na primeira execução.
  final repo = ProductRepository(db);
  await repo.seedIfEmpty();
  await SiteSettings.ensure(db, {
    'hero_title': 'Os melhores periféricos, num clique',
    'hero_subtitle':
        'Loja de exemplo feita 100% em Dart com o Flext — SSR, SEO e catálogo prontos.',
    'hero_cta': 'Ver produtos',
  });
  await _seedUsers(db);

  final products = await repo.loadAll();
  final settings = await SiteSettings.load(db);

  await FlextApp.run(
    options: options,
    seo: shopSeo,
    db: db,
    apis: apis,
    routes: shopRoutes(products, settings),
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
}

/// Cria dois usuários de exemplo (papéis diferentes) se a tabela estiver vazia.
Future<void> _seedUsers(DbExecutor db) async {
  if (await db.count('users') > 0) return;
  final now = DateTime.now().toIso8601String();
  await db.insert('users', {
    'name': 'Gabriel Potenza',
    'email': 'admin@flextstore.com',
    'role': 'Administrador',
    'active': 1,
    'created_at': now,
  });
  await db.insert('users', {
    'name': 'Maria Editora',
    'email': 'editor@flextstore.com',
    'role': 'Editor',
    'active': 1,
    'created_at': now,
  });
}
