# Flenx — Guia completo para criar projetos do zero

Flenx é um framework Dart/SSR (via jaspr) para sites institucionais. O desenvolvedor escreve **só Dart** — zero HTML/CSS. Os componentes geram o HTML por baixo.

---

## Regras obrigatórias de código

- **Uma classe por arquivo** — nunca coloque duas classes no mesmo `.dart`
- **Nunca crie funções que retornam `Component`** — crie sempre uma classe `StatelessComponent`
- **Nunca use tags HTML brutos** (`div()`, `a()`, `iframe()`, `p()`, `section()`) nas páginas — use apenas componentes Flenx
- Todos os imports de jaspr vêm via `package:flenx/flenx.dart` — não importe jaspr diretamente nas páginas

---

## Setup de um novo projeto

### pubspec.yaml

```yaml
name: meusite
description: Descrição do site.
version: 1.0.0
publish_to: none

environment:
  sdk: ^3.10.0

dependencies:
  flenx:
    path: /Users/lucascarvalho/StudioProjects/Flenx
  jaspr: ^0.23.1

dev_dependencies:
  build_runner: ^2.4.0
  build_web_compilers: ^4.0.0
  jaspr_builder: ^0.23.1

jaspr:
  mode: server
```

### Gerar entrypoints e rodar

```bash
# Gera lib/main.server.dart e lib/main.client.dart automaticamente
dart run flenx:bootstrap

# Rodar em desenvolvimento (hot reload em localhost:8080)
export PATH="$PATH:/Users/lucascarvalho/srv/flutter/bin:/Users/lucascarvalho/.pub-cache/bin"
jaspr serve
```

> **Nota sobre jaspr_cli:** A versão 0.22.4 instalada está patcheada para aceitar jaspr 0.23.1.
> O arquivo `/Users/lucascarvalho/.pub-cache/hosted/pub.dev/jaspr_cli-0.22.4/lib/src/version.dart`
> tem `jasprCoreVersion = '0.23.1'` (alterado manualmente). Se reinstalar o CLI, reaplique o patch.

---

## Estrutura de arquivos padrão

```
lib/
  main.dart               ← FlenxApp.run() com rotas e SEO
  main.server.dart        ← gerado por bootstrap (não editar)
  main.client.dart        ← gerado por bootstrap (não editar)
  shared/
    brand.dart            ← alstopConfig (SiteConfig com tudo centralizado)
    nome_header.dart      ← StatelessComponent que usa SiteHeader + alstopConfig
    nome_footer.dart      ← StatelessComponent que usa FlenxFooter + alstopConfig
  pages/
    home_page.dart
    pedido_page.dart
    sections/
      hero_section.dart
      cta_section.dart
```

---

## brand.dart — configuração centralizada

Toda configuração da marca fica em um único `SiteConfig`. Nunca duplique constantes.

```dart
import 'package:flenx/flenx.dart';

const meuConfig = SiteConfig(
  brand: SiteBrand(
    label: 'Minha Empresa',
    homeHref: '/',
    logoSrc: '/assets/logo.png',   // null = mostra label como texto
  ),
  links: [
    MenuLink(label: 'Início', href: '/'),
    MenuLink(label: 'Serviços', href: '/#servicos'),
    MenuLink(label: 'Contato', href: '/#contato'),
  ],
  loginLabel: 'Portal',
  loginOptions: [
    LoginOption(label: 'Acessar', href: '/app'),
  ],
  whatsappNumber: '5511999999999',   // só dígitos, formato internacional
  whatsappMessage: 'Olá! Vim pelo site e quero saber mais.',
  contactEmail: 'contato@empresa.com.br',
);
```

`meuConfig.whatsappUrl` retorna a URL `wa.me` completa com mensagem codificada.

---

## Header e Footer centralizados

### shared/meu_header.dart

```dart
import 'package:flenx/flenx.dart';
import 'brand.dart';

class MeuHeader extends StatelessComponent {
  const MeuHeader({super.key});

  @override
  Component build(BuildContext context) {
    return SiteHeader(
      brand: meuConfig.brand,
      links: meuConfig.links,
      loginLabel: meuConfig.loginLabel,
      loginOptions: meuConfig.loginOptions,
    );
  }
}
```

