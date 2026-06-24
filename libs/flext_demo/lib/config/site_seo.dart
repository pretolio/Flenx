import 'package:flext/app.dart';

/// Configuração SEO/GEO/AEO **global** deste site (nome, URL, social, etc.).
/// As rotas e o SEO de cada página ficam em `site_routes.dart`.
const seoConfig = SeoConfig(
  baseUrl: 'https://flext.exemplo.com',
  siteName: 'Flext Demo',
  description:
      'Demo do Flext: framework Flutter estilo Next.js com SSR, widgets reais '
      'e otimização automática para buscadores e motores de IA.',
  defaultLocale: 'pt_BR',
  twitterHandle: '@flext',
  logoUrl: '/images/logo.svg',
  organizationName: 'Flext',
  themeColor: '#01589B',
  sameAs: ['https://github.com/flext'],
  searchUrlTemplate: '/busca?q={search_term_string}',
  globalDisallow: ['/api/private/'],
);
