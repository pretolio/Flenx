---
title: SEO automático de rotas
description: Toda rota criada gera sitemap, robots e llms.txt sem nenhuma configuração.
date: 2026-06-22
author: Equipe Flext
category: Tutoriais
tags: [seo, web, llms]
views: 2310
---

No Flext, a rota é a **fonte única de verdade**. A partir dela são gerados:

1. As meta tags e o Open Graph da página.
2. O JSON-LD (Organization, WebSite, Article, FAQ).
3. A entrada no `sitemap.xml`.
4. O item no `llms.txt` e no `llms-full.txt`.

## Rotas dinâmicas

Basta registrar uma `DynamicRouteSource` com um provider de dados — cada item
vira uma URL no sitemap automaticamente. Este próprio blog funciona assim.