### shared/meu_footer.dart

```dart
import 'package:flenx/flenx.dart';
import 'brand.dart';

class MeuFooter extends StatelessComponent {
  const MeuFooter({super.key});

  @override
  Component build(BuildContext context) {
    return FlenxFooter(
      id: 'contato',
      brand: meuConfig.brand.label,
      tagline: 'Tagline da empresa.',
      copyright: '© 2026 ${meuConfig.brand.label}. Todos os direitos reservados.',
      background: '#1D3557',
      columns: [
        const FlenxFooterColumn('Serviços', [
          MenuLink(label: 'Item 1', href: '/#servicos'),
        ]),
        FlenxFooterColumn('Contato', [
          MenuLink(label: meuConfig.contactEmail, href: 'mailto:${meuConfig.contactEmail}'),
          MenuLink(label: 'WhatsApp', href: meuConfig.whatsappUrl),
        ]),
      ],
    );
  }
}
```

---

## main.dart — entrada do site

```dart
import 'package:flenx/app.dart';
import 'pages/home_page.dart';
import 'shared/brand.dart';

Future<void> runSite(ServerOptions options) async {
  await FlenxApp.run(
    options: options,
    seo: const SeoConfig(
      baseUrl: 'https://www.meusite.com.br',
      siteName: 'Minha Empresa',
      description: 'Descrição curta do site para SEO (até 155 chars).',
      organizationName: 'Minha Empresa Ltda',
      themeColor: '#01589B',
    ),
    routes: [
      FlenxRoute(
        const RouteMeta(
          path: '/',
          title: 'Título da página — Nome do Site',
          description: 'Descrição SEO da página.',
          keywords: ['palavra-chave', 'outra'],
          priority: 1.0,
        ),
        (ctx) => const HomePage(),
      ),
    ],
    notFound: FlenxNotFound(brand: meuConfig.brand),
  );
}
```

---

## FlenxPage — raiz de toda página

**Sempre use `FlenxPage([...])` como raiz.** Coloca todos os blocos como filhos diretos — nunca envolva em `FlenxColumn` ou outro wrapper, pois isso quebra a largura 100%.

```dart
import 'package:flenx/flenx.dart';
import '../shared/brand.dart';
import '../shared/meu_header.dart';
import '../shared/meu_footer.dart';

class HomePage extends StatelessComponent {
  const HomePage({super.key});

  @override
  Component build(BuildContext context) {
    return FlenxPage([
      const MeuHeader(),
      // seções aqui como filhos diretos
      const MeuFooter(),
      WhatsappButton(url: meuConfig.whatsappUrl),
    ]);
  }
}
```

---

## Componentes UI — referência completa

### FlenxSection
Seção de página (faixa com padding e container central).
```dart
FlenxSection(
  child: /* componente filho */,
  background: '#F8FAFC',   // cor hex ou CSS (null = transparente)
  paddingY: 72,             // padding vertical em px (default 72)
  maxWidthPx: 1120,         // largura máxima do container (default 1120)
  id: 'servicos',           // id HTML para âncora (null = sem id)
)
```

### FlenxColumn
Coluna vertical (como Column do Flutter).
```dart
FlenxColumn(
  [filho1, filho2],
  gap: 16,                     // espaço entre filhos em px
  cross: FlenxAlign.center,    // alinhamento cruzado (default: start)
  main: FlenxAlign.start,      // alinhamento principal (default: start)
  maxWidthPx: 720,             // largura máxima (null = sem limite)
)
```

### FlenxRow
Linha horizontal (como Row do Flutter).
```dart
FlenxRow(
  [filho1, filho2],
  gap: 12,
  cross: FlenxAlign.center,
  main: FlenxAlign.center,
  wrap: true,    // quebra linha quando tela estreita (responsivo)
)
```

