import 'package:flext/app.dart';

import '../views/admin/admin_page.dart';
import '../views/site/about_page.dart';
import '../views/site/flext_site.dart';

/// Rotas do site — **fonte única**: cada [FlextRoute] junta o SEO ([RouteMeta])
/// e o componente que renderiza. A mesma definição alimenta o render, as meta
/// tags, o sitemap e o llms.txt. (As rotas do blog são automáticas.)
final siteRoutes = <FlextRoute>[
  FlextRoute(
    const RouteMeta(
      path: '/',
      title: 'Flext — Flutter na web como nunca antes',
      description:
          'Framework Flutter estilo Next.js: SSR, widgets reais e SEO/GEO/AEO automáticos.',
      kind: PageKind.website,
      priority: 1.0,
      changeFreq: ChangeFreq.daily,
      section: 'Principal',
      image: '/images/logo.svg',
      faqs: [
        FaqItem(
          question: 'O que é o Flext?',
          answer:
              'Um framework Flutter/Dart estilo Next.js que faz SSR com widgets '
              'Flutter reais e gera SEO, sitemap, robots e llms.txt automaticamente.',
        ),
        FaqItem(
          question: 'Como rotas dinâmicas entram no sitemap?',
          answer:
              'Basta registrar uma DynamicRouteSource com um provider de dados; '
              'o framework expande cada item no sitemap e no llms.txt.',
        ),
      ],
    ),
    (ctx) => FlextSite(submitted: ctx['lead'] == 'ok'),
  ),
  FlextRoute(
    const RouteMeta(
      path: '/site',
      title: 'Flext — site institucional',
      description:
          'Página institucional do Flext com header de top menu, dropdowns e login.',
      kind: PageKind.website,
      priority: 0.9,
      changeFreq: ChangeFreq.monthly,
      section: 'Principal',
    ),
    (ctx) => FlextSite(submitted: ctx['lead'] == 'ok'),
  ),
  FlextRoute(
    const RouteMeta(
      path: '/about',
      title: 'Sobre o Flext',
      description: 'A história e a arquitetura do framework Flext.',
      kind: PageKind.website,
      priority: 0.6,
      changeFreq: ChangeFreq.monthly,
      section: 'Principal',
      breadcrumbs: [
        Breadcrumb(name: 'Início', path: '/'),
        Breadcrumb(name: 'Sobre'),
      ],
    ),
    (ctx) => const AboutPage(),
  ),
  FlextRoute.island(
    const RouteMeta(
      path: '/admin',
      title: 'Painel administrativo',
      description: 'Área administrativa do Flext (shell de navegação).',
      noindex: true, // área logada: fora do sitemap e não indexada
    ),
    (ctx) => const AdminPage(),
  ),
];
