import 'package:flenx/app.dart';

import '../views/admin/admin_page.dart';
import '../views/site/about_page.dart';
import '../views/site/flenx_site.dart';

/// Rotas do site — **fonte única**: cada [FlenxRoute] junta o SEO ([RouteMeta])
/// e o componente que renderiza. A mesma definição alimenta o render, as meta
/// tags, o sitemap e o llms.txt. (As rotas do blog são automáticas.)
final siteRoutes = <FlenxRoute>[
  FlenxRoute(
    const RouteMeta(
      path: '/',
      title: 'Flenx — Flutter na web como nunca antes',
      description: 'Framework Flutter estilo Next.js: SSR, widgets reais e SEO/GEO/AEO automáticos.',
      kind: PageKind.website,
      priority: 1.0,
      changeFreq: ChangeFreq.daily,
      section: 'Principal',
      image: '/images/logo.svg',
      faqs: [
        FaqItem(
          question: 'O que é o Flenx?',
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
    (ctx) => FlenxSite(submitted: ctx['lead'] == 'ok'),
  ),
  FlenxRoute(
    const RouteMeta(
      path: '/site',
      title: 'Flenx — site institucional',
      description: 'Página institucional do Flenx com header de top menu, dropdowns e login.',
      kind: PageKind.website,
      priority: 0.9,
      changeFreq: ChangeFreq.monthly,
      section: 'Principal',
    ),
    (ctx) => FlenxSite(submitted: ctx['lead'] == 'ok'),
  ),
  FlenxRoute(
    const RouteMeta(
      path: '/about',
      title: 'Sobre o Flenx',
      description: 'A história e a arquitetura do framework Flenx.',
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
  FlenxRoute.island(
    const RouteMeta(
      path: '/admin',
      title: 'Painel administrativo',
      description: 'Área administrativa do Flenx (shell de navegação).',
      noindex: true, // área logada: fora do sitemap e não indexada
    ),
    (ctx) => const AdminPage(),
  ),
];