### FlenxGrid
Grade responsiva — quebra linha automaticamente.
```dart
FlenxGrid(
  [card1, card2, card3],
  minItemWidth: 280,      // largura mínima de cada item em px
  gap: 20,
  main: FlenxAlign.center,
)
```

### FlenxHeading
Título (h1–h3).
```dart
FlenxHeading(
  'Texto do título',
  level: 1,                        // 1, 2 ou 3 (default 2)
  size: 48,                        // px (null = tamanho padrão do level)
  color: '#ffffff',
  align: FlenxTextAlign.center,    // left, center, right, justify
  weight: 800,                     // peso da fonte (default 800)
)
```

### FlenxText
Parágrafo de texto.
```dart
FlenxText(
  'Texto aqui',
  size: 16,
  weight: 400,
  color: '#64748B',
  align: FlenxTextAlign.center,
  maxWidthPx: 580,
  lineHeight: 1.6,
)
```

### FlenxButton
Botão/link.
```dart
FlenxButton(
  'Rótulo',
  href: '/pagina',
  variant: FlenxButtonVariant.primary,   // primary | ghost | soft
  newTab: false,
  hover: true,
)
```

### FlenxCard
Container com borda e cantos arredondados.
```dart
FlenxCard(
  filho,
  padding: 20,
  radius: 16,
  background: '#ffffff',
  borderColor: '#E2E8F0',
  bordered: true,
)
```

### FlenxImage
Imagem.
```dart
FlenxImage(
  '/assets/foto.png',
  alt: 'Descrição',
  widthPx: 400,
  heightPx: 300,
  radius: 12,
)
```

### FlenxSpacer
Espaço vertical fixo.
```dart
FlenxSpacer(24)   // 24px de altura
```

---

## Blocos prontos

### FlenxHero
Hero de landing (eyebrow + título + subtítulo + botões).
```dart
FlenxHero(
  title: 'Título principal',
  eyebrow: 'Subtexto acima',          // opcional
  subtitle: 'Descrição complementar', // opcional
  background: 'linear-gradient(135deg, #01406F 0%, #01589B 100%)',
  actions: [
    FlenxButton('CTA Principal', href: '/acao', variant: FlenxButtonVariant.primary),
    FlenxButton('Ver mais', href: '#servicos', variant: FlenxButtonVariant.ghost),
  ],
  aside: null,   // componente opcional à direita (ex.: FlenxCodeCard)
)
```

### FlenxTrustBar
Barra de diferenciais (ícones e textos em linha).
```dart
FlenxTrustBar(
  items: ['🏍️ Moto e Van', '⚡ Mesmo dia', '📍 Rastreamento'],
  label: 'Construído sobre',   // opcional, texto antes dos itens
  background: '#F8FAFC',
)
```

### FeaturesSection
Grade de cards de serviços/recursos.
```dart
FeaturesSection(
  eyebrow: 'Serviços',
  title: 'O que oferecemos',
  subtitle: 'Soluções para sua empresa.',
  id: 'servicos',
  features: [
    Feature(icon: '📦', title: 'Entrega Padrão', description: 'Descrição do serviço.'),
    Feature(icon: '⚖️', title: 'Judicial', description: 'Outro serviço.'),
  ],
)
```

### FlenxSteps
Passos numerados ("como funciona").
```dart
FlenxSteps(
  eyebrow: 'Como funciona',
  title: 'Simples e rápido',
  background: '#F8FAFC',
  badgeColor: '#E63946',   // cor dos números (default: FlenxPalette.primary)
  id: 'como-funciona',
  steps: [
    FlenxStep('Passo 1', 'Descrição do passo um.'),
    FlenxStep('Passo 2', 'Descrição do passo dois.'),
  ],
)
```

### FlenxCta
Chamada para ação centralizada (cartão com botão).
```dart
FlenxCta(
  title: 'Pronto para começar?',
  subtitle: 'Texto de suporte.',
  action: FlenxButton('Ação', href: '/acao', variant: FlenxButtonVariant.primary),
)
```

