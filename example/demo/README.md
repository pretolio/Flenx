# flenx_demo

Site de exemplo **completo** do [Flenx](../flenx) — a referência de uso. Mostra, ponta a ponta: landing montada só com o **kit de UI em Dart** (sem HTML/CSS), **blog em markdown**, **SEO/sitemap/llms.txt** automáticos, **painel admin** (ilha Flutter) e **APIs declarativas** (Dart + PHP).

## O que você edita (versionado)

```
lib/
├── main.dart                      # FlenxApp.run(...) — liga tudo
├── config/
│   ├── site_seo.dart              # SeoConfig global
│   ├── site_routes.dart           # rotas (RouteMeta + componente)
│   └── site_api.dart              # APIs declarativas + models
├── views/
│   ├── site/                      # landing, sobre, 404, header/nav, seções
│   ├── blog/                      # moldura do blog
│   └── admin/admin_app.dart       # config do painel (FlenxAdminApp)
└── content/blog/*.md              # posts
```

## Gerado automaticamente (no `.gitignore`)

`main.server.dart`, `main.client.dart`, `views/admin/admin_page.dart`, `*.options.dart`, `*.imports.dart`, `lib/generated/`, `web/main.client.dart`, `build/`. São recriados — você não mexe.

## Rodando

```bash
dart pub get
dart run flenx:bootstrap          # 1x: gera os entrypoints a partir do main.dart
dart pub global activate jaspr_cli
jaspr serve                       # http://localhost:8080  (hot reload)
```

## Build

```bash
dart run tool/build.dart          # web/Dart + API PHP (se buildPhp=true no main.dart)
# ou só o web:
jaspr build                       # saída em build/jaspr/
```

Rotas do exemplo: `/` (landing), `/about`, `/blog` (+ categorias/tags/posts), `/admin` (ilha Flutter), `/sitemap.xml`, `/robots.txt`, `/llms.txt`.
