# Changelog

## 0.3.2

- **Compatibilidade com a plataforma Web**: `package:flenx/flenx.dart` não puxa
  mais `dart:io`. As partes que dependem do servidor usam imports condicionais —
  no navegador viram stubs que lançam `UnsupportedError`:
  `BlogRepository`, `BlogScaffold`, `JsonlDbExecutor`, `PhpApiGenerator` e
  `FileLeadStore`. `DbConfig` e os canais FCM/Twilio agora leem variáveis de
  ambiente por um helper multiplataforma (`platformEnv`), vazio no navegador.
  Nenhuma mudança de API no servidor.

## 0.3.1

- `SiteHeader` mobile: o menu agora abre como **drawer lateral direito** (desliza
  da direita, com backdrop escuro que fecha ao tocar fora) e o hambúrguer fica
  encostado à direita do header. Antes o menu caía como painel de largura total.

## 0.3.0

### Deploy / geração estática
- **`jaspr build` em `mode: static` agora funciona** — a flenx passou a reportar
  todas as suas rotas ao proxy do `jaspr_cli` no modo generate (`ServerApp.requestRouteGeneration`).
  Antes o build travava em "Starting server app..." porque a flenx usa servidor
  próprio (shelf) e não a `ServerApp` do jaspr, então nenhuma rota era reportada.
- **SEO + 404 gerados automaticamente no build estático, sem config**: o build
  agora emite `robots.txt`, `sitemap.xml`, `llms.txt`, `llms-full.txt` e `404.html`
  direto na saída (a flenx reporta esses paths e serve `/404.html` com status 200).

### UI / só-Dart (sem HTML/CSS no app)
- **`FlenxHeroCover`** — hero de tela cheia com imagem de fundo (Ken Burns), logo
  flutuando e conteúdo animado, 100% via parâmetros (o CSS fica dentro do componente).
- **`FlenxFloatingButton`** — botão flutuante genérico para qualquer chat/ação
  (presets `.whatsapp`/`.telegram`/`.messenger` + configurável: ícone, cor, canto).
- **`FlenxApp.run(floatingButtons:)`** — botões flutuantes globais (todas as páginas).
- **`FlenxApp.run(globalScripts:)`** — injeta `<script src defer>` global (ex.: analytics).
- **`SiteBrand(logoHeight:)`** — altura do logo no header sem escrever CSS.
- **`FlenxStyle` + `globalStyles: List<FlenxStyle>`** — estilo global no padrão Flutter:
  seletor + props tipadas (`Color`, `EdgeInsets`, `FontWeight`, `TextAlign`, `double` em px),
  ex.: `FlenxStyle('h1', color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold)`.
  A flenx converte em CSS. **`rawGlobalStyles: List<String>`** é o escape hatch de CSS puro
  (aceita até o conteúdo de um arquivo `.css`).

### Tema / marca
- **`FlenxApp.run(primaryColor:, primaryColorDark:)`** — define os tokens CSS
  `--primary`/`--primary-dark` (usados por botões, links e destaques) sem precisar
  escrever CSS.
- **`FlenxApp.run(faviconUrl:, appleTouchIconUrl:)`** — emite `<link rel="icon">` e
  `<link rel="apple-touch-icon">` no `<head>`.

### SEO
- **`SeoConfig(defaultImage:)`** — `og:image`/`twitter:image` padrão para todas as
  páginas quando a rota não define `RouteMeta.image` (cai para `logoUrl` se ausente).

### Acessibilidade
- **`FlenxPage` agora emite um landmark `<main>`** — o conteúdo fica dentro de
  `<main>`, com header/footer (SiteHeader/FlenxFooter) fora, preservando os
  landmarks banner/contentinfo no topo. Corrige o aviso "documento sem main".

### DX
- `package:flenx/app.dart` agora re-exporta `css`, `Styles` e `StyleRule` — dá para
  customizar `globalStyles` (ex.: `css.keyframes(...)`) sem importar jaspr direto.

## 0.2.0

### Novos componentes
- **FlenxAnimated** — scroll-reveal com IntersectionObserver (fadeIn, slideUp, slideDown, slideLeft, slideRight, zoomIn, pulse, bounce, float, spin)
- **FlenxAnimation** — enum de animações para todos os componentes
- **FlenxHeroSplit** — hero duas colunas (texto + imagem); no mobile a imagem vira fundo desfocado
- **FlenxSvg** — exibe SVG externo (`<img>`) ou inline (sem HTML/CSS)
- **FlenxLottie** — animação Lottie via CDN com fila de inicialização
- **FlenxRive** — animação Rive via CDN com fila de inicialização
- **FlenxAudioPlayer** — player de áudio inline (faixa ou rádio ao vivo)
- **FlenxAudioPlayerFloat** — player flutuante fixo no bottom (rádio / podcast)
- **FlenxAccordion / FlenxAccordionItem** — acordeão FAQ puro CSS
- **FlenxBanner** — banner de anúncio/alerta com ícone e dismiss
- **FlenxAlert** — alerta inline com variantes (info, success, warning, error)
- **FlenxSpacer** — espaçamento vertical explícito