### FlenxFooter
Rodapé com colunas de links.
```dart
FlenxFooter(
  brand: 'Nome da Empresa',
  tagline: 'Frase curta.',
  copyright: '© 2026 Nome. Todos os direitos reservados.',
  background: '#1D3557',
  id: 'contato',
  columns: [
    FlenxFooterColumn('Título Col 1', [
      MenuLink(label: 'Link', href: '/pagina'),
    ]),
    FlenxFooterColumn('Contato', [
      MenuLink(label: 'email@empresa.com', href: 'mailto:email@empresa.com'),
      MenuLink(label: 'WhatsApp', href: 'https://wa.me/5511999999999'),
    ]),
  ],
)
```

### FlenxAlert
Caixa de alerta colorida.
```dart
FlenxAlert(
  'Mensagem de alerta.',
  title: 'Título opcional',
  variant: FlenxAlertVariant.info,   // info | success | warning | error
)
```

### IframeEmbed
Embute outro site ou conteúdo externo.
```dart
// Altura fixa
IframeEmbed('https://outro.site.com', title: 'Título acessível', height: 480)

// Altura calculada (preenche tela menos header)
IframeEmbed(
  'https://outro.site.com',
  title: 'Portal',
  cssHeight: 'calc(100vh - 72px)',
  rounded: false,
)

// Vídeo responsivo
IframeEmbed('https://youtube.com/embed/ID', ratio: '16 / 9')
```

### WhatsappButton
Botão flutuante verde no canto inferior direito.
```dart
WhatsappButton(url: meuConfig.whatsappUrl)
WhatsappButton(url: 'https://wa.me/5511999999999', label: 'Fale conosco')
```

### SiteHeader
Header com logo, nav e botão de login/portal.
```dart
SiteHeader(
  brand: meuConfig.brand,
  links: meuConfig.links,
  loginLabel: 'Portal',
  loginHref: '/app',          // href direto (ou null se usar loginOptions)
  loginOptions: meuConfig.loginOptions,   // dropdown (ou [] se usar loginHref)
  align: NavAlign.right,      // right | center
)
```

---

## Enums de alinhamento

```dart
// FlenxAlign — para cross/main em Column/Row/Grid
FlenxAlign.start
FlenxAlign.center
FlenxAlign.end
FlenxAlign.spaceBetween
FlenxAlign.spaceAround
FlenxAlign.stretch

// FlenxTextAlign — para align em Heading/Text
FlenxTextAlign.left
FlenxTextAlign.center
FlenxTextAlign.right
FlenxTextAlign.justify

// FlenxButtonVariant
FlenxButtonVariant.primary   // fundo primário, texto branco
FlenxButtonVariant.ghost     // transparente com borda primária
FlenxButtonVariant.soft      // fundo claro, texto primário
```

---

## FlenxPalette — cores do design system

```dart
FlenxPalette.primary      // '#01589B'  (azul principal)
FlenxPalette.primaryDark  // '#01406F'
FlenxPalette.accent       // '#06B6D4'  (ciano)
FlenxPalette.ink          // '#0F172A'  (texto escuro)
FlenxPalette.muted        // '#64748B'  (texto secundário)
FlenxPalette.surface      // '#F8FAFC'  (fundo cinza claro)
FlenxPalette.border       // '#E2E8F0'  (borda)
FlenxPalette.darkBg       // '#0B1220'
FlenxPalette.darkSurface  // '#111A2B'
FlenxPalette.darkBorder   // '#243245'
FlenxPalette.darkInk      // '#E2E8F0'
```

---

## SeoConfig — campos disponíveis

```dart
SeoConfig(
  baseUrl: 'https://www.site.com.br',   // sem barra no final
  siteName: 'Nome do Site',
  description: 'Descrição global (até 155 chars).',
  organizationName: 'Razão Social',
  themeColor: '#E63946',
  twitterHandle: '@handle',             // opcional
  logoUrl: '/assets/logo.png',          // opcional
  sameAs: ['https://instagram.com/...'],// opcional
  lang: 'pt-BR',                        // default
)
```

## RouteMeta — campos disponíveis

