/// ⭐ Portal de notícias de exemplo do Flext. As notícias são arquivos Markdown
/// em lib/content/blog/ E/OU posts criados pelo admin (banco). Você edita só
/// este arquivo + config/ + views/ + content.
library;

import 'package:flext/app.dart';

import 'config/news_ads.dart';
import 'config/news_api.dart';
import 'config/news_routes.dart';
import 'config/news_seo.dart';
import 'views/news_layout.dart';
import 'views/news_nav.dart';

Future<void> runSite(ServerOptions options) async {
  final db = JsonlDbExecutor(directory: 'lib/content/db');

  // Garante a config da home (semeia textos padrão na primeira vez).
  await SiteSettings.ensure(db, {
    'hero_title': 'Flext News',
    'hero_subtitle': 'Tecnologia, economia e esportes — em tempo real.',
  });

  // Semeia usuários de exemplo se a tabela estiver vazia.
  if (await db.count('users') == 0) {
    final now = DateTime.now().toIso8601String();
    await db.insert('users', {
      'name': 'Redação Flext',
      'email': 'admin@flextnews.com',
      'role': 'Administrador',
      'active': '1',
      'created_at': now,
    });
    await db.insert('users', {
      'name': 'Editor Flext',
      'email': 'editor@flextnews.com',
      'role': 'Editor',
      'active': '1',
      'created_at': now,
    });
  }

  // Configurações e posts (markdown + banco) para a home.
  final settings = await SiteSettings.load(db);
  final posts = await Blog.fromSources([
    MarkdownBlogSource('lib/content/blog'),
    DatabaseBlogSource(db),
  ]).then((b) => b.posts);

  await FlextApp.run(
    options: options,
    seo: newsSeo,
    ads: newsAds, // injeta o loader do AdSense
    // Notícias combinadas: arquivos `.md` (blog) + posts do banco (blogFromDb).
    blog: 'lib/content/blog',
    blogFromDb: true,
    db: db,
    apis: apis,
    blogLayout: (page) => NewsLayout(child: page),
    routes: newsRoutes(posts, settings), // home recebe notícias + config
    notFound: const FlextNotFound(
      brand: newsBrand,
      links: newsLinks,
      footer: NewsFooter(),
      actions: [MenuLink(label: 'Ver notícias', href: '/blog')],
    ),
  );
}
