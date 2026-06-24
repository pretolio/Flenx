# Flext — Estudo do Framework Flutter estilo Next.js

> Documento de estudo. Reúne objetivo, pesquisa, decisões de arquitetura, stack
> e o plano da lib de teste. Nome de trabalho do framework: **Flext** (Flutter + Next), provisório.

---

## 1. Objetivo

Criar um **framework Flutter/Dart que funcione como o Next.js** para a web, trazendo:

- **SSR** (Server-Side Rendering) — HTML renderizado no servidor, com SEO real.
- **File-based routing** — pastas/arquivos viram rotas (estilo Next/Astro).
- **API routes** — endpoints de backend no mesmo projeto.
- **Proxy reverso** e middleware.
- **Storage automático** do estado em memória via **uma anotação** (`@Persist`).
- **Hot-reload** e **CLI** `dev` / `build` / `start`.
- **Simplicidade para iniciante** — esconder o boilerplate.

**Restrição inegociável:** usar **widgets Flutter de verdade**, para manter
**compatibilidade total com o app mobile** (o mesmo widget roda no app e na web).
Mais: estilo/responsividade **estilo Tailwind** (idealmente o próprio Tailwind).

---

## 2. Pesquisa — o que foi avaliado

### 2.1 Servidores backend Dart

| Pacote | Veredito |
|---|---|
| **dart_frog** | Melhor base de servidor — file-based routing + API routes nativos sobre `shelf`, hot-reload, MIT. |
| darto | Bom runtime (proxy nativo, SSR, MIT), mas autor único, sem file-routing. |
| shelf | Substrato canônico e oficial; extensível mas exige construir tudo. |
| serverpod | Maduro, porém **SSPL** (trava produto fechado) e RPC-first (paradigma oposto). |
| conduit | REST/ORM-cêntrico, depende de reflection (ruim p/ web/AOT). |

### 2.2 SSR / renderização web

| Pacote | Veredito |
|---|---|
| **jaspr** | **Vencedor.** Framework web Dart, MIT, **em produção rodando `flutter.dev` e `dart.dev` (Google)**. SSR + SSG + SPA, hidratação real, roteamento, hot-reload. API "estilo Flutter". |
| spark_framework | Alpha, sem tração. Só referência de arquitetura "islands". |
| dartian_view | Templates Mustache, sem hidratação, **AGPL**. |
| sfwf | SSR via Puppeteer (gambiarra de SEO), imaturo. |
| ssr | **Abandonado** (3 anos), é SDUI (JSON→widget), categoria errada. |
| ssroute_data_eurostat | Falso positivo — é dataset de rotas marítimas. |

### 2.3 Tailwind / responsividade

| Opção | Veredito |
|---|---|
| **jaspr_tailwind** | Tailwind CSS **real** (roda o Tailwind CLI) — funciona porque jaspr gera HTML/DOM. Estiliza o shell web. |
| **wind** (fluttersdk) | Utility-first estilo Tailwind para **widgets Flutter** (`className` com `p-4`, `bg-blue-500`, `sm:`, `dark:`). Ativo, multiplataforma. |
| responsive_framework | Breakpoints nomeados prontos (3.3k likes). Opcional. |
| LayoutBuilder + MediaQuery.sizeOf | Padrão oficial Flutter p/ responsividade. |

---

## 3. Descoberta crítica

**SSR de widgets Flutter pelo engine é impossível hoje.** O *HTML renderer* foi
**removido no Flutter 3.29**; sobrou só CanvasKit/skwasm, que desenham num
`<canvas>` — sem DOM semântico, sem SEO, não hidratável como HTML. Não existe
`renderToString` de árvore de widgets.

**Como a restrição (widgets Flutter) ainda é atendida:**

1. **jaspr** renderiza o **shell HTML** no servidor (SEO + first paint reais).
2. **`jaspr_flutter_embed`** embute **widgets Flutter de verdade** como **ilhas**
   interativas (o engine Flutter assume um container no cliente).
3. O widget Flutter é **idêntico ao do app mobile** — zero adaptação.