```dart
RouteMeta(
  path: '/pagina',
  title: 'Título — Site',         // até ~60 chars
  description: 'Descrição SEO.',  // até ~155 chars
  keywords: ['palavra', 'chave'],
  priority: 0.8,                  // 0.0–1.0 para sitemap
  noindex: false,                 // true = exclui do sitemap
  faqs: [FaqItem(question: '?', answer: '.')],  // gera JSON-LD FAQPage
  kind: PageKind.website,         // website | article | product
)
```

---

## Modelos de dados

```dart
// Marca no header
SiteBrand(label: 'Nome', homeHref: '/', logoSrc: '/logo.png')

// Item de menu
MenuLink(label: 'Página', href: '/pagina')

// Opção no dropdown do botão de login
LoginOption(label: 'Fazer Login', href: '/login')

// Card de serviço/recurso
Feature(icon: '📦', title: 'Título', description: 'Descrição.')

// Passo no FlenxSteps
FlenxStep('Título do passo', 'Descrição do passo.')

// Coluna do rodapé
FlenxFooterColumn('Título', [MenuLink(...), MenuLink(...)])
```

---

## Página com iframe (portal externo)

Padrão para páginas que embubem outro sistema:

```dart
import 'package:flenx/flenx.dart';
import '../shared/brand.dart';
import '../shared/meu_header.dart';

class PedidoPage extends StatelessComponent {
  const PedidoPage({super.key});

  @override
  Component build(BuildContext context) {
    return FlenxPage([
      const MeuHeader(),
      IframeEmbed(
        'https://sistema.externo.com/portal',
        title: 'Portal — Minha Empresa',
        cssHeight: 'calc(100vh - 72px)',
        rounded: false,
      ),
      WhatsappButton(url: meuConfig.whatsappUrl),
    ]);
  }
}
```

---

## Exemplo de seção customizada

Quando nenhum bloco pronto serve, crie uma `StatelessComponent` em arquivo próprio:

```dart
// lib/pages/sections/minha_secao.dart
import 'package:flenx/flenx.dart';

class MinhaSecao extends StatelessComponent {
  const MinhaSecao({super.key});

  @override
  Component build(BuildContext context) {
    return FlenxSection(
      background: '#1D3557',
      paddingY: 96,
      child: FlenxColumn(
        gap: 0,
        cross: FlenxAlign.center,
        maxWidthPx: 720,
        [
          const FlenxHeading('Título', level: 1, color: '#ffffff', align: FlenxTextAlign.center, size: 48),
          const FlenxSpacer(16),
          const FlenxText('Subtítulo', color: '#CBD5E1', align: FlenxTextAlign.center, size: 18),
          const FlenxSpacer(32),
          FlenxRow(
            gap: 12,
            wrap: true,
            main: FlenxAlign.center,
            const [
              FlenxButton('CTA', href: '/acao', variant: FlenxButtonVariant.primary),
              FlenxButton('Ver mais', href: '#ancora', variant: FlenxButtonVariant.ghost),
            ],
          ),
        ],
      ),
    );
  }
}
```

---

## Problemas comuns

| Problema | Causa | Solução |
|---|---|---|
| Seção não ocupa 100% da largura | Usado `FlenxColumn` como wrapper da página | Use `FlenxPage([bloco1, bloco2])` com filhos diretos |
| Erro "named parameter 'brand' isn't defined" no LSP | LSP com cache da versão publicada | Ignorar — `dart analyze` confirma que compila. Reinicie "Dart: Restart Analysis Server" |
| `jaspr serve` falha com versão incompatível | CLI 0.22.4 vs jaspr 0.23.1 | Verificar patch em `~/.pub-cache/hosted/pub.dev/jaspr_cli-0.22.4/lib/src/version.dart` |
| Porta em uso | Processo anterior ainda rodando | `ps aux \| grep dart \| awk '{print $2}' \| xargs kill -9` |
| `const` quebra em getter não-const | `alstopConfig.whatsappUrl` é um getter calculado | Remova `const` do componente que usa getters |
