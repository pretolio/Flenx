/// ⭐ Portal de notícias de exemplo do Flext. As notícias são arquivos Markdown
/// em lib/content/blog/. Você edita só este arquivo + config/ + views/ + content.
library;

import 'package:flext/app.dart';

import 'config/news_routes.dart';
import 'config/news_seo.dart';
import 'views/news_layout.dart';
import 'views/news_nav.dart';

Future<void> runSite(ServerOptions options) async {
  final news = await Blog.load('lib/content/blog');
  await FlextApp.run(
    options: options,
    seo: newsSeo,
    blogInstance: news,                          // reusa o blog já carregado
    blogLayout: (page) => NewsLayout(child: page),
    routes: newsRoutes(news.posts),              // home recebe as notícias
    notFound: const FlextNotFound(
      brand: newsBrand,
      links: newsLinks,
      footer: NewsFooter(),
      actions: [MenuLink(label: 'Ver notícias', href: '/blog')],
    ),
  );
}