Validado no exemplo oficial `examples/flutter_embedding` do repo jaspr.

---

## 4. Arquitetura decidida — "Widgets Isomórficos"

```
                  ┌─ build (Flutter)  → widget real    → APP mobile + ilha interativa
  MeuWidget ───────┤
   @Ssr            └─ build (codegen)  → part .flext.dart → HTML/jaspr (SSR + SEO)
```

- **Escreve o widget 1 vez.** O `build_runner` (regenerando **a cada build**)
  gera, num arquivo `part`, a representação para a web.
- **App mobile / ilhas interativas** → widget Flutter real (`jaspr_flutter_embed`).
- **Shell / conteúdo** → HTML real via jaspr (SEO + hidratação).
- **`className` único** (sintaxe Tailwind) → vira **Tailwind CSS real** na web
  (`jaspr_tailwind`) e **estilo de widget** no Flutter (parser estilo `wind`).
  Mesma string nos dois alvos; `sm: md: lg: dark:` funcionam em ambos.
- **O que não transpila** (CustomPaint/canvas/animação) → cai como **ilha Flutter**
  (igual ao modelo de *islands* do Astro). Não é limitação — é a divisão correta:
  conteúdo que precisa SEO vira HTML; app interativo pesado vira ilha.

### O valor do framework

Hoje, com jaspr+embed cru, o dev precisa de ~6 arquivos por tela
(`main.server.dart`, `main.client.dart`, componente jaspr, `.imports.dart`,
`FlutterEmbedView` manual, config no pubspec). **Muito boilerplate.**

O Flext transforma isso em **uma anotação**:

```dart
@FlextPage('/')
@Ssr
class HomePage extends FlextWidget {
  // só o widget Flutter — o build gera o resto (server, imports, embed) sozinho
}
```

---

## 5. Stack final

| Camada | Tecnologia |
|---|---|
| Runtime web (HTML real, hidratação, dev server) | **jaspr** |
| Ilhas de widgets Flutter | **jaspr_flutter_embed** |
| Transpilador `@Ssr` widget → `part` HTML | **source_gen / build_runner** (nosso) |
| Styling `className` (saída dupla) | **nosso parser** + **jaspr_tailwind** + **wind** |
| File-routing + API routes + proxy | **dart_frog / shelf** |
| Storage automático (`@Persist`) | **hydrated_bloc / Hive** |
| CLI `dev` / `build` / `start` | **nossa** (integra `build_runner watch`) |

---

## 6. Estrutura do monorepo (Dart workspace)

```
new_flutter/
├── ESTUDO.md                  ← este documento
├── leiame.txt / ref.txt       ← briefing original
├── pubspec.yaml               ← workspace raiz
├── refs/                      ← repos clonados p/ estudo (jaspr, dart_frog, wind)
└── packages/
    ├── flext_annotations/     ← @Ssr @FlextPage @Api @Persist @Island
    ├── flext_core/            ← classes-base (FlextWidget, etc.)
    ├── flext_codegen/         ← transpilador source_gen (o core)
    ├── flext_styling/         ← parser de className (Tailwind → Flutter + CSS)
    └── flext_cli/             ← dev / build / start
```

> Padrões de código obrigatórios: SOLID, 1 classe por arquivo, genéricos,
> ≤200 linhas/arquivo, interfaces/utils separados.

---

## 7. Lib de teste (primeira ação)

**Meta:** provar a primeira ação ponta-a-ponta — **SSR + widget Flutter real**.

1. Instalar Flutter (em andamento via scoop) + `flutter doctor`.
2. Criar uma app jaspr no modo `server` com `flutter: embedded`.
3. Uma página com:
   - **shell HTML** (jaspr) — texto/título indexável (SEO);
   - **uma ilha Flutter** — um widget real (ex.: contador `Scaffold`/`FloatingActionButton`).
4. **Testar no navegador** (Playwright): verificar que o **HTML vem do servidor**
   (view-source mostra o conteúdo) e que o **widget Flutter funciona** (clicar e contar).

