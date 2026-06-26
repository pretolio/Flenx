/// ⭐ O ÚNICO arquivo que você edita. Aqui você configura o site inteiro.
///
/// Os entrypoints que o jaspr exige (`main.server.dart` / `main.client.dart`)
/// são gerados por `dart run flext:bootstrap` e ficam no `.gitignore`.
library;

import 'package:flext/app.dart';

import 'config/site_api.dart';
import 'config/site_routes.dart';
import 'config/site_seo.dart';
import 'views/blog/blog_layout.dart';
import 'views/site/not_found_page.dart';

/// Gerar a API em **PHP** no build? (para hospedagem sem Dart — PHP/MySQL).
/// `true`  → `dart run tool/build.dart` gera `build/php/` (PDO + migrations.sql).
/// `false` → só o app web/Dart, sem PHP.
const buildPhp = true;

/// Sobe o site Flext. Chamado pelo entrypoint gerado do servidor.
Future<void> runSite(ServerOptions options) => FlextApp.run(
      options: options,
      seo: seoConfig,
      routes: siteRoutes,
      // Duas formas de criar posts, combinadas: arquivos `.md` (abaixo)
      // E posts salvos no banco (`blogFromDb`). Ambos aparecem no mesmo blog.
      blog: 'lib/content/blog',
      blogFromDb: true,
      blogLayout: (page) => BlogLayout(child: page),
      apis: apis,
      db: const JsonlDbExecutor(directory: 'lib/content/db'),
      notFound: const NotFoundPage(),
    );
