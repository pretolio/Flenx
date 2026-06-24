---
title: Proxy reverso embutido
description: Encaminhe requisições para outros serviços direto do Flext, sem nginx.
date: 2026-06-19
author: Equipe Flext
category: Tutoriais
tags: [proxy, web]
views: 540
---

O Flext traz proxy reverso configurável no próprio servidor.

## Quando usar

- Encaminhar `/api` para um backend separado.
- Servir assets de outro domínio sob o mesmo host.

Basta declarar a rota de proxy e pronto — sem configurar nginx à parte.