**Critério de sucesso:** HTML server-side presente no `curl`/view-source +
widget Flutter interativo na página, com o mesmo código de widget que rodaria no app.

---

## 8. Estratégia de testes automatizados

Pirâmide completa — todo código nasce com teste.

| Nível | Ferramenta | O que cobre |
|---|---|---|
| **Unit** | `package:test` | Parser de `className` (tokens, prefixos `sm:`/`dark:`), lógica do transpilador, utils. |
| **Widget** | `flutter_test` | Os widgets Flutter das ilhas (interação, estado, render). |
| **Componente/SSR** | `jaspr_test` | Componentes jaspr e o **HTML gerado no servidor** (assert no markup/SEO). |
| **Codegen (golden)** | `build_test` / golden | Saída do `build_runner`: `@Ssr widget` → `part` HTML esperado. |
| **E2E / integração** | **Playwright** (plugin) | App real no navegador: SSR no view-source + ilha Flutter interativa. |

**Regras:**
- Cada pacote tem sua pasta `test/`.
- `dart test` (pacotes puros) e `flutter test` (widgets) no CI.
- E2E roda via plugin Playwright validando comportamento real (clicar, contar, navegar).
- Meta de cobertura para o core (`flext_styling`, `flext_codegen`): alta.

---

## 9. Resultado da lib de teste (validado)

Lib em `libs/flext_demo` (cada lib futura terá sua própria pasta em `libs/`).
Gerada com `jaspr create --mode server --routing multi-page --flutter embedded --backend shelf`.

**Validado ponta a ponta:**

- ✅ **SSR / SEO** — `curl http://localhost:8080/` traz o conteúdo no HTML cru:
  `<h1>Welcome`, o parágrafo, `<span>0</span>` (contador) e roteamento
  (`/about` → `<title>About</title>`).
- ✅ **Widget Flutter real** — o card "Flutter Counter" é um `CounterWidget`
  Flutter (canvas), idêntico ao que rodaria no app mobile, embutido como ilha.
- ✅ **Ponte de estado jaspr ↔ Flutter** — clicar no botão HTML atualiza o widget
  Flutter (ambos foram a `2` no teste de navegador). Screenshots:
  `flext-home-inicial.png` e `flext-home-count2.png`.
- ✅ **Testes automatizados — `flutter test`: 5/5 passando**
  - 3 de **widget** (`flutter_test`) — `test/widgets/counter_widget_test.dart`
  - 2 de **componente/SSR** (`jaspr_test`) — `test/components/counter_component_test.dart`

**Conclusão:** a arquitetura escolhida (jaspr + flutter_embed) entrega
simultaneamente SSR/SEO e widgets Flutter reais — exatamente o requisito
inegociável. Próximo passo do framework: criar a camada de anotações + CLI que
transforma esse boilerplate (≈6 arquivos/tela) em `@FlextPage`/`@Ssr`.

---

## 10. Camada de otimização automática (SEO/GEO/AEO/LLMs) — VALIDADA

Construída em `libs/flext_demo/lib/seo/` (extraível para `flext_seo`). Princípio
central — **fonte única de verdade**: o `RouteRegistry` define cada rota uma vez
e dele derivam, automaticamente, meta tags + JSON-LD + sitemap + robots + llms.

**Arquitetura (SOLID, 1 classe/arquivo, ≤200 linhas):**
- `models/` — `SeoConfig`, `RouteMeta`, `ChangeFreq`, `PageKind`, `FaqItem`, `Breadcrumb`, `CrawlerRule`.
- `sources/` — `IRouteSource`, `StaticRouteSource`, **`DynamicRouteSource<T>`** (genérico: rota dinâmica → sitemap/llms via provider de dados), `RouteRegistry`.
- `generators/` — `SitemapXmlGenerator` (+ hreflang), `SitemapIndexGenerator` (>50k URLs), `RobotsTxtGenerator`, `LlmsTxtGenerator`, `LlmsFullGenerator`, `JsonLdGenerator`.
- `head/MetaTagsBuilder` — injeta no `<head>`: description, robots, canonical, Open Graph, Twitter Cards, theme-color, hreflang e blocos JSON-LD.
- `SeoEndpoints` — monta no shelf: `/robots.txt`, `/sitemap.xml`, `/llms.txt`, `/llms-full.txt`.

