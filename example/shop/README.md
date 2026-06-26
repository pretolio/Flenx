# flenx_shop

**Loja de exemplo** do [Flenx](../flenx) — catálogo de produtos montado **100% em Dart** com o kit do framework (sem HTML/CSS). Demonstra: home com destaques, catálogo, **página por produto** (rota + SEO própria, no sitemap), e "comprar via WhatsApp".

## Estrutura (o que você edita)

```
lib/
├── main.dart                  # FlenxApp.run(...)
├── config/                    # shop_seo, shop_routes (1 rota por produto)
├── data/products.dart         # catálogo (numa app real, viria do banco)
└── views/                     # home, catálogo, produto, nav/footer (kit Dart)
```

## Rodando

```bash
dart pub get
dart run flenx:bootstrap       # gera os entrypoints
dart pub global activate jaspr_cli
jaspr serve                    # http://localhost:8080
```

Rotas: `/`, `/produtos`, `/produto/<slug>` (uma por produto), `/sitemap.xml`, `/robots.txt`, `/llms.txt`.
