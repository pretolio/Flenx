---
title: SSR no Flutter com Flext
description: Como o Flext renderiza HTML no servidor mantendo os widgets Flutter reais.
date: 2026-06-23
author: Equipe Flext
category: Tutoriais/Flutter
tags: [flutter, ssr, web]
image: /images/logo.svg
views: 1840
---

O **Flext** renderiza o shell da página em HTML no servidor (SEO real) e usa os
mesmos widgets Flutter do app como ilhas interativas.

## Por que isso importa

- **SEO**: o conteúdo chega pronto no HTML, sem depender de JavaScript.
- **Compatibilidade**: o mesmo widget roda no app mobile e na web.
- **Performance**: first paint rápido, hidratação só onde precisa.

## Exemplo

```dart
@Ssr
class HomePage extends FlextWidget { /* ... */ }
```

> O build gera automaticamente sitemap, robots e llms.txt para esta página.
