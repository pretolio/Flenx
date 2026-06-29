import 'package:flenx/app.dart';

/// Exemplo mínimo de um site Flenx — SSR + SEO/sitemap/llms.txt automáticos.
///
/// Apps completos (institucional, loja e portal de notícias) em:
/// https://github.com/pretolio/Flenx/tree/main/example
const seo = SeoConfig(
  baseUrl: 'https://meusite.com',
  siteName: 'Meu Site',
  description: 'Site em Dart com Flenx — SSR e SEO automáticos.',
);

final routes = <FlenxRoute>[
  FlenxRoute(
    const RouteMeta(path: '/', title: 'Início', description: 'Bem-vindo!'),
    (ctx) => FlenxPage([
      const FlenxHero(
        title: 'Olá!',
        subtitle: 'Meu site em Dart, com o Flenx.',
        actions: [FlenxButton('Começar', href: '#sobre')],
      ),
      const FlenxSection(
        id: 'sobre',
        child: FlenxText('Conteúdo da página, em componentes Dart.'),
      ),
    ]),
  ),
];

/// O entrypoint gerado por `dart run flenx:bootstrap` chama esta função.
Future<void> runSite(ServerOptions options) => FlenxApp.run(
  options: options,
  seo: seo,
  routes: routes,
  notFound: const FlenxNotFound(brand: SiteBrand(label: 'Meu Site')),
);
