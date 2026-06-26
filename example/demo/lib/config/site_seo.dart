import 'package:flenx/app.dart';

/// Configuração SEO/GEO/AEO **global** deste site (nome, URL, social, etc.).
/// As rotas e o SEO de cada página ficam em `site_routes.dart`.
const seoConfig = SeoConfig(
  baseUrl: 'https://flenx.exemplo.com',
  siteName: 'Flenx Demo',
  description:
      'Demo do Flenx: framework Flutter estilo Next.js com SSR, widgets reais '
      'e otimização automática para buscadores e motores de IA.',
  defaultLocale: 'pt_BR',
  twitterHandle: '@flenx',
  logoUrl: '/images/logo.svg',
  organizationName: 'Flenx',
  themeColor: '#01589B',
  sameAs: ['https://github.com/flenx'],
  searchUrlTemplate: '/busca?q={search_term_string}',
  globalDisallow: ['/api/private/'],
);
