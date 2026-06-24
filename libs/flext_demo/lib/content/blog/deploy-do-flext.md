---
title: Deploy do Flext em produção
description: Build de produção e publicação do seu site Flext, do zero ao ar.
date: 2026-06-17
author: Equipe Flext
category: Tutoriais
tags: [deploy, web, ssr]
views: 1320
---

Publicar um site Flext é direto: gere o build de produção e suba o servidor.

## Passos

1. `flext build` gera os assets e o servidor.
2. Suba em qualquer host que rode Dart (VM) ou container.
3. Aponte o domínio e pronto.

O mesmo servidor entrega SSR, API, sitemap e llms.txt.