**Validado ao vivo (curl):**
- ✅ `/sitemap.xml` — inclui rotas **estáticas E dinâmicas** (`/blog/:slug` expandido pela `DynamicRouteSource`).
- ✅ `/robots.txt` — allowlist de crawlers de IA corretos (GPTBot, ClaudeBot, PerplexityBot, OAI-SearchBot, Claude-SearchBot, Google-Extended…), bloqueio de Bytespider/CCBot, `Sitemap:` + ref ao llms.txt.
- ✅ `/llms.txt` — formato llmstxt.org (H1 + blockquote + seções de links).
- ✅ `/llms-full.txt` — conteúdo concatenado + FAQs como pergunta-resposta (AEO).
- ✅ `<head>` por rota — meta description, robots, OG completo, Twitter, e 4 JSON-LD (Organization, WebSite+SearchAction, WebPage/Article, FAQPage). `<title>` vindo do registry.
- ✅ **Testes: `flutter test` 21/21** (16 novos de SEO: sitemap, robots, llms, json-ld, registry).

**GEO/AEO aplicado:** JSON-LD FAQPage/Article, meta robots `max-image-preview:large`,
allowlist de IA, llms.txt/llms-full.txt, conteúdo pergunta-resposta.

**Refinamento futuro:** unificar `RouteMeta` com `jaspr_router` (web) e `go_router`
(app) — uma definição de rota alimentando navegação web + app + SEO.

---

## 11. Blog em markdown (content collections estilo Astro) — VALIDADO

Módulo `libs/flext_demo/lib/blog/` + conteúdo em `content/blog/*.md`.

- **Criar post = soltar um `.md`** (ou `dart run tool/new_post.dart "Título"`). Nome do arquivo = slug.
- **Frontmatter** (title/description/date/author/image/category/tags/draft) → posts SSR + taxonomia.
- **Categorias hierárquicas** (`Tutoriais/Flutter`) + **tags**, como no WordPress. Páginas de arquivo `/blog/categoria/...`, `/blog/tag/...` e índices `/blog/categoria`, `/blog/tag` geradas sozinhas.
- **Integração SEO**: `BlogRouteSource` → cada post/categoria/tag entra automático no sitemap, llms.txt e ganha JSON-LD (Article/Collection + breadcrumbs).
- **Zero-JS**: páginas de blog são HTML puro (sem engine Flutter) — máxima performance/SEO.
- `markdown` (pacote oficial) faz md→HTML; `draft:true`, `README.md` e `_`/`.` são ignorados.
- Validado ao vivo (curl + screenshot) e por testes.

## 12. Shell de navegação (sidebar + drawer + top bar) — VALIDADO

Widgets Flutter responsivos em `libs/flext_demo/lib/shell/` (reutilizáveis no app mobile).

- **`AppShell`**: desktop (≥1024) sidebar fixa; **tablet e mobile** (<1024) viram **drawer**.
- **Sidebar**: área de user/admin no topo, menu com itens **clicáveis e expansíveis** (submenus), botão **Sair** no rodapé.
- **Top bar** sempre presente: **notificações** (badge com não lidas + popup) e **menu de perfil expansível** (Perfil/Configurações/Sair).
- Genéricos: `NavItem` (com `children` e `badge`), `AppUser`, `AppNotification`.
- Demonstrado ao vivo em `/admin` (ilha Flutter) — screenshots desktop e mobile.

**Total de testes do projeto: 35/35** (widget + SEO + blog + shell).

---

## 13. Ambiente

- **Dart/Flutter:** não estavam instalados → instalando **Flutter 3.44.3** via scoop (bucket `extras`).
- **Node:** v24.16.0 (presente) — necessário p/ o Tailwind CLI.
- **Git:** presente.
- **Repos de referência clonados** em `refs/`: jaspr, dart_frog, wind.
