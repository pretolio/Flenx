# Flext

Framework **Flutter/Dart estilo Next.js** para a web. Faz **SSR** (com [jaspr](https://jaspr.site)), mantém **widgets Flutter reais** como ilhas, e gera **SEO/GEO/AEO + sitemap + robots + llms.txt** automaticamente. Inclui **blog em markdown** (estilo Astro), **shell de navegação** responsivo e blocos prontos de **site institucional** (header, formulário de leads, botão de WhatsApp).

> Projeto de exemplo completo e funcional: **`libs/flext_demo`** — copie de lá.

---

## Sumário

1. [Instalação](#instalação)
2. [Estrutura de um projeto](#estrutura-de-um-projeto)
3. [Configuração (SiteConfig)](#configuração)
4. [Blog em markdown](#blog-em-markdown)
5. [SEO automático (sitemap, robots, llms.txt)](#seo-automático)
6. [Montando as páginas do site](#montando-as-páginas)
7. [Formulário de leads + WhatsApp](#leads--whatsapp)
8. [Shell de navegação (área logada)](#shell-de-navegação)
9. [Rodando](#rodando)

---

## Instalação

O exemplo é um projeto **jaspr** (`jaspr create --mode server --flutter embedded`). Adicione a dependência no `pubspec.yaml`:

```yaml
dependencies:
  flext:
    path: ../flext        # ou git/hosted quando publicado
  jaspr: ^0.23.1
  jaspr_flutter_embed: ^0.4.11
  shelf: ^1.4.0
  shelf_router: ^1.1.0

environment:
  sdk: ^3.10.0            # necessário p/ dot-shorthands (.text())
```

```dart
import 'package:flext/flext.dart';        // SEO, blog, site, models
import 'package:flext/shell.dart';         // shell Flutter — SÓ no lado web
```

> ⚠️ **Nunca** importe `package:flext/shell.dart` no servidor (puxa Flutter e quebra o build). Use-o apenas em widgets carregados via `@Import.onWeb`.

---

## Estrutura de um projeto

```
meu_site/
├── content/blog/*.md         # seus posts (markdown + frontmatter)
├── lib/
│   ├── main.server.dart      # wiring do servidor
│   ├── site_config.dart      # SiteConfig + SeoConfig + rotas
│   └── pages/                # suas páginas (montadas com blocos do flext)
└── pubspec.yaml
```

---

## Configuração

```dart
import 'package:flext/flext.dart';

const seo = SeoConfig(
  baseUrl: 'https://meusite.com',
  siteName: 'Meu Site',
  description: 'Descrição do site para SEO e redes sociais.',
  organizationName: 'Minha Empresa',
  twitterHandle: '@meusite',
  themeColor: '#01589B',
);

const site = SiteConfig(
  whatsappNumber: '5511999999999',                 // só dígitos
  whatsappMessage: 'Olá! Vim pelo site.',
  leadAction: '/api/leads',
  contactEmail: 'contato@meusite.com',
);
```

---

## Blog em markdown

Crie arquivos em `content/blog/`. O **nome do arquivo é o slug** (`meu-post.md` → `/blog/meu-post`):

```markdown
---
title: Meu primeiro post
description: Resumo curto e atraente (até ~155 caracteres).
date: 2026-06-23
author: Seu Nome
category: Tutoriais/Flutter      # hierárquica, uma por post
tags: [flutter, web]             # várias
image: /og/meu-post.png
views: 1200                      # alimenta "Mais acessados"
draft: false                     # true = não publica
---

Conteúdo em **Markdown** (comece em `##`; o título vem do frontmatter).
```

Carregue o blog no servidor (lê os `.md`, monta categorias/tags/paginação):

```dart
final blog = await Blog.load('content/blog');

// Resolve a página de qualquer caminho /blog* (índice, post, categoria, tag):
final comp = blog.pageFor('/blog', query: 'flutter', page: 1); // busca + paginação
```

`README.md` e arquivos iniciados por `_`/`.` são ignorados. Categorias e tags geram
páginas de arquivo (`/blog/categoria/...`, `/blog/tag/...`) automaticamente.

---

## SEO automático

A **rota é a fonte única**: dela saem meta tags, JSON-LD, sitemap, robots e llms.txt.

```dart
final registry = RouteRegistry([
  StaticRouteSource([
    RouteMeta(path: '/', title: 'Início', description: '...', priority: 1.0,
      faqs: [FaqItem(question: 'O que é?', answer: '...')]),  // vira JSON-LD FAQPage
    RouteMeta(path: '/sobre', title: 'Sobre', description: '...'),
  ]),
  blog.routeSource,            // posts/categorias/tags entram sozinhos
  // rota dinâmica genérica (ex.: produtos de um banco):
  DynamicRouteSource<Produto>(
    provider: () => repo.todos(),
    build: (p) => RouteMeta(path: '/produtos/${p.slug}', title: p.nome, description: p.resumo),
  ),
]);
```

Monte os endpoints no `Router` do shelf — servidos automaticamente:

```dart
SeoEndpoints(config: seo, registry: registry).mountOn(router);
// → /robots.txt, /sitemap.xml, /llms.txt, /llms-full.txt
```

Injete as meta tags + JSON-LD no `<head>` de cada página:

```dart
final meta = await registry.find(path) ?? RouteMeta(path: path, title: seo.siteName, description: seo.description);
final headTags = MetaTagsBuilder(seo).build(meta); // List<Component> p/ Document.head
```

---

## Montando as páginas

Use os blocos prontos. `SiteLayout` dá o header + estilo + rodapé + WhatsApp:

```dart
const brand = SiteBrand(label: 'Meu Site', homeHref: '/');
const links = [
  MenuLink(label: 'Início', href: '/'),
  MenuLink(label: 'Blog', children: [
    MenuLink(label: 'Todos', href: '/blog'),
    MenuLink(label: 'Categorias', href: '/blog/categoria'),
  ]),
  MenuLink(label: 'Contato', href: '/#contato'),   // menu clicável ou expansível
];

class MinhaPagina extends StatelessComponent {
  @override
  Component build(BuildContext context) {
    return SiteLayout(
      brand: brand,
      links: links,
      navAlign: NavAlign.right,                 // ou NavAlign.center
      footer: const MeuRodape(),
      child: FeaturesSection(features: const [
        Feature(icon: '⚡', title: 'Rápido', description: 'SSR de verdade.'),
      ]),
    );
  }
}
```

---

## Leads & WhatsApp

Formulário de captura (HTML puro, POST, sem JS):

```dart
LeadForm(action: site.leadAction, submitted: jaEnviou);
WhatsappButton(url: site.whatsappUrl);          // botão flutuante
```

Receba o POST no servidor e grave (troque `FileLeadStore` por banco/CRM se quiser):

```dart
const store = FileLeadStore();                   // content/leads.jsonl
router.post('/api/leads', (Request req) async {
  final d = Uri.splitQueryString(await req.readAsString());
  final lead = Lead(name: d['name'] ?? '', email: d['email'] ?? '',
      message: d['message'] ?? '', createdAt: DateTime.now());
  if (lead.isValid) await store.add(lead);
  return Response(303, headers: {'location': '/?lead=ok#contato'}); // PRG
});
```

---

## Shell de navegação

Para áreas logadas (admin), o `AppShell` (sidebar/drawer responsivo + top bar com
perfil e notificações) é um **widget Flutter** — use como **ilha** via
`jaspr_flutter_embed`, importando `package:flext/shell.dart` num arquivo `@Import.onWeb`:

```dart
// shell_demo.dart (compilado só no web)
import 'package:flutter/material.dart';
import 'package:flext/shell.dart';

class AdminApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    home: AppShell(
      title: 'Admin',
      user: const AppUser(name: 'Ana Lima', role: 'Administrador'),
      notifications: const [AppNotification(title: 'Olá', message: 'bem-vindo')],
      navItems: const [
        NavItem(label: 'Dashboard', icon: Icons.dashboard, route: '/'),
        NavItem(label: 'Conteúdo', icon: Icons.folder, children: [
          NavItem(label: 'Posts', icon: Icons.article, route: '/posts'),
        ]),
      ],
      onLogout: () {},
      pages: {                               // troca só o conteúdo, esqueleto fica
        '/': (c) => const Center(child: Text('Dashboard')),
        '/posts': (c) => const Center(child: Text('Posts')),
      },
    ),
  );
}
```

Desktop → sidebar fixa; tablet/mobile → drawer. Tudo automático.

---

## Rodando

```bash
dart pub global activate jaspr_cli
jaspr serve                 # dev (hot reload) em http://localhost:8080
jaspr build                 # build de produção
```

Veja o **`libs/flext_demo`** para um site completo de ponta a ponta usando todos
os recursos acima.
