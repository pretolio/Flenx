# Flenx

Framework **Flutter/Dart estilo Next.js** para a web. Você escreve **só Dart, no estilo Flutter** — **sem HTML/CSS** — e o Flenx faz **SSR** (com [jaspr](https://jaspr.site)), embute **widgets Flutter reais** como ilhas, e gera **SEO/GEO/AEO + sitemap + robots + llms.txt** automaticamente.

Recursos (todos **opcionais**, use conforme precisar): kit de UI em Dart, blog (markdown e/ou banco), painel admin, APIs declarativas (Dart **ou** PHP), banco plugável (Supabase/Firebase/REST), auth (JWT), notificações (Twilio/FCM) e pagamento (Asaas/Mercado Pago).

> Três exemplos prontos no repositório: **`flenx_demo`** (institucional + admin), **`flenx_shop`** (loja) e **`flenx_news`** (notícias).

---

## Conceito

- **Você só escreve Dart.** Componentes (`FlenxColumn`, `FlenxText`, `FlenxButton`, `FlenxHero`…) recebem parâmetros Dart; a lib gera o HTML/CSS por baixo.
- **Uma rota = uma definição.** `FlenxRoute(RouteMeta(...), builder)` alimenta render, meta tags, sitemap e llms.txt de uma vez.
- **Boilerplate é gerado.** Os entrypoints do jaspr são criados por `dart run flenx:bootstrap` e ficam no `.gitignore`. Você mantém só o conteúdo.

---

## Como começar (4 passos)

### 1. Instale (projeto jaspr em modo servidor)

```bash
dart pub add flenx jaspr
dart pub add dev:build_runner dev:build_web_compilers dev:jaspr_builder
```

`pubspec.yaml` (SDK `^3.10.0` para dot-shorthands):

```yaml
environment:
  sdk: ^3.10.0
dependencies:
  flenx: ^0.1.0
  jaspr: ^0.23.1
jaspr:
  mode: server
```

### 2. Crie o `lib/main.dart`

```dart
import 'package:flenx/app.dart';

const seo = SeoConfig(
  baseUrl: 'https://meusite.com',
  siteName: 'Meu Site',
  description: 'Descrição para SEO e redes sociais.',
);

final routes = <FlenxRoute>[
  FlenxRoute(
    const RouteMeta(path: '/', title: 'Início', description: 'Bem-vindo!'),
    (ctx) => FlenxPage([
      FlenxHero(title: 'Olá!', subtitle: 'Meu site em Dart, com o Flenx.'),
    ]),
  ),
];

// O entrypoint gerado chama esta função.
Future<void> runSite(ServerOptions options) => FlenxApp.run(
      options: options,
      seo: seo,
      routes: routes,
      notFound: const FlenxNotFound(brand: SiteBrand(label: 'Meu Site')),
    );
```

### 3. Gere os entrypoints (único comando obrigatório)

```bash
dart run flenx:bootstrap
```

### 4. Rode

```bash
dart pub global activate jaspr_cli
jaspr serve            # http://localhost:8080 (hot reload)
```

Pronto — site SSR com SEO/sitemap/robots/llms.txt automáticos. **Blog, admin, banco etc. são opcionais** (abaixo).

### Estrutura do projeto

```
meu_site/
├── lib/
│   ├── main.dart                 # ⭐ seu código (FlenxApp.run)
│   ├── config/                   # (opcional) seo, rotas, apis separados
│   ├── views/                    # suas telas (kit Dart)
│   ├── main.server.dart          # gerado por flenx:bootstrap — gitignored
│   ├── main.client.dart          # gerado — gitignored
│   └── generated/, *.options.dart, *.imports.dart   # gerados — gitignored
└── pubspec.yaml
```

`.gitignore` recomendado: `lib/main.server.dart`, `lib/main.client.dart`, `lib/**/*.options.dart`, `lib/**/*.imports.dart`, `lib/generated/`, `web/main.client.dart`.

---

## Opções (use só o que precisar)

### Rotas + SEO (fonte única)

Cada `FlenxRoute` junta o SEO (`RouteMeta`) e o componente:

```dart
FlenxRoute(
  const RouteMeta(
    path: '/sobre',
    title: 'Sobre',
    description: 'Quem somos.',
    priority: 0.6,
    faqs: [FaqItem(question: 'O que é?', answer: '...')],  // vira JSON-LD FAQPage
  ),
  (ctx) => const AboutPage(),
),
```

Disso saem sozinhos: meta tags, Open Graph/Twitter, JSON-LD, `/sitemap.xml`, `/robots.txt`, `/llms.txt`, `/llms-full.txt`. Rotas dinâmicas: `extraSources: [DynamicRouteSource<T>(...)]`.

### Kit de UI em Dart (sem HTML/CSS)

Primitivas: `FlenxPage`, `FlenxSection`, `FlenxColumn`, `FlenxRow`, `FlenxGrid`, `FlenxText`, `FlenxHeading`, `FlenxButton`, `FlenxCard`, `FlenxImage`.
Blocos: `FlenxHero`, `FlenxTrustBar`, `FlenxSteps`, `FlenxCta`, `FlenxFooter`, `FeaturesSection`, `IframeEmbed`.

```dart
FlenxPage([
  SiteHeader(brand: brand, links: links),
  FlenxHero(title: '...', subtitle: '...', actions: [FlenxButton('Começar', href: '#x')]),
  FlenxGrid([for (final f in itens) FlenxCard(...)]),
  WhatsappButton(url: '...'),
]);
```

> `:hover`/foco (que o navegador só faz com CSS) viram **parâmetro** — ex.: `FlenxButton(hover: true)`. Embutir outro site: `IframeEmbed('https://...', ratio: '16 / 9')`.

### Blog (opcional — markdown e/ou banco)

Só se o site tiver blog. Crie a pasta com um post de boas-vindas:

```bash
dart run flenx:blog_init               # cria lib/content/blog/ + 1 post
dart run flenx:new_post "Meu post"     # novos posts
```

E ative no `FlenxApp.run`:

```dart
FlenxApp.run(
  ...,
  blog: 'lib/content/blog',   // posts em markdown
  blogFromDb: true,           // (opcional) + posts salvos no banco (tabela blog_posts)
  blogLayout: (page) => MeuLayoutDeBlog(child: page),
);
```

Índice, post, categorias, tags, busca (`?q=`) e paginação são automáticos. **Sem blog, não rode `blog_init` — só não passe `blog:`.**

### Painel admin (opcional)

Preencha as opções de `FlenxAdminApp` (como o `AppShell`), num arquivo Flutter `admin_app.dart`:

```dart
class AdminApp extends StatelessWidget {
  Widget build(c) => FlenxAdminApp(
    title: 'Admin',
    user: const AppUser(name: 'Ana', role: 'Administrador'),
    navItems: const [NavItem(label: 'Dashboard', icon: Icons.dashboard, route: '/')],
    pages: {'/': (c) => const FlenxDashboard(stats: [...], activity: [...])},
  );
}
```

`dart run flenx:bootstrap` gera o wiring (`admin_page.dart`). Adicione `jaspr_flutter_embed` e `jaspr: flutter: embedded` no pubspec.

### APIs declarativas (Dart ou PHP)

```dart
const apis = [
  ApiEndpoint(path: '/api/leads', method: HttpMethod.post, fields: [...],
    actions: [InsertInto(leadsModel), SendEmail(to: '...'), Redirect('/?ok')]),
  ApiEndpoint(path: '/api/leads/list', method: HttpMethod.get, actions: [ListPaginated(leadsModel)]),
];
// FlenxApp.run(..., apis: apis, db: ...);
```

Envelope padrão `{success, data, error, meta}` + paginação. `requiresAuth: true` exige `Bearer`. Geram PHP com `dart run tool/build.dart` (flag `buildPhp` no main).

### Banco plugável (onde os dados são salvos)

Escolha por `DB_PROVIDER` no `.env` e adicione as credenciais:

```dart
db: DbRegistry.fromEnv(Platform.environment),   // no FlenxApp.run
```

| `DB_PROVIDER` | Backend | Credenciais |
|---|---|---|
| `supabase` | Supabase (PostgREST) | `SUPABASE_URL`, `SUPABASE_KEY` |
| `firebase` | Firebase Firestore | `FIREBASE_PROJECT_ID`, `FIREBASE_TOKEN` |
| `rest` / `api` | API Flenx (PHP **ou** Dart) | `API_BASE_URL`, `API_TOKEN` |
| `jsonl` / `memory` | arquivo / memória (dev) | `DB_DIR` |

Backend novo: `DbRegistry.register('mongo', (env, c) => MeuExecutor(...))`.

### Auth, Notificações e Pagamento (opcionais)

- **Auth**: `JwtService` (HS256, segredo via `.env`) + `TokenVerifier` (gancho p/ Firebase). Gate por `requiresAuth: true`.
- **Notificações**: `NotificationCenter.notifyAll()` → todos os canais ativos (`TwilioSmsChannel`, `TwilioWhatsappChannel`, `FcmPushChannel`).
- **Pagamento**: `PaymentService.fromEnv(env)` por `PAYMENT_PROVIDER` (`asaas`|`mercadopago`); novos via `PaymentRegistry.register(...)`.

> `.env` é **só lado servidor** — nunca exposto ao cliente.

---

## Build de produção

```bash
jaspr build                 # web/Dart → build/jaspr/
dart run tool/build.dart    # (opcional) também gera a API PHP se buildPhp=true
```

## Exemplos

- **flenx_demo** — institucional + blog + painel admin + APIs.
- **flenx_shop** — loja: catálogo, rota por produto (SEO), comprar via WhatsApp.
- **flenx_news** — portal de notícias em Markdown (manchete, categorias, busca).
