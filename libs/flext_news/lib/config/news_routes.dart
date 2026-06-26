import 'package:flext/app.dart';

import '../views/about_page.dart';
import '../views/admin/admin_page.dart';
import '../views/home_page.dart';

/// Rotas estáticas do portal (a home recebe as últimas notícias e a config).
/// As páginas de notícia (/blog*) são resolvidas automaticamente pelo blog.
List<FlextRoute> newsRoutes(List<BlogPost> posts, SiteSettings settings) => [
      FlextRoute(
        const RouteMeta(
          path: '/',
          title: 'Flext News — últimas notícias',
          description: 'Tecnologia, economia e esportes no portal de exemplo do Flext.',
          priority: 1.0,
          changeFreq: ChangeFreq.daily,
        ),
        (ctx) => HomePage(posts: posts, settings: settings),
      ),
      FlextRoute(
        const RouteMeta(
          path: '/sobre',
          title: 'Sobre — Flext News',
          description: 'O que é o portal de notícias de exemplo do Flext.',
          priority: 0.5,
        ),
        (ctx) => const AboutPage(),
      ),
      // Painel administrativo — ilha Flutter (área logada, fora do sitemap).
      FlextRoute.island(
        const RouteMeta(
          path: '/admin',
          title: 'Painel — Flext News',
          description: 'Área administrativa do portal Flext News (área logada).',
          noindex: true,
        ),
        (ctx) => const AdminPage(),
      ),
    ];
