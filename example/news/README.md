# flenx_news

**Portal de notícias de exemplo** do [Flenx](../flenx). As notícias são arquivos **Markdown** (`lib/content/blog/`); a home mostra a manchete e as últimas, e `/blog*` (índice, categorias, tags, busca, artigo) é gerado automaticamente. Tudo em Dart, com **SSR + SEO + llms.txt**.

## Estrutura (o que você edita)

```
lib/
├── main.dart                  # carrega o blog e passa as notícias para a home
├── config/                    # news_seo, news_routes
├── content/blog/*.md          # as notícias (markdown + frontmatter)
└── views/                     # home, sobre, layout do blog, nav/footer (kit Dart)
```

> Nova notícia: `dart run flenx:new_post "Título" Categoria` (ou crie o `.md`).

## Rodando

```bash
dart pub get
dart run flenx:bootstrap       # gera os entrypoints
dart pub global activate jaspr_cli
jaspr serve                    # http://localhost:8080
```

Rotas: `/`, `/blog` (+ `/blog/<slug>`, `/blog/categoria`, `/blog/tag`, busca `?q=`), `/sobre`, `/sitemap.xml`, `/llms.txt`.
