---
title: Categorias e tags como no WordPress
description: Organize o conteúdo com categorias hierárquicas e tags — tudo via frontmatter.
date: 2026-06-21
author: Equipe Flext
category: Tutoriais/Flutter
tags: [blog, web, seo]
views: 760
---

Declare a taxonomia no frontmatter e o Flext gera as páginas de arquivo
automaticamente, todas indexáveis.

```yaml
category: Tutoriais/Flutter
tags: [flutter, ssr, web]
```

- Categorias são **hierárquicas** (uma principal por post).
- Tags são **transversais** (várias por post).
- Cada categoria/tag ganha sua página em `/blog/categoria/...` e `/blog/tag/...`.
