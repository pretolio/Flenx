# Flext

Framework **Flutter/Dart estilo Next.js** para a web. Você escreve **só Dart, no estilo Flutter** — **sem HTML/CSS** — e o Flext faz **SSR** (com [jaspr](https://jaspr.site)), embute **widgets Flutter reais** como ilhas, e gera **SEO/GEO/AEO + sitemap + robots + llms.txt** automaticamente.

Inclui: **kit de UI em Dart** (estilo Flutter), **blog** (markdown e/ou banco), **painel admin** pronto, **APIs declarativas** (rodam em Dart **ou** geram PHP), **banco plugável** (Supabase, Firebase, API REST), **auth (JWT)**, **notificações** (Twilio/FCM) e **pagamento** (Asaas/Mercado Pago).

> Três exemplos prontos: **`libs/flext_demo`** (institucional + admin), **`libs/flext_shop`** (loja) e **`libs/flext_news`** (notícias).

---

## Conceito

- **Você só escreve Dart.** Os componentes (`FlextColumn`, `FlextText`, `FlextButton`, `FlextHero`...) recebem parâmetros Dart (cor, espaçamento, texto); a lib gera o HTML/CSS por baixo. Quem sabe Flutter usa.
- **Uma rota = uma definição.** `FlextRoute(RouteMeta(...), builder)` alimenta render, meta tags, sitemap e llms.txt de uma vez.
- **Boilerplate é gerado.** Os entrypoints do jaspr e o wiring do admin são criados por `dart run flext:bootstrap` e ficam no `.gitignore`. Você mantém só o conteúdo.

---

## Começando

### 1. Instale (projeto jaspr em modo servidor)

```bash
dart pub add flext jaspr jaspr_flutter_embed
dart pub add dev:build_runner dev:build_web_compilers dev:jaspr_builder
```

Seu `pubspec.yaml` deve ficar assim (SDK `^3.10.0` para dot-shorthands; o
`jaspr_flutter_embed` só é preciso se você usar uma ilha Flutter, como o admin):

```yaml
environment:
  sdk: ^3.10.0

dependencies:
  flext: ^0.1.0
  jaspr: ^0.23.1
  jaspr_flutter_embed: ^0.4.11

jaspr:
  mode: server
  flutter: embedded   # só se usar ilha Flutter
```

### 2. Conteúdo inicial

```bash
dart run flext:init                 # cria content/blog com um post de boas-vindas
dart run flext:new_post "Título"    # cria um novo post
dart run flext:bootstrap            # gera os entrypoints (main.server/client, admin_page)
```

### 3. Seu `lib/main.dart` (o único entrypoint que você escreve)

```dart
import 'package:flext/app.dart';
import 'config/site_routes.dart';
import 'config/site_seo.dart';
import 'config/site_api.dart';
import 'views/blog/blog_layout.dart';
import 'views/site/not_found_page.dart';

Future<void> runSite(ServerOptions options) => FlextApp.run(
      options: options,
      seo: seoConfig,
      routes: siteRoutes,                         // suas rotas (com SEO)
      blog: 'lib/content/blog',                   // resolve /blog* sozinho
      blogLayout: (page) => BlogLayout(child: page),
      apis: apis,                                 // APIs declarativas (opcional)
      db: const JsonlDbExecutor(directory: 'lib/content/db'),
      notFound: const NotFoundPage(),
    );
```

`flext:bootstrap` gera `main.server.dart`/`main.client.dart` chamando esse `runSite`. **Você só edita `main.dart` e o conteúdo.**

---

## Estrutura de um projeto

```
meu_site/
├── lib/
│   ├── main.dart                 # ⭐ você escreve (FlextApp.run)
│   ├── config/                   # seo, rotas, apis
│   ├── views/                    # suas telas (site, blog, admin)
│   ├── content/blog/*.md         # posts
│   ├── main.server.dart          # gerado (flext:bootstrap) — gitignored
│   ├── main.client.dart          # gerado — gitignored
│   └── generated/, *.options.dart, *.imports.dart   # gerados — gitignored
└── pubspec.yaml
```

`.gitignore` recomendado:
```
lib/main.server.dart
lib/main.client.dart
lib/views/admin/admin_page.dart
lib/**/*.options.dart
lib/**/*.imports.dart
lib/generated/
web/main.client.dart
```

---

## Rotas + SEO (fonte única)

Cada `FlextRoute` junta o **SEO** (`RouteMeta`) e o **componente**:

```dart
// config/site_routes.dart
final siteRoutes = <FlextRoute>[
  FlextRoute(
    const RouteMeta(
      path: '/',
      title: 'Início',
      description: 'Descrição para SEO e redes sociais.',
      priority: 1.0,
      faqs: [FaqItem(question: 'O que é?', answer: '...')],  // vira JSON-LD FAQPage
    ),
    (ctx) => HomePage(submitted: ctx['lead'] == 'ok'),
  ),
  FlextRoute.island(                                          // ilha Flutter (admin)
    const RouteMeta(path: '/admin', title: 'Painel', noindex: true),
    (ctx) => const AdminPage(),
  ),
];
```

Disso o Flext gera sozinho: meta tags, Open Graph/Twitter, JSON-LD, `/sitemap.xml`, `/robots.txt`, `/llms.txt`, `/llms-full.txt`. Rotas dinâmicas entram via `extraSources: [DynamicRouteSource<T>(...)]`.

---

## Kit de UI em Dart (sem HTML/CSS)

**Primitivas** (estilo Flutter): `FlextPage`, `FlextSection`, `FlextColumn`, `FlextRow`, `FlextGrid`, `FlextText`, `FlextHeading`, `FlextButton`, `FlextCard`, `FlextImage`, `FlextFullscreen`.

**Blocos prontos**: `FlextHero`, `FlextTrustBar`, `FlextSteps`, `FlextCta`, `FlextFooter`, `FlextCodeCard`, `FeaturesSection`, `IframeEmbed`, `FlextBlogLayout`, `FlextNotFound`.

```dart
FlextPage([
  SiteHeader(brand: brand, links: links),
  FlextHero(
    eyebrow: 'Framework em Dart',
    title: 'Flutter na web como nunca antes',
    subtitle: 'SSR, widgets reais e SEO automático.',
    actions: [
      FlextButton('Começar', href: '#contato'),            // hover predefinido
      FlextButton('GitHub', href: '...', variant: FlextButtonVariant.ghost, newTab: true),
    ],
    aside: const FlextCodeCard('...'),
  ),
  FlextTrustBar(label: 'Construído sobre', items: ['jaspr', 'Flutter', 'Dart']),
  FlextSteps(title: 'Como funciona', steps: [FlextStep('Escreva', '...')]),
  FlextCta(title: 'Pronto?', action: FlextButton('Quero', href: '#contato')),
  WhatsappButton(url: site.whatsappUrl),
]);
```

> Detalhes que o navegador só faz com CSS (`:hover`, foco) viram **parâmetro do widget** — ex.: `FlextButton(hover: true)` injeta o `:hover` por baixo. Dropdown e menu mobile do `SiteHeader` usam CSS interno (self-contained) — sua API segue 100% Dart.

**Embutir um site/URL**: `IframeEmbed('https://...', ratio: '16 / 9')`.

---

## Blog em markdown

Arquivos em `lib/content/blog/` — o **nome do arquivo é o slug**:

```markdown
---
title: Meu post
description: Resumo curto (até ~155 caracteres).
date: 2026-06-25
author: Seu Nome
category: Tutoriais/Flutter
tags: [flutter, web]
draft: false
---

Conteúdo em **Markdown**.
```

Basta passar `blog: 'lib/content/blog'` em `FlextApp.run`. Índice, post, categorias, tags, busca (`?q=`) e paginação são automáticos.

---

## Painel admin (preencha as opções)

O admin é um widget Flutter pronto — **`FlextAdminApp`** — embutido como ilha. Você só preenche as opções (como o `AppShell`), em `lib/views/admin/admin_app.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flext/shell.dart';

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});
  @override
  Widget build(BuildContext context) => FlextAdminApp(
        title: 'Admin',
        user: const AppUser(name: 'Ana', role: 'Administrador'),
        navItems: const [NavItem(label: 'Dashboard', icon: Icons.dashboard, route: '/')],
        pages: {
          '/': (c) => const FlextDashboard(stats: [...], activity: [...], greeting: 'Olá 👋'),
        },
      );
}
```

`flext:bootstrap` gera o `admin_page.dart` (o wiring `@client` + ilha) por você — tema claro/escuro, sidebar responsiva e resize já funcionam. Para **desativar** o admin, remova a `FlextRoute.island('/admin')` das rotas.

---

## APIs, banco e build PHP

APIs **declarativas** rodam no alvo Dart **ou** geram PHP (PDO/MySQL) — sem escrever PHP:

```dart
// config/site_api.dart
const leadsModel = DbModel('leads', [DbColumn.id(), DbColumn('name', SqlType.varchar), ...]);
const apis = [
  ApiEndpoint(path: '/api/leads', method: HttpMethod.post, fields: [...],
    actions: [InsertInto(leadsModel), SendEmail(to: '...'), Redirect('/?lead=ok')]),
  ApiEndpoint(path: '/api/leads/list', method: HttpMethod.get, actions: [ListPaginated(leadsModel)]),
];
```

No `main.dart`, um flag controla o build PHP:
```dart
const buildPhp = true;  // dart run tool/build.dart gera build/php + roda jaspr build
```

Resposta padrão com envelope `{success, data, error, meta}` e paginação automática. Endpoints com `requiresAuth: true` exigem `Authorization: Bearer <token>`.

### Onde os dados são salvos (banco plugável)

A persistência usa a interface `DbExecutor`. Você **escolhe o backend** por `DB_PROVIDER` no `.env` e adiciona as credenciais — mesma ideia do pagamento:

```dart
// main.dart — uma linha decide tudo:
db: DbRegistry.fromEnv(Platform.environment),
```

| `DB_PROVIDER` | Backend | Credenciais (`.env`) |
|---|---|---|
| `supabase` | Supabase (PostgREST) | `SUPABASE_URL`, `SUPABASE_KEY` |
| `firebase` | Firebase Firestore (REST) | `FIREBASE_PROJECT_ID`, `FIREBASE_TOKEN` |
| `rest` / `api` | API Flext (PHP **ou** Dart) | `API_BASE_URL`, `API_TOKEN` |
| `jsonl` / `memory` | arquivo / memória (dev) | `DB_DIR` |

Backend novo: `DbRegistry.register('mongo', (env, client) => MeuExecutor(...))`. Firestore é NoSQL (ids string).

### Blog vindo do banco (além de Markdown)

Posts podem vir de `.md` **e/ou** do banco, combinados:

```dart
FlextApp.run(
  blog: 'lib/content/blog',   // arquivos markdown
  blogFromDb: true,           // + posts salvos no banco (tabela blog_posts)
  ...
);
```

---

## Auth, Notificações e Pagamento

- **Auth**: `JwtService` (HS256, segredo via `.env`) + `TokenVerifier` (gancho p/ Firebase). Gate por `ApiEndpoint(requiresAuth: true)`.
- **Notificações**: `NotificationCenter.notifyAll()` dispara para **todos os canais ativos** — `TwilioSmsChannel`, `TwilioWhatsappChannel`, `FcmPushChannel` (credenciais via `.env`).
- **Pagamento**: `PaymentService.fromEnv(env)` escolhe o provedor por `PAYMENT_PROVIDER` (`asaas` | `mercadopago`); novos provedores via `PaymentRegistry.register(...)`.

> `.env` é **só lado servidor** — nunca exposto ao cliente.

---

## Rodando

```bash
dart run flext:bootstrap          # 1x após clonar (gera os entrypoints)
dart pub global activate jaspr_cli
jaspr serve                       # dev (hot reload) em http://localhost:8080
dart run tool/build.dart          # build de produção (web/Dart + PHP se buildPhp=true)
```

## Projetos de exemplo

- **`libs/flext_demo`** — site institucional + blog + **painel admin** (ilha Flutter) + APIs.
- **`libs/flext_shop`** — loja: catálogo, rota por produto (SEO), comprar via WhatsApp.
- **`libs/flext_news`** — portal de notícias em Markdown (manchete, categorias, busca).
