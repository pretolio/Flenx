<p align="center">
  <img src="https://raw.githubusercontent.com/pretolio/Flenx/main/doc/flenx-logo.png" alt="Flenx" width="540">
</p>

<p align="center">
  <strong>Flutter/Dart na web, no estilo Next.js.</strong><br>
  Você escreve <strong>só Dart</strong> — sem HTML/CSS. O Flenx faz <strong>SSR</strong>, embute
  <strong>widgets Flutter</strong> como ilhas e gera <strong>SEO/sitemap/llms.txt</strong> automaticamente.
</p>

<p align="center">
  <a href="https://pub.dev/packages/flenx"><img src="https://img.shields.io/pub/v/flenx.svg?label=pub.dev&color=0166b3" alt="pub.dev"></a>
  <img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="MIT">
  <img src="https://img.shields.io/badge/SDK-Dart%20%5E3.10-0a86e0.svg" alt="Dart">
</p>

<p align="center">
  <a href="https://pub.dev/packages/flenx">📦 pub.dev</a> &nbsp;·&nbsp;
  <a href="https://pretolio.github.io/Flenx/">🌐 Showcase</a> &nbsp;·&nbsp;
  <a href="https://github.com/pretolio/Flenx/tree/main/example">🧪 Exemplos</a> &nbsp;·&nbsp;
  <a href="https://github.com/pretolio/Flenx">★ GitHub</a>
</p>

---

