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

> ### 🤖 Lendo isto como IA / agente de código?
> O Flenx foi feito para você gerar **só Dart** — nunca escreva HTML/CSS no app. Antes de codar:
> 1. **Regra de ouro:** uma classe `StatelessComponent` por arquivo; a raiz de toda página é `FlenxPage([...])`; nunca use tags HTML cruas (`div`, `a`, `iframe`) — use os componentes Flenx desta referência.
> 2. **Como criar UI nova:** componha os componentes do kit (ver [Referência de UI](#-referência-completa-de-ui)). Para criar um componente próprio, estenda `StatelessComponent` e combine peças do kit — ver [Criando seus próprios componentes](#-criando-seus-próprios-componentes).
> 3. **Aprenda pelos exemplos:** os três projetos em [`example/`](https://github.com/pretolio/Flenx/tree/main/example) (institucional, loja, notícias) são feitos 100% assim — copie os padrões deles.
> 4. **Toda a API pública está catalogada abaixo** com assinatura real e exemplo. Se um parâmetro não está aqui, ele não existe.

---

O Flenx é um framework para construir **sites e apps web em Dart** com renderização no servidor (via [jaspr](https://jaspr.site)). Tudo é **opcional** — comece com um site SSR + SEO em minutos e ative blog, admin, APIs e banco conforme o projeto cresce.

## 📑 Índice

- [Recursos](#-recursos)
- [Começar](#-começar)
- [Build e deploy](#️-build-e-deploy)
- [Regras de ouro (escreva só Dart)](#-regras-de-ouro-escreva-só-dart)
- [Criando seus próprios componentes](#-criando-seus-próprios-componentes)
- [**Referência completa de UI**](#-referência-completa-de-ui) — primitivas, blocos, notícias, e-commerce, modelos, enums, paleta
- [**Referência do framework**](#-referência-do-framework) — rotas+SEO, blog, admin, APIs, banco, auth, notificações, pagamento, ilhas Flutter
- [Exemplos](#-exemplos)
- [Licença](#-licença)

## ✨ Recursos

- **UI em Dart** — `FlenxColumn`, `FlenxHero`, `FlenxCard`, `FlenxHeroCover`… geram o HTML/CSS por baixo.
- **SEO automático** — meta tags, Open Graph (com `defaultImage`), JSON-LD, `sitemap.xml`, `robots.txt`, `llms.txt` e `404.html` a partir de uma única definição de rota.
- **Marca sem CSS** — `primaryColor`, `faviconUrl`, `SiteBrand(logoHeight:)`, `globalStyles` (tipado, estilo Flutter) e escape hatch `rawGlobalStyles`.
- **Extras globais** — `floatingButtons` (WhatsApp/Telegram/qualquer chat), `globalScripts` (analytics) e `preloadImages` (LCP) em todas as páginas.
- **Deploy estático 1-comando** — `jaspr build` gera HTML + SEO + `404.html` + favicon + `.htaccess` (Apache) prontos, sem configuração.
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
  flenx: ^0.2.0
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
      // Marca/UI só com parâmetros — sem escrever CSS:
      primaryColor: '#EA580C',                         // token --primary da UI
      faviconUrl: '/favicon.ico',                      // <link rel="icon">
      appleTouchIconUrl: '/apple-touch-icon.png',
      preloadImages: const ['/assets/hero.webp'],      // LCP (preload fetchpriority=high)
      globalScripts: const ['/assets/js/gtag.js'],     // <script defer> global (analytics)
      floatingButtons: [                               // botões flutuantes globais
        FlenxFloatingButton.whatsapp(href: 'https://wa.me/5511999999999'),
      ],
      globalStyles: const [                            // estilos globais tipados (padrão Flutter)
        FlenxStyle('h1', color: '#fff', fontSize: 48, fontWeight: 700),
      ],
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

O Flenx tem **três alvos de build**. Escolha pelo que seu site usa e por onde vai hospedar:

| Alvo | `jaspr.mode` | Comando | Mantém APIs/admin/banco? | Onde hospedar |
|---|---|---|---|---|
| **Servidor SSR** (recomendado) | `server` | `jaspr build` | ✅ Sim | Render, Fly.io, Cloud Run, VPS, Docker — qualquer host Dart |
| **Site estático** | `static` | `jaspr build` | ❌ Não (só conteúdo) | GitHub Pages, Netlify, Vercel, S3, Cloudflare Pages |
| **Estático + API PHP** | `static` | `dart run tool/build.dart` | ✅ Sim (via PHP/MySQL) | hospedagem compartilhada (cPanel, Hostinger, Hostgator…) |

> Regra prática: **tem admin/carrinho/formulário/banco?** Use **SSR** (ou **PHP**). É **só conteúdo** (landing, blog, institucional)? **Estático** serve e é o mais barato.

<details open>
<summary><strong>1. Servidor SSR — qualquer host com Dart (recomendado)</strong></summary>

Gera um executável self-contained que serve as páginas e roda APIs, admin, banco e formulários.

```bash
# no pubspec.yaml:  jaspr: { mode: server }
dart run flenx:bootstrap
jaspr build                 # gera build/jaspr/ (app + assets)
PORT=8080 ./build/jaspr/app # roda o servidor; lê a porta de $PORT
# alvos extras: jaspr build --target exe|aot-snapshot|kernel --target-os linux|macos|windows
```

**Docker** (serve em qualquer lugar — Cloud Run, Fly.io, VPS, Kubernetes):

```dockerfile
# Dockerfile
FROM dart:stable AS build
WORKDIR /app
COPY pubspec.* ./
RUN dart pub get
COPY . .
RUN dart pub global activate jaspr_cli && dart run flenx:bootstrap && \
    dart pub global run jaspr_cli:jaspr build
FROM scratch
COPY --from=build /app/build/jaspr /app
COPY --from=build /runtime/ /
ENV PORT=8080
EXPOSE 8080
CMD ["/app/app"]
```

```bash
docker build -t meusite . && docker run -p 8080:8080 --env-file .env meusite
```

**Render / Fly.io / Cloud Run** (usam o Dockerfile acima):

| Plataforma | Como subir |
|---|---|
| **Render** | New → Web Service → repo Git → "Docker" → defina as env vars do `.env` no painel |
| **Fly.io** | `fly launch` (detecta o Dockerfile) → `fly secrets set DB_PROVIDER=... JWT_SECRET=...` → `fly deploy` |
| **Cloud Run** | `gcloud run deploy meusite --source . --port 8080 --set-env-vars=...` |
| **VPS (systemd)** | copie `build/jaspr/` para o servidor e rode o executável atrás de Nginx (proxy reverso na porta `$PORT`) |

> Defina as variáveis de ambiente (banco, JWT, gateways) no painel da plataforma — nunca commite o `.env`.
</details>

<details>
<summary><strong>2. Site estático — GitHub Pages, Netlify, Vercel…</strong></summary>

Pré-renderiza todas as rotas em HTML. Hospede em qualquer CDN/host de arquivos.

```bash
# no pubspec.yaml:  jaspr: { mode: static }
dart run flenx:bootstrap
jaspr build                 # gera build/jaspr/ com HTML + assets prontos
```

O build estático já sai **pronto para deploy, sem configuração**: além do HTML de
todas as rotas + assets, o Flenx gera automaticamente `robots.txt`, `sitemap.xml`,
`llms.txt`, `llms-full.txt`, `404.html`, o `favicon`/`apple-touch-icon` e um
`.htaccess` (Apache/LiteSpeed: `DirectoryIndex`, `ErrorDocument 404`, redirect
`www`→sem-`www`, gzip e cache). Desligue o `.htaccess` com `emitHtaccess: false`.

> Ao subir por FTP, ignore os artefatos de build (`packages/`, `.dart_tool/`, `.build.manifest`).

Publique o conteúdo de **`build/jaspr/`**:

| Host | Como |
|---|---|
| **GitHub Pages** | suba `build/jaspr/` para o branch `gh-pages` (adicione um arquivo `.nojekyll`) |
| **Netlify** | build command `dart run flenx:bootstrap && jaspr build`, publish dir `build/jaspr` |
| **Vercel** | output dir `build/jaspr` (framework: Other) |
| **Cloudflare Pages / S3** | aponte o bucket/Pages para `build/jaspr/` |

> ⚠️ **Limites do estático:** APIs, banco, painel admin, carrinho e formulários **não funcionam** (não há servidor). Para esses recursos use **SSR** ou o build **PHP** abaixo. Bom para landing/blog/institucional. O SEO/sitemap/`llms.txt`/`404.html`/`.htaccess` são gerados normalmente.
</details>

<details>
<summary><strong>3. Estático + API PHP — hospedagem compartilhada (cPanel/Hostinger)</strong></summary>

Para rodar **com banco e formulários numa hospedagem barata sem Dart**: o front vai estático e as APIs viram arquivos PHP (PDO + MySQL).

```dart
// lib/main.dart
const buildPhp = true;   // liga a geração da API PHP
```

```bash
dart run tool/build.dart    # gera build/jaspr/ (front estático) + build/php/ (endpoints .php + migrations.sql)
```

**Subindo** (FTP/cPanel):
1. Suba o conteúdo de `build/jaspr/` para a pasta pública (`public_html/`).
2. Suba `build/php/` para uma subpasta de API (ex.: `public_html/api/`), de modo que `/api/leads` → `api/leads.php`.
3. Importe `build/php/migrations.sql` no MySQL (phpMyAdmin) para criar as tabelas.
4. Configure as credenciais do banco no PHP gerado (host, usuário, senha do MySQL da hospedagem).

Cada `ApiEndpoint` vira um `.php` equivalente (mesma validação de campos e ações `InsertInto`, `SendEmail`, `Redirect`…). Assim o **mesmo código Dart** roda como servidor Dart **ou** como API PHP, sem reescrever.
</details>

<details>
<summary><strong>Variáveis de ambiente (.env) — só lado servidor</strong></summary>

SSR e PHP leem credenciais do ambiente (nunca expostas ao cliente). Principais:

```bash
PORT=8080                       # porta do servidor SSR
DB_PROVIDER=supabase            # supabase | firebase | rest | jsonl | memory
SUPABASE_URL=...                # (por provedor — ver tabela do banco)
SUPABASE_KEY=...
JWT_SECRET=troque-isto          # auth
PAYMENT_PROVIDER=mercadopago    # asaas | mercadopago
MP_ACCESS_TOKEN=...             # credenciais do gateway
TWILIO_SID=... TWILIO_TOKEN=... # notificações (opcional)
```

Em produção, defina-as no painel da plataforma (Render/Fly/Cloud Run) ou no `.env` do servidor — **nunca** commite o arquivo.
</details>

## 📐 Regras de ouro (escreva só Dart)

Estas regras valem para **todo** código Flenx — siga-as sempre:

- **Uma classe por arquivo** — nunca duas classes no mesmo `.dart`.
- **Nunca crie funções que retornam `Component`** — crie sempre uma classe `StatelessComponent`.
- **Nunca use tags HTML cruas** (`div()`, `a()`, `iframe()`, `p()`, `section()`) nas páginas — use apenas componentes Flenx. (Tags cruas são detalhe interno da lib.)
- **`FlenxPage([...])` é a raiz de toda página** — coloque os blocos como filhos diretos; **não** envolva em `FlenxColumn` (quebra a largura 100%).
- **Importe tudo via** `package:flenx/flenx.dart` (UI) ou `package:flenx/app.dart` (rotas/SEO/run) — não importe jaspr direto nas páginas.

```dart
import 'package:flenx/flenx.dart';

class HomePage extends StatelessComponent {
  const HomePage({super.key});

  @override
  Component build(BuildContext context) {
    return FlenxPage([
      const MeuHeader(),                       // seu componente (compõe SiteHeader)
      FlenxHero(title: 'Bem-vindo', subtitle: 'Feito em Dart.'),
      FeaturesSection(features: const [
        Feature(icon: '⚡', title: 'Rápido', description: 'SSR + SEO.'),
      ]),
      const MeuFooter(),                       // seu componente (compõe FlenxFooter)
    ]);
  }
}
```

## 🧱 Criando seus próprios componentes

Você estende o kit do Flenx criando **classes `StatelessComponent`** que compõem os componentes existentes — **sem escrever HTML/CSS**. Há dois caminhos:

**1. Componente de composição (padrão, SSR, ótimo p/ SEO)** — combine peças do kit:

```dart
import 'package:flenx/flenx.dart';

class ProductTeaser extends StatelessComponent {
  const ProductTeaser({required this.title, required this.price, super.key});
  final String title;
  final String price;

  @override
  Component build(BuildContext context) {
    return FlenxCard(
      FlenxColumn(gap: 8, cross: FlenxAlign.start, [
        FlenxHeading(title, level: 3),
        FlenxText(price, color: FlenxPalette.primary, weight: 700),
        FlenxButton('Comprar', href: '/checkout', variant: FlenxButtonVariant.primary),
      ]),
      padding: 20, radius: 16, bordered: true, hover: FlenxCardHover.lift,
    );
  }
}
```

Use-o como qualquer componente: `ProductTeaser(title: 'Fone', price: r'R$ 199')`.

**2. Ilha Flutter (interatividade real)** — quando precisa de estado/gestos/animação Flutter, embuta um app Flutter com `FlutterIsland` (ver [Ilhas Flutter](#ilhas-flutter)). Você escreve `Widget` Flutter normal; o Flenx cuida do viewport/hidratação dentro da página SSR.

Em ambos os casos: **só Dart, zero HTML/CSS.**

---

# 📚 Referência completa de UI

> Importe tudo com `import 'package:flenx/flenx.dart';`. Todos os parâmetros abaixo são reais (extraídos do código). Cores aceitam hex (`'#01589B'`) ou qualquer CSS (`'linear-gradient(...)'`).

<details open>
<summary><strong>Primitivas de layout e conteúdo</strong></summary>

### `FlenxPage` — raiz da página
```dart
FlenxPage(List<Component> children, {String? primaryColor, String? primaryDarkColor, String? secondaryColor})
```
Raiz de toda página; injeta o CSS base e as CSS vars de tema herdadas pelos filhos.
Envolve o conteúdo num landmark `<main>` (acessibilidade), mantendo header/footer no topo.

### `FlenxStyle` — estilo global no padrão Flutter
```dart
FlenxStyle(String selector, {String? color, String? background, double? width, double? height,
  double? minWidth, double? maxWidth, double? minHeight, double? maxHeight, FlenxInsets? padding,
  FlenxInsets? margin, double? fontSize, int? fontWeight, String? textAlign, double? borderRadius,
  double? opacity, double? gap, Map<String, String>? raw})
// FlenxInsets.all(16) / .symmetric(horizontal:, vertical:) / .only(top:, ...)
```
Usado em `FlenxApp.run(globalStyles: [...])`. Escrita tipada (estilo Flutter), convertida em CSS
pela lib — puro-Dart (funciona na geração estática). Para CSS cru, use `rawGlobalStyles: List<String>`.

### `FlenxSection` — faixa de seção
```dart
FlenxSection({required Component child, String? background, String? backgroundImage,
  double backgroundImageOpacity = 0.3, double paddingY = 72, double maxWidthPx = 1120,
  String? id, FlenxAnimation? animation, int animationDelay = 0, int animationDuration = 600})
```
Faixa com padding vertical, container central, cor/imagem de fundo e scroll-reveal opcional.

### `FlenxColumn` — coluna (como `Column`)
```dart
FlenxColumn(List<Component> children, {double gap = 0, FlenxAlign cross = FlenxAlign.start,
  FlenxAlign main = FlenxAlign.start, double? maxWidthPx, FlenxAnimation? animation,
  int animationDelay = 0, int animationDuration = 600, int animationStagger = 80})
```

### `FlenxRow` — linha (como `Row`)
```dart
FlenxRow(List<Component> children, {double gap = 0, FlenxAlign cross = FlenxAlign.center,
  FlenxAlign main = FlenxAlign.start, bool wrap = false})
```
`wrap: true` quebra linha no mobile.

### `FlenxGrid` — grade responsiva
```dart
FlenxGrid(List<Component> children, {double minItemWidth = 280, double gap = 20,
  FlenxAlign main = FlenxAlign.center, FlenxAnimation? animation, int animationDelay = 0,
  int animationDuration = 600, int animationStagger = 80})
```
Quebra de linha automática; cada item entra com stagger se `animation` definido.

### `FlenxHeading` — título (h1–h6)
```dart
FlenxHeading(String data, {int level = 2, double? size, String? color, FlenxTextAlign? align,
  int weight = 800, FlenxAnimation? animation, int animationDelay = 0, int animationDuration = 600})
```

### `FlenxText` — parágrafo
```dart
FlenxText(String data, {double size = 16, int weight = 400, String? color, FlenxTextAlign? align,
  double? maxWidthPx, double? lineHeight, FlenxAnimation? animation, int animationDelay = 0,
  int animationDuration = 600})
```

### `FlenxButton` — botão/link
```dart
FlenxButton(String label, {required String href, FlenxButtonVariant variant = FlenxButtonVariant.primary,
  String? color, bool newTab = false, bool hover = true, FlenxAnimation? animation,
  int animationDelay = 0, int animationDuration = 600})
```
`hover: true` aplica brilho + leve subida automaticamente (sem CSS).

### `FlenxCard` — cartão
```dart
FlenxCard(Component child, {double padding = 20, double radius = 16, String background = '#ffffff',
  String? backgroundImage, double backgroundImageOpacity = 0.3, String borderColor = FlenxPalette.border,
  bool bordered = true, FlenxCardHover? hover, String glowColor = FlenxPalette.primary,
  FlenxAnimation? animation, int animationDelay = 0, int animationDuration = 600})
```
`hover`: `lift` | `glow` | `scale`.

### `FlenxImage` / `FlenxSvg` / `FlenxLottie` / `FlenxRive` — mídia
```dart
FlenxImage(String src, {String alt = '', double? widthPx, double? heightPx, double radius = 0})
FlenxSvg(String src, {double? width, double? height, double? size, String alt = '', String fit = 'contain'})
FlenxSvg.inline(String svgContent, {double? width, double? height, double? size, String alt = '', String fit = 'contain'})
FlenxLottie(String src, {double? width, double? height, double? size, bool loop = true, bool autoplay = true, String renderer = 'svg'})
FlenxRive(String src, {double? width, double? height, double? size, String? artboard, String? stateMachine, bool autoplay = true})
```
`size` é atalho para largura = altura.

### `FlenxSpacer` / `FlenxAnimated` / `FlenxFullscreen`
```dart
FlenxSpacer(double height)                                  // espaço vertical fixo (px)
FlenxAnimated(Component child, {required FlenxAnimation animation, int delay = 0, int duration = 600})
FlenxFullscreen(Component child)                            // 100% × 100vh (ilhas Flutter em tela cheia)
```

### `FlenxAudioPlayer` / `FlenxAudioPlayerFloat` — áudio/rádio
```dart
FlenxAudioPlayer(String src, {String? title, String? subtitle, bool autoplay = false, bool loop = false,
  bool isRadio = false, String accentColor = FlenxPalette.primary, String background = '#ffffff'})
FlenxAudioPlayerFloat(String src, {/* idem + */ bool initiallyVisible = true})
```
</details>

<details>
<summary><strong>Blocos de seção prontos</strong></summary>

### `FlenxHero`
```dart
FlenxHero({required String title, String? eyebrow, String? subtitle, List<FlenxButton> actions = const [],
  Component? aside, String background = 'linear-gradient(135deg, #01406F 0%, #01589B 100%)'})
```

### `FlenxHeroSplit`
```dart
FlenxHeroSplit({required Component child, required String imageSrc, String imageAlt = '',
  double imageRadius = 20, String? background, double paddingY = 80, double maxWidthPx = 1120,
  double mobileBlurPx = 14, double mobileImageOpacity = 0.20, String? id})
```
Texto à esquerda, imagem à direita; no mobile a imagem vira fundo desfocado.

### `FlenxHeroCover`
```dart
FlenxHeroCover({required String imageSrc, required String title, String? subtitle,
  List<Component> actions = const [], String? logoSrc, String logoAlt = '', double logoHeight = 120,
  String overlay = '...', String background = '#111827', double paddingY = 96, double titleSize = 48,
  bool kenBurns = true, String? id})
```
Hero de tela cheia: **imagem de fundo** (com zoom Ken Burns), **logo** opcional flutuando
acima do título e conteúdo com animação de entrada. Tudo por parâmetros — o CSS fica no componente.

### `FlenxCodeCard`
```dart
FlenxCodeCard(String code)        // cartão "janela de editor" com o código
```

### `FlenxTrustBar`
```dart
FlenxTrustBar({required List<String> items, String? label, String background = FlenxPalette.surface})
```

### `FeaturesSection` — grade de recursos
```dart
FeaturesSection({required List<Feature> features, String eyebrow = 'Recursos',
  String title = 'Tudo que um site moderno precisa', String subtitle = '...', String id = 'servicos',
  FlenxCardHover? cardHover, String cardGlowColor = FlenxPalette.primary, bool animate = false})
```

### `FlenxSteps` — passos numerados
```dart
FlenxSteps({required List<FlenxStep> steps, String? eyebrow, String? title, String? background,
  String badgeColor = FlenxPalette.primary, bool animate = false, String? id})
```

### `FlenxCta`
```dart
FlenxCta({required String title, String? subtitle, FlenxButton? action})
```

### `FlenxFooter`
```dart
FlenxFooter({required String brand, String? tagline, List<FlenxFooterColumn> columns = const [],
  String? copyright, String background = FlenxPalette.darkBg, String? id})
```

### `FlenxAlert` / `FlenxBanner` / `FlenxAccordion`
```dart
FlenxAlert(String message, {String? title, FlenxAlertVariant variant = FlenxAlertVariant.info})
FlenxBanner({required String message, FlenxButton? action, String background = FlenxPalette.primary, String textColor = '#ffffff'})
FlenxAccordion({required List<FlenxAccordionItem> items, String accentColor = FlenxPalette.primary})
```

### `SiteHeader` — cabeçalho institucional
```dart
SiteHeader({required SiteBrand brand, required List<MenuLink> links, String loginLabel = 'Entrar',
  String? loginHref, List<LoginOption> loginOptions = const [], NavAlign align = NavAlign.right})
// SiteBrand({required String label, String homeHref = '/', String? logoSrc, double? logoHeight})
```
Responsivo (vira hambúrguer no mobile), sem JS, indexável. Use `SiteBrand(logoHeight:)`
para o tamanho do logo (sem CSS).

### `IframeEmbed` — embute outro site/vídeo/mapa
```dart
IframeEmbed(String url, {String title = 'Conteúdo incorporado', String? ratio, double height = 480,
  String? cssHeight, bool rounded = true, bool lazy = true, bool allowFullscreen = true,
  String? allow, String? sandbox, String? classes})
```
Use `ratio: '16 / 9'` para responsivo, ou `cssHeight: 'calc(100vh - 72px)'` para portais.

### `FlenxFloatingButton` — botão flutuante (qualquer chat/ação)
```dart
FlenxFloatingButton({required String href, String label = '', String icon = '💬', String? iconImage,
  String background = '#2563eb', String textColor = '#fff', FlenxCorner corner = FlenxCorner.bottomRight,
  bool newTab = true, double offset = 20})
// Presets: FlenxFloatingButton.whatsapp(href:) / .telegram(href:) / .messenger(href:)
```
Fixo no canto da tela. Use em `FlenxApp.run(floatingButtons: [...])` para que apareça em
**todas as páginas** (global). `WhatsappButton` continua disponível como atalho.

### `FlenxNotFound` — página 404 pronta
```dart
FlenxNotFound({required SiteBrand brand, List<MenuLink> links = const [], List<LoginOption> loginOptions = const [],
  Component? footer, SiteConfig config = const SiteConfig(), String code = '404',
  String title = 'Página não encontrada', String message = '...',
  List<MenuLink> actions = const [MenuLink(label: 'Voltar ao início', href: '/')]})
```
</details>

<details>
<summary><strong>Blocos de portal de notícias (estilo G1)</strong></summary>

```dart
FlenxNewsHeader({required String brandPrimary, required List<MenuLink> links, String? brandSecondary,
  String liveLabel = 'AO VIVO', String homeHref = '/'})

FlenxNewsHighlight({required String title, required String imageUrl, required String href,
  String? hat, String? subtitle, String? meta})            // manchete principal (meta = autor · data)

FlenxNewsCard({required String title, required String imageUrl, required String href,
  String? hat, String? description})                       // cartão de notícia

FlenxNewsSectionTitle(String label)                        // título de editoria (barra vertical)

FlenxMostRead(List<MenuLink> items, {String title = 'Mais lidas'})   // bloco numerado

FlenxSidebarLayout({required Component main, required Component aside})  // 2 colunas (empilha no mobile)
```
</details>

<details>
<summary><strong>Kit de e-commerce (loja estilo marketplace)</strong></summary>

### `FlenxStoreShell` — raiz da loja
```dart
FlenxStoreShell({required String brand, required List<MenuLink> categories, List<Component> children = const [],
  String searchPlaceholder = 'O que você procura hoje?', String searchAction = '/produtos', String? cep,
  String accountHref = '/conta', String accountLabel = 'Entrar', String wishlistHref = '/produtos',
  String cartHref = '/carrinho', int cartCount = 0, String? promo, List<FlenxFooterColumn> footerColumns = const [],
  List<String> payments = const [], String? copyright})
```
Header (logo, CEP, busca, conta/desejos/carrinho) + nav de categorias + promo + rodapé.

### `FlenxHeroCarousel` / `FlenxHeroBanner` — destaque
```dart
FlenxHeroCarousel({required List<FlenxHeroSlide> slides, int intervalMs = 5000})   // fade automático + dots
FlenxHeroBanner({required String title, required String ctaHref, String? eyebrow, String? subtitle,
  String? priceFrom, String? priceValue, String ctaLabel = 'aproveite'})           // banner único
```

### `FlenxProductCard` / `FlenxProductShelf` / `FlenxProductGrid` / `FlenxProductDetail`
```dart
FlenxProductCard({required String name, required String price, required String href, String? emoji,
  String? imageUrl, String? brand, String? oldPrice, String? installment, String? badge,
  String? buyHref, String buyLabel = 'Comprar'})

FlenxProductShelf({required String title, required List<Component> products, String? subtitle, String? countdown})
// countdown: 'HH:MM:SS' — conta regressiva ao vivo + carrossel horizontal com auto-avanço

FlenxProductGrid({required List<Component> products, String? title})   // catálogo

FlenxProductDetail({required String name, required String price, required String buyHref, String? emoji,
  String? imageUrl, String? brand, String? oldPrice, String? installment, String? badge, String? description,
  String buyLabel = 'Adicionar ao carrinho', String? secondaryHref, String? secondaryLabel,
  List<MenuLink> breadcrumb = const []})
```

### `FlenxPricePills` / `FlenxBrandStrip` / `FlenxBenefitsBar`
```dart
FlenxPricePills({required List<FlenxPricePill> items})
FlenxBrandStrip({required List<FlenxBrandItem> items, String action = 'Confira'})
FlenxBenefitsBar({required List<FlenxBenefit> items})
```
</details>

<details>
<summary><strong>Modelos de dados</strong></summary>

```dart
SiteBrand({required String label, String homeHref = '/', String? logoSrc})
MenuLink({required String label, String? href, List<MenuLink> children = const [], bool external = false})
LoginOption({required String label, required String href})
Feature({required String icon, required String title, required String description})
FlenxStep(String title, String description)
FlenxFooterColumn(String title, List<MenuLink> links)
FlenxAccordionItem(String title, String body, {bool open = false})

// E-commerce:
FlenxHeroSlide({required String title, required String ctaHref, String? eyebrow, String? subtitle,
  String? priceFrom, String? priceValue, String ctaLabel = 'aproveite', String? backgroundImage})
FlenxPricePill({required String value, required String href, String label = 'A PARTIR DE'})
FlenxBrandItem({required String icon, required String label, required String href})
FlenxBenefit({required String icon, required String title, required String subtitle})
```
</details>

<details>
<summary><strong>Enums</strong></summary>

```dart
FlenxAlign        // start, center, end, spaceBetween, spaceAround, stretch
FlenxTextAlign    // left, center, right, justify
FlenxButtonVariant// primary (fundo cheio), ghost (borda), soft (fundo claro)
FlenxAlertVariant // info, success, warning, error
FlenxCardHover    // lift, glow, scale
NavAlign          // right, center
FlenxAnimation    // fadeIn, slideUp, slideDown, slideLeft, slideRight, zoomIn, pulse, bounce, float, spin
```
</details>

<details>
<summary><strong>Paleta — <code>FlenxPalette</code></strong></summary>

```dart
FlenxPalette.primary      // #01589B      FlenxPalette.darkBg       // #0B1220
FlenxPalette.primaryDark  // #01406F      FlenxPalette.darkSurface  // #111A2B
FlenxPalette.accent       // #06B6D4      FlenxPalette.darkBorder   // #243245
FlenxPalette.ink          // #0F172A      FlenxPalette.darkInk      // #E2E8F0
FlenxPalette.muted        // #64748B
FlenxPalette.surface      // #F8FAFC
FlenxPalette.border       // #E2E8F0
```
</details>

---

# ⚙️ Referência do framework

> Importe com `import 'package:flenx/app.dart';`. Tudo é opcional — ative só o que precisar.

<details open>
<summary><strong>Rotas + SEO (fonte única) — <code>FlenxApp.run</code></strong></summary>

`FlenxApp.run` é o ponto de entrada. Cada `FlenxRoute` junta o SEO (`RouteMeta`) e o componente; disso saem sozinhos: meta tags, Open Graph/Twitter, JSON-LD, `/sitemap.xml`, `/robots.txt`, `/llms.txt`.

```dart
Future<void> FlenxApp.run({
  required ServerOptions options,
  required SeoConfig seo,
  required List<FlenxRoute> routes,
  required Component notFound,
  String? blog,                       // pasta de Markdown
  bool blogFromDb = false,            // + posts do banco
  String blogTable = 'blog_posts',
  List<BlogSource> blogSources = const [],
  List<IRouteSource> extraSources = const [],   // rotas dinâmicas (sitemap)
  List<ApiEndpoint> apis = const [],
  DbExecutor? db,
  EmailSender? onEmail,
  TokenVerifier? tokenVerifier,
  AdsConfig? ads,
  String lang = 'pt-BR',
  int? port,
  // Marca / UI (sem escrever CSS):
  String? primaryColor, String? primaryColorDark,   // token --primary
  String? faviconUrl, String? appleTouchIconUrl,     // <link rel=icon>/apple-touch
  List<String> globalScripts = const [],             // <script defer> global
  List<Component> floatingButtons = const [],        // botões flutuantes globais
  List<String> preloadImages = const [],             // preload LCP (fetchpriority=high)
  List<FlenxStyle> globalStyles = const [],          // estilos tipados (padrão Flutter)
  List<String> rawGlobalStyles = const [],           // escape hatch: CSS cru (strings)
  bool emitHtaccess = true,                          // gera .htaccess no build estático
})

// Rota: SEO + componente (posicional)
FlenxRoute(RouteMeta meta, Component Function(RouteContext ctx) builder, {bool island = false})
FlenxRoute.island(RouteMeta meta, builder)    // injeta o bootstrap Flutter (páginas interativas)
```

**`SeoConfig`** (global):
```dart
SeoConfig({required String baseUrl, required String siteName, required String description,
  String defaultLocale = 'pt_BR', String? twitterHandle, String? logoUrl, String? defaultImage,
  String? organizationName, List<String> sameAs = const [], String? searchUrlTemplate,
  String? themeColor, String? telephone, String? email, SeoAddress? address, String? about,
  List<String> globalDisallow = const [], List<CrawlerRule>? crawlerRules})
// defaultImage: og:image/twitter:image padrão das páginas (cai para logoUrl).
```
> Por padrão, libera buscadores e IAs (Googlebot, Bingbot, GPTBot, ClaudeBot, PerplexityBot, OAI-SearchBot…) e bloqueia scrapers abusivos (Bytespider, CCBot).

**`RouteMeta`** (por página):
```dart
RouteMeta({required String path, required String title, required String description,
  PageKind kind = PageKind.website, String? image, ChangeFreq? changeFreq, double? priority,
  DateTime? lastmod, List<String> keywords = const [], bool noindex = false, String? section,
  String? summary, String? markdown, List<FaqItem> faqs = const [], List<Breadcrumb> breadcrumbs = const [],
  String? author, DateTime? datePublished, Map<String, String> alternates = const {}})

FaqItem({required String question, required String answer})              // → JSON-LD FAQPage
PageKind   // website, article, blogPost, faq, product, collection, profile
ChangeFreq // always, hourly, daily, weekly, monthly, yearly, never
```

**Rotas dinâmicas** (ex.: 1 rota por item do banco, com SEO):
```dart
DynamicRouteSource<Post>(
  provider: () => repo.all(),
  build: (p) => RouteMeta(path: '/blog/${p.slug}', title: p.title, description: p.excerpt, kind: PageKind.blogPost),
)  // passe em extraSources: [...]
```
</details>

<details>
<summary><strong>Blog (Markdown e/ou banco)</strong></summary>

```bash
dart run flenx:blog_init                         # cria a pasta + 1 post de boas-vindas
dart run flenx:new_post "Título" Categoria tag1,tag2   # novo post (frontmatter pronto, draft)
```

```dart
FlenxApp.run(
  ...,
  blog: 'lib/content/blog',   // posts em Markdown
  blogFromDb: true,           // (opcional) + posts no banco (tabela blog_posts)
);
```
Índice, post, categorias, tags, busca (`?q=`) e paginação (`?page=N`) são automáticos.

**`BlogPost`** (modelo): `slug, title, description, date, bodyMarkdown` (obrigatórios) + `subtitle, author, image, category, tags, draft, views`.

**Fontes** (`BlogSource`): `MarkdownBlogSource(dir)`, `DatabaseBlogSource(db, table:)`, `CompositeBlogSource([...])`.
</details>

<details>
<summary><strong>Painel admin (ilha Flutter)</strong></summary>

Preencha `FlenxAdminApp` num arquivo Flutter `lib/views/admin/admin_app.dart`; `dart run flenx:bootstrap` gera o wiring. Adicione `jaspr_flutter_embed` e `jaspr: flutter: embedded` no pubspec.

```dart
FlenxAdminApp({required AppUser user, required List<NavItem> navItems, required Map<String, WidgetBuilder> pages,
  String title = 'Admin', List<AppNotification> notifications = const [], String initialRoute = '/',
  VoidCallback? onLogout, AppRole? role})

AppUser({required String name, required String role, String? email, String? avatarUrl})
NavItem({required String label, required IconData icon, String? route, VoidCallback? onTap,
  List<NavItem> children = const [], int? badge, String? permission})

FlenxDashboard({required List<DashboardStat> stats, required List<ActivityItem> activity,
  String greeting = 'Olá 👋', String subtitle = 'Aqui está um resumo de hoje.'})
DashboardStat({required IconData icon, required String label, required String value, required String trend})
```

**CRUD declarativo** (lista/cria/edita/exclui ligado às suas APIs):
```dart
ResourceConfig({required String title, required List<ResourceField> fields, required String listPath,
  String? createPath, String? updatePath, String? deletePath, String titleKey = 'title',
  String? subtitleKey, String singular = 'registro', String idKey = 'id'})
ResourceField(String key, String label, {FieldKind kind = FieldKind.text, List<String> options = const [],
  bool inTable = false, bool required = false, String? hint})
FieldKind   // text, multiline, number, boolean, select, image
```

**Permissões por papel:**
```dart
AppRole(String name, Set<String> permissions)   // can('*') = acesso total
AdminPermissions.admin / .editor / .viewer      // papéis prontos
// permissões: content.manage, products.manage, orders.manage, users.manage, home.edit, settings.manage
```
</details>

<details>
<summary><strong>APIs declarativas</strong></summary>

```dart
ApiEndpoint({required String path, required List<ApiAction> actions, HttpMethod method = HttpMethod.post,
  List<Field> fields = const [], bool requiresAuth = false})

HttpMethod   // get, post, put, delete
Field(String name, {bool required = false, bool email = false, bool isInt = false, int? maxLength})
```

**Ações** (executadas em ordem):
```dart
InsertInto(DbModel model)                               // insere
ListPaginated(DbModel model, {String orderBy = 'id', bool desc = true})
FindById(DbModel model)                                 // GET por id
UpdateById(DbModel model) / DeleteById(DbModel model)
SendEmail({required String to, String subject = 'Novo contato'})
RespondJson(Map<String, Object?> body)
Redirect(String location)                               // 303 (Post/Redirect/Get)
```

```dart
const apis = [
  ApiEndpoint(path: '/api/leads', fields: [Field('email', required: true, email: true)],
    actions: [InsertInto(leadsModel), SendEmail(to: 'vendas@site.com'), Redirect('/?ok')]),
];
// FlenxApp.run(..., apis: apis, db: DbRegistry.fromEnv(Platform.environment), onEmail: meuSender);
```

Respostas seguem o envelope `ApiResponse` (`{success, data, error, meta}`); paginação via `PageRequest`/`PageMeta`.
</details>

<details>
<summary><strong>Banco de dados (plugável)</strong></summary>

```dart
DbRegistry.fromEnv(env)            // escolhe pelo DB_PROVIDER (.env); padrão: jsonl
```

| `DB_PROVIDER` | Backend | Variáveis |
|---|---|---|
| `supabase` | Supabase (PostgREST) | `SUPABASE_URL`, `SUPABASE_KEY` |
| `firebase` | Firestore | `FIREBASE_*` |
| `rest` / `api` | API REST | `DB_API_URL`, `DB_API_KEY` |
| `jsonl` | arquivos JSONL (dev) | `DB_DIR` (padrão `content/db`) |
| `memory` | em memória (testes) | — |

**Definindo uma tabela** (`DbModel`):
```dart
const leadsModel = DbModel('leads', [
  DbColumn.id(),
  DbColumn('name', SqlType.varchar),
  DbColumn('email', SqlType.varchar, unique: true),
  DbColumn('created_at', SqlType.datetime),
]);
// DbColumn(name, type, {nullable, unique, primaryKey, autoIncrement, references, defaultValue})
// DbColumn.id([name]) | DbColumn.foreign(name, 'tabela.coluna')
// SqlType: id, integer, bigint, boolean, decimal, text, varchar, datetime, json
```
Modelos prontos: `usersModel`, `blogPostsModel`, `categoriesModel`.
</details>

<details>
<summary><strong>Auth, notificações e pagamento</strong></summary>

**Auth (JWT HS256):**
```dart
final jwt = JwtService(env['JWT_SECRET']!, issuer: 'meusite');
final token = jwt.sign({'sub': userId}, expiresIn: Duration(days: 7));
final claims = jwt.verify(token);          // null se inválido/expirado
// Proteja endpoints com requiresAuth: true e passe tokenVerifier: jwt.verify em FlenxApp.run
```

**Notificações** (envia por todos os canais ativos):
```dart
final center = NotificationCenter([
  TwilioSmsChannel.fromEnv(),        // TWILIO_SID, TWILIO_TOKEN, TWILIO_FROM
  TwilioWhatsappChannel.fromEnv(),   // + TWILIO_WHATSAPP_FROM
  FcmPushChannel.fromEnv(),          // FCM_SERVER_KEY
]);
await center.notifyAll(NotificationMessage(title: 'Novo lead', body: '...', phone: '+55...'));
```

**Pagamento** (`asaas` | `mercadopago`):
```dart
final pay = PaymentService.fromEnv(env);   // PAYMENT_PROVIDER + credenciais do gateway
final res = await pay.checkout(PaymentRequest(amount: 99.9, description: 'Plano', customerEmail: 'a@b.com'));
// res.checkoutUrl → redirecione o cliente. pay.webhookStatus(payload) normaliza o status.
// Asaas: ASAAS_API_KEY, ASAAS_ENV | Mercado Pago: MP_ACCESS_TOKEN
```

> `.env` é **só lado servidor** — nunca exposto ao cliente.
</details>

<details>
<summary><strong>Ilhas Flutter</strong></summary>

Embuta um app Flutter real (state, gestos, animações) dentro da página SSR. O `@Import.onWeb` aponta para seu app Flutter deferido e fica **no app** (o jaspr_builder escaneia o pacote raiz).

```dart
// só no cliente
FlutterIsland({required Future<void> loadLibrary, required dynamic Function() builder,
  Duration debounce = const Duration(milliseconds: 200)})
```
Use uma rota `FlenxRoute.island(...)` e envolva com `FlenxFullscreen` para tela cheia. Veja `example/shop` (carrinho) para o padrão completo.
</details>

## 🧪 Exemplos

Três sites SSR completos, feitos 100% em Dart, na pasta [`example/`](https://github.com/pretolio/Flenx/tree/main/example). **São a melhor referência de como montar páginas reais** — copie os padrões deles:

| Exemplo | O que mostra | Código | Online |
|---|---|---|---|
| **Demo institucional** | landing + blog (Markdown e banco) + admin + APIs | [example/demo](https://github.com/pretolio/Flenx/tree/main/example/demo) | [▶](https://pretolio.github.io/Flenx/) |
| **Loja (e-commerce)** | catálogo, hero carrossel, prateleiras, carrinho (ilha Flutter), permissões | [example/shop](https://github.com/pretolio/Flenx/tree/main/example/shop) | [▶](https://pretolio.github.io/Flenx/shop/) |
| **Portal de notícias** | manchete, categorias, autor/data, editor G1, edição da home | [example/news](https://github.com/pretolio/Flenx/tree/main/example/news) | [▶](https://pretolio.github.io/Flenx/news/) |

Para rodar um exemplo: `cd example/demo && dart run flenx:bootstrap && jaspr serve`.

## 👤 Autor

Criado e mantido por **Gabriel Mattos** — [linkedin.com/in/gabriel-mattos-mobile](https://www.linkedin.com/in/gabriel-mattos-mobile/).

## 📄 Licença

MIT © Potenza RH. Veja [LICENSE](LICENSE).
