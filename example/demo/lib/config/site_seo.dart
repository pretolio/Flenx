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
  sameAs: ['https://github.com/pretolio/Flenx', 'https://pub.dev/packages/flenx'],
  searchUrlTemplate: '/busca?q={search_term_string}',
  globalDisallow: ['/api/private/'],
  telephone: '+55 11 99999-9999',
  email: 'contato@flenx.dev',
  about: 'Flenx é um framework Flutter/Dart para a web (SSR, SEO automático, '
      'blog, admin e APIs) que roda em qualquer hospedagem — PHP/MySQL ou Dart.',
  address: SeoAddress(
    streetAddress: 'Av. Paulista, 1000',
    addressLocality: 'São Paulo',
    addressRegion: 'SP',
    postalCode: '01310-100',
    addressCountry: 'BR',
    latitude: -23.5615,
    longitude: -46.6562,
  ),
);