O Flenx é um framework para construir **sites e apps web em Dart** com renderização no servidor (via [jaspr](https://jaspr.site)). Tudo é **opcional** — comece com um site SSR + SEO em minutos e ative blog, admin, APIs e banco conforme o projeto cresce.

## ✨ Recursos

- **UI em Dart** — `FlenxColumn`, `FlenxHero`, `FlenxCard`… geram o HTML/CSS por baixo.
- **SEO automático** — meta tags, Open Graph, JSON-LD, `sitemap.xml`, `robots.txt` e `llms.txt` a partir de uma única definição de rota.
- **Blog** — posts em Markdown **e/ou** banco, com editor estilo G1, categorias, tags, busca e paginação.
- **Painel admin** — ilha Flutter pronta: CRUD genérico, permissões por papel e edição da home.
- **APIs + banco** — endpoints declarativos (Dart **ou** PHP) e banco plugável: Supabase, Firebase, REST ou JSONL.
- **Ilhas Flutter** — widgets Flutter reais hidratados no cliente, dentro das páginas SSR.

## 🚀 Começar

**1. Instale** (projeto jaspr em modo servidor):

```bash
dart pub add flenx jaspr
dart pub add dev:build_runner dev:build_web_compilers dev:jaspr_builder
```

```yaml
# pubspec.yaml
environment:
  sdk: ^3.10.0
dependencies:
  flenx: ^0.1.0
  jaspr: ^0.23.1
jaspr:
  mode: server
```

**2. Crie o `lib/main.dart`:**

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

**3. Gere os entrypoints** (único comando obrigatório) **e rode:**

```bash
dart run flenx:bootstrap
dart pub global activate jaspr_cli
jaspr serve            # http://localhost:8080 (hot reload)
```

Pronto — site SSR com SEO/sitemap/robots/llms.txt automáticos.

## 🏗️ Build e deploy

O Flenx suporta diferentes alvos de build. Escolha conforme onde vai hospedar:

| Alvo | Comando | `jaspr.mode` | Onde hospedar |
|---|---|---|---|
| **Dev (hot reload)** | `jaspr serve` | `server` | local (`localhost:8080`) |
| **Servidor SSR** (recomendado) | `jaspr build` | `server` | qualquer host Dart: Render, Fly.io, Cloud Run, VPS, Docker |
| **Site estático** | `jaspr build` | `static` | GitHub Pages, Netlify, Vercel, S3 |
| **API em PHP** (opcional) | `dart run tool/build.dart` | — | hospedagem PHP/MySQL |

**Servidor SSR** (mantém admin, APIs, banco, formulários):

```bash
jaspr build                          # gera build/jaspr/ com um executável self-contained
./build/jaspr/app                    # roda o servidor (porta via env PORT)
# alvos: jaspr build --target exe|aot-snapshot|kernel  --target-os linux|macos|windows
```

**Site estático** (somente conteúdo pré-renderizado):

```bash
# defina  jaspr: mode: static  no pubspec, então:
jaspr build                          # gera build/jaspr/ com HTML + assets estáticos
```

> ⚠️ **Estático tem limites:** recursos que dependem de servidor — APIs, banco, painel admin, carrinho, formulários — **não funcionam** em modo `static`. Para apps com admin/loja, use `mode: server` e um host com Dart.

**API em PHP** (para hospedagem sem Dart): com `buildPhp = true` no `main.dart`, `dart run tool/build.dart` gera `build/php/` (PDO + `migrations.sql`).

## 🧩 Opções (use só o que precisar)

<details>
<summary><strong>Rotas + SEO (fonte única)</strong></summary>

Cada `FlenxRoute` junta o SEO (`RouteMeta`) e o componente. Disso saem sozinhos: meta tags, Open Graph/Twitter, JSON-LD, `/sitemap.xml`, `/robots.txt`, `/llms.txt`. Rotas dinâmicas: `extraSources: [DynamicRouteSource<T>(...)]`.

```dart
FlenxRoute(
  const RouteMeta(
    path: '/sobre', title: 'Sobre', description: 'Quem somos.',
    faqs: [FaqItem(question: 'O que é?', answer: '...')], // vira JSON-LD FAQPage
  ),
  (ctx) => const AboutPage(),
),
```
</details>

<details>
<summary><strong>Kit de UI em Dart (sem HTML/CSS)</strong></summary>

Primitivas: `FlenxPage`, `FlenxSection`, `FlenxColumn`, `FlenxRow`, `FlenxGrid`, `FlenxText`, `FlenxHeading`, `FlenxButton`, `FlenxCard`, `FlenxImage`.
Blocos: `FlenxHero`, `FlenxTrustBar`, `FlenxSteps`, `FlenxCta`, `FlenxFooter`, `FeaturesSection`, `IframeEmbed`.

```dart
FlenxPage([
  SiteHeader(brand: brand, links: links),
  FlenxHero(title: '...', subtitle: '...', actions: [FlenxButton('Começar', href: '#x')]),
  FlenxGrid([for (final f in itens) FlenxCard(...)]),
]);
```

`:hover`/foco viram **parâmetro** (ex.: `FlenxButton(hover: true)`).
</details>

<details>
<summary><strong>Blog (Markdown e/ou banco)</strong></summary>

```bash
dart run flenx:blog_init               # cria lib/content/blog/ + 1 post
dart run flenx:new_post "Meu post"     # novos posts
```

```dart
FlenxApp.run(
  ...,
  blog: 'lib/content/blog',   // posts em Markdown
  blogFromDb: true,           // (opcional) + posts no banco (tabela blog_posts)
);
```

Índice, post, categorias, tags, busca (`?q=`) e paginação são automáticos.
</details>

<details>
<summary><strong>Painel admin</strong></summary>

Preencha as opções de `FlenxAdminApp` num arquivo Flutter `admin_app.dart`; `dart run flenx:bootstrap` gera o wiring. Adicione `jaspr_flutter_embed` e `jaspr: flutter: embedded` no pubspec.

```dart
FlenxAdminApp(
  title: 'Admin',
  user: const AppUser(name: 'Ana', role: 'Administrador'),
  navItems: const [NavItem(label: 'Dashboard', icon: Icons.dashboard, route: '/')],
  pages: {'/': (c) => const FlenxDashboard(stats: [...], activity: [...])},
);
```
</details>

<details>
<summary><strong>APIs declarativas + banco plugável</strong></summary>

```dart
const apis = [
  ApiEndpoint(path: '/api/leads', method: HttpMethod.post, fields: [...],
    actions: [InsertInto(leadsModel), SendEmail(to: '...'), Redirect('/?ok')]),
];
// FlenxApp.run(..., apis: apis, db: DbRegistry.fromEnv(Platform.environment));
```

Banco por `DB_PROVIDER` no `.env`:

| `DB_PROVIDER` | Backend | Credenciais |
|---|---|---|
| `supabase` | Supabase (PostgREST) | `SUPABASE_URL`, `SUPABASE_KEY` |
| `firebase` | Firestore | `FIREBASE_PROJECT_ID`, `FIREBASE_TOKEN` |
| `rest` / `api` | API Flenx (PHP/Dart) | `API_BASE_URL`, `API_TOKEN` |
| `jsonl` / `memory` | arquivo / memória (dev) | `DB_DIR` |
</details>

<details>
<summary><strong>Auth, notificações e pagamento</strong></summary>

- **Auth:** `JwtService` (HS256) + `TokenVerifier`. Proteja endpoints com `requiresAuth: true`.
- **Notificações:** `NotificationCenter.notifyAll()` → `TwilioSmsChannel`, `TwilioWhatsappChannel`, `FcmPushChannel`.
- **Pagamento:** `PaymentService.fromEnv(env)` (`asaas` | `mercadopago`).

> `.env` é **só lado servidor** — nunca exposto ao cliente.
</details>

## 🧪 Exemplos

Três sites SSR completos, feitos 100% em Dart, na pasta [`example/`](https://github.com/pretolio/Flenx/tree/main/example):

| Exemplo | O que mostra | Código |
|---|---|---|
| **Demo institucional** | landing + blog (Markdown e banco) + admin + APIs | [example/demo](https://github.com/pretolio/Flenx/tree/main/example/demo) |
| **Loja (e-commerce)** | catálogo, carrinho (ilha Flutter), pedidos, permissões | [example/shop](https://github.com/pretolio/Flenx/tree/main/example/shop) |
| **Portal de notícias** | manchete, categorias, autor/data, editor G1, edição da home | [example/news](https://github.com/pretolio/Flenx/tree/main/example/news) |

Para rodar um exemplo: `cd example/demo && dart run flenx:bootstrap && jaspr serve`.

## 📄 Licença

MIT © Potenza RH. Veja [LICENSE](LICENSE).
