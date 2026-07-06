import 'package:flenx/app.dart';

import '../views/about_page.dart';
import '../views/admin/admin_page.dart';
import '../views/home_page.dart';

/// Rotas estáticas do portal (a home recebe as últimas notícias e a config).
/// As páginas de notícia (/blog*) são resolvidas automaticamente pelo blog.
List<FlenxRoute> newsRoutes(List<BlogPost> posts, SiteSettings settings) => [
  FlenxRoute(
    const RouteMeta(
      path: '/',
      title: 'Flenx News — últimas notícias',
      description:
          'Tecnologia, economia e esportes no portal de exemplo do Flenx.',
      priority: 1.0,
      changeFreq: ChangeFreq.daily,
    ),
    (ctx) => HomePage(posts: posts, settings: settings),
  ),
  FlenxRoute(
    const RouteMeta(
      path: '/sobre',
      title: 'Sobre — Flenx News',
      description: 'O que é o portal de notícias de exemplo do Flenx.',
      priority: 0.5,
    ),
    (ctx) => const AboutPage(),
  ),
  // Painel administrativo — ilha Flutter (área logada, fora do sitemap).
  FlenxRoute.island(
    const RouteMeta(
      path: '/admin',
      title: 'Painel — Flenx News',
      description: 'Área administrativa do portal Flenx News (área logada).',
      noindex: true,
    ),
    (ctx) => const AdminPage(),
  ),
];
