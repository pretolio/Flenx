---
title: Deploy do Flenx em produção
description: Build de produção e publicação do seu site Flenx, do zero ao ar.
date: 2026-06-17
author: Equipe Flenx
category: Tutoriais
tags: [deploy, web, ssr]
views: 1320
---

Publicar um site Flenx é direto: gere o build de produção e suba o servidor.

## Passos

1. `flenx build` gera os assets e o servidor.
2. Suba em qualquer host que rode Dart (VM) ou container.
3. Aponte o domínio e pronto.

O mesmo servidor entrega SSR, API, sitemap e llms.txt.