### Animações em componentes existentes
- `FlenxColumn`, `FlenxGrid` — parâmetro `animation` com stagger automático nos filhos
- `FlenxCard`, `FlenxHeading`, `FlenxText`, `FlenxButton`, `FlenxSection` — parâmetro `animation`
- `FeaturesSection`, `FlenxSteps` — parâmetro `animate: bool`

### Background image
- `FlenxSection` e `FlenxCard` — parâmetros `backgroundImage` e `backgroundImageOpacity`

### Sistema de temas (CSS custom properties)
- `FlenxPage` — novos parâmetros `primaryColor`, `primaryDarkColor`, `secondaryColor`; injeta `:root { --primary: X; --primary-d: Y; }` para que **todos** os componentes usem a cor da marca automaticamente
- `site_header_styles` — `.login-btn`, `.brand`, `.nav-link:hover` e dropdown usam `var(--primary)` / `var(--primary-d)`
- `FlenxButton` — default via `var(--primary, fallback)`; aceita `color` para sobrescrever por instância
- `FeaturesSection` e `FlenxSteps` — eyebrow/badge via `var(--primary, fallback)`

### SEO / GEO / AEO
- `SeoConfig` — novos campos: `telephone`, `email`, `address: SeoAddress?`, `about: String?`
- `SeoAddress` — endereço físico (PostalAddress + GeoCoordinates para schema.org)
- `JsonLdGenerator` — emite `@type: LocalBusiness` (com endereço, telefone, geo) quando `address` está presente
- `LlmsTxtGenerator` e `LlmsFullGenerator` — injetam bloco de contato/endereço e `about` no topo do `/llms.txt` e `/llms-full.txt`

### Kit de e-commerce (loja estilo marketplace)
- **FlenxStoreShell** — raiz da loja: header (logo, CEP, busca, conta/desejos/carrinho), nav de categorias, promo e rodapé
- **FlenxHeroCarousel / FlenxHeroSlide** — hero em carrossel com fade automático, imagem de fundo e indicadores clicáveis
- **FlenxHeroBanner** — banner de destaque único (eyebrow, título, preço, CTA)
- **FlenxProductCard** — card de produto (foto/emoji, selo, marca, preços, parcelas, comprar)
- **FlenxProductShelf** — prateleira com contador regressivo ao vivo e carrossel horizontal com auto-avanço
- **FlenxProductGrid** — grade de catálogo
- **FlenxProductDetail** — página de detalhe (trilha, foto, preços, descrição, CTAs)
- **FlenxPricePills / FlenxBrandStrip / FlenxBenefitsBar** — faixas de preço, marcas e benefícios
- Modelos: `FlenxPricePill`, `FlenxBrandItem`, `FlenxBenefit`, `FlenxHeroSlide`

### Blocos de portal de notícias (estilo G1)
- **FlenxNewsHeader** — cabeçalho de portal com editorias e indicador AO VIVO
- **FlenxNewsHighlight** — manchete principal (imagem 16:9, chapéu, linha-fina, autor · data)
- **FlenxNewsCard** — cartão de notícia
- **FlenxNewsSectionTitle** — título de editoria
- **FlenxMostRead** — bloco "Mais lidas" numerado
- **FlenxSidebarLayout** — layout de duas colunas (conteúdo + sidebar)

## 0.1.1

- README reformulado: logo, badges, links (pub.dev, showcase, exemplos) e
  seção de **build e deploy** (servidor SSR, site estático e API PHP).
- Sem mudanças de código.

## 0.1.0

- Primeira versão pública do **Flenx**.
- SSR em Flutter/Dart (jaspr) com kit de UI em Dart (sem HTML/CSS).
- Blog com fontes em Markdown e/ou banco de dados, editor de posts estilo G1.
- SEO/GEO/AEO automáticos: sitemap, robots, llms.txt e JSON-LD.
- Admin reutilizável (ilha Flutter): CRUD genérico, permissões por papel,
  editor de conteúdo e edição da tela inicial.
- APIs declarativas (runtime Dart/shelf ou geração de PHP) e banco plugável
  (JSONL, MySQL, Supabase, Firebase, REST).
