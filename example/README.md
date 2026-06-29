# Exemplo — Flenx

Site SSR mínimo em Dart: rota + SEO + UI, com `FlenxApp.run`. Veja `main.dart`
nesta pasta.

```dart
import 'package:flenx/app.dart';

const seo = SeoConfig(
  baseUrl: 'https://meusite.com',
  siteName: 'Meu Site',
  description: 'Site em Dart com Flenx — SSR e SEO automáticos.',
);

final routes = <FlenxRoute>[
  FlenxRoute(
    const RouteMeta(path: '/', title: 'Início', description: 'Bem-vindo!'),
    (ctx) => FlenxPage([
      const FlenxHero(title: 'Olá!', subtitle: 'Meu site em Dart, com o Flenx.'),
      const FlenxSection(child: FlenxText('Conteúdo em componentes Dart.')),
    ]),
  ),
];

Future<void> runSite(ServerOptions options) => FlenxApp.run(
      options: options,
      seo: seo,
      routes: routes,
      notFound: const FlenxNotFound(brand: SiteBrand(label: 'Meu Site')),
    );
```

Rode:

```bash
dart run flenx:bootstrap          # gera os entrypoints do jaspr
dart pub global activate jaspr_cli
jaspr serve                       # http://localhost:8080
```

## Apps completos

Três sites SSR completos (institucional + admin, loja com carrinho, portal de
notícias) estão no repositório:
<https://github.com/pretolio/Flenx/tree/main/example>
