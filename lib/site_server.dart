/// Bootstrap do servidor (SSR) do Flenx. Concentra todo o boilerplate de
/// servidor — rotas SEO, APIs, render do Document (meta tags + estilos +
/// bootstrap de ilha Flutter), 404 e shelf — para o app só fornecer o
/// conteúdo (um resolvedor de rota). Importe `package:flenx/site_server.dart`
/// no `main.server.dart` (lado servidor).
library;

import 'dart:async';
import 'dart:io';

import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import 'api/api.dart';
import 'auth/token_verifier.dart';
import 'seo/seo.dart';
import 'server.dart';
import 'site/page_result.dart';

export 'site/page_result.dart';

/// Resolve um caminho no conteúdo a renderizar. Retorna `null` para 404.
typedef PageResolver =
    FutureOr<PageResult?> Function(String path, Map<String, String> query);

/// Servidor SSR pronto do Flenx.
class FlenxServer {
  FlenxServer({
    required this.seo,
    required this.registry,
    required this.resolvePage,
    required this.notFound,
    this.apis = const [],
    this.db,
    this.onEmail,
    this.tokenVerifier,
    this.styleRules = const [],
    this.rawStyles = const [],
    this.headExtra = const [],
    this.floatingButtons = const [],
    this.preloadImages = const [],
    this.emitHtaccess = true,
    this.lang = 'pt-BR',
    this.flutterBootstrap = 'flutter_bootstrap.js?cb=1',
  });

  final SeoConfig seo;
  final RouteRegistry registry;
  final PageResolver resolvePage;

  /// Componente da página 404.
  final Component notFound;

  final List<ApiEndpoint> apis;
  final DbExecutor? db;
  final EmailSender? onEmail;
  final TokenVerifier? tokenVerifier;

  /// Regras de estilo tipadas (somadas ao reset padrão).
  final List<StyleRule> styleRules;

  /// CSS puro (strings) injetado como `<style>` no `<head>`.
  final List<String> rawStyles;

  /// Tags extra para o `<head>` de toda página (ex.: loader de anúncios,
  /// scripts de analytics).
  final List<Component> headExtra;

  /// Botões flutuantes globais (fixos), renderizados ao fim do body de toda
  /// página — ex.: `FlenxFloatingButton.whatsapp(...)`.
  final List<Component> floatingButtons;

  /// Imagens da dobra inicial (LCP) para `<link rel="preload" fetchpriority>`.
  final List<String> preloadImages;

  /// Gera um `.htaccess` (Apache/LiteSpeed) no build estático: DirectoryIndex,
  /// ErrorDocument 404, redirect www→sem-www, gzip e cache. Ignorado por hosts
  /// não-Apache. Desligue com `emitHtaccess: false`.
  final bool emitHtaccess;
  final String lang;
  final String flutterBootstrap;

  /// Sobe o servidor. Se [port] for nulo, usa a variável de ambiente `PORT`
  /// (definida pelo `jaspr serve`/`jaspr build`) ou 8080.
  Future<HttpServer> start({int? port}) async {
    final resolvedPort =
        port ?? int.tryParse(Platform.environment['PORT'] ?? '') ?? 8080;
    final meta = MetaTagsBuilder(seo);
    final router = Router();

    // Geração estática: reporta TODAS as rotas + SEO + 404 ao proxy do
    // jaspr_cli na 1ª requisição (dentro do handler, aguardado antes da
    // resposta). Assim a fila enche antes do crawler esvaziá-la — evita a
    // corrida que deixava só a raiz gerada.
    var reportedAll = false;
    Future<void> reportGenerateRoutes() async {
      if (reportedAll) return;
      reportedAll = true;
      try {
        for (final m in await registry.resolveAll()) {
          await ServerApp.requestRouteGeneration(m.path, priority: m.priority);
        }
        for (final extra in const [
          '/robots.txt',
          '/sitemap.xml',
          '/llms.txt',
          '/llms-full.txt',
          '/404.html',
        ]) {
          await ServerApp.requestRouteGeneration(extra);
        }
      } catch (_) {
        // Proxy pode fechar durante o shutdown — ignora.
      }
    }

    // /robots.txt, /sitemap.xml, /llms.txt, /llms-full.txt automáticos.
    SeoEndpoints(config: seo, registry: registry).mountOn(router);

    // APIs declarativas (envelope/validação/paginação/auth padrão).
    if (apis.isNotEmpty && db != null) {
      FlenxApi(
        apis,
        db!,
        onEmail: onEmail,
        tokenVerifier: tokenVerifier,
      ).mountOn(router);
    }

    router.mount(
      '/',
      serveApp((request, render) async {
        if (kGenerateMode) await reportGenerateRoutes();
        final path = request.requestedUri.path.isEmpty
            ? '/'
            : request.requestedUri.path;
        // `/404.html`: serve a página notFound com status 200 (necessário para o
        // build estático gravar 404.html — o crawler ignora respostas != 200).
        final is404Page = path == '/404.html';
        final result = is404Page
            ? null
            : await resolvePage(path, request.requestedUri.queryParameters);
        final known = result != null;

        final routeMeta =
            await registry.find(path) ??
            (known
                ? RouteMeta(
                    path: path,
                    title: seo.siteName,
                    description: seo.description,
                  )
                : const RouteMeta(
                    path: '/404',
                    title: '404 — Página não encontrada',
                    description: 'A página que você procura não existe.',
                    noindex: true,
                  ));

        final document = Document(
          title: routeMeta.title,
          lang: lang,
          styles: [..._resetStyles, ...styleRules],
          head: [
            ...meta.build(routeMeta),
            for (final raw in rawStyles)
              Component.element(tag: 'style', children: [RawText(raw)]),
            for (final img in preloadImages)
              link(
                rel: 'preload',
                href: img,
                attributes: const {'as': 'image', 'fetchpriority': 'high'},
              ),
            ...headExtra,
            if (result?.island ?? false)
              script(src: flutterBootstrap, defer: true),
          ],
          body: floatingButtons.isEmpty
              ? (result?.body ?? notFound)
              : Component.fragment([
                  result?.body ?? notFound,
                  ...floatingButtons,
                ]),
        );

        final response = await render(document);
        if (known || is404Page) return response;
        final html = await response.readAsString();
        return Response.notFound(
          html,
          headers: {'content-type': 'text/html; charset=utf-8'},
        );
      }),
    );

    final handler = const Pipeline()
        .addMiddleware(logRequests())
        .addHandler(router.call);

    // Controle de hot-reload do jaspr: fecha o servidor anterior ao recarregar.
    final reloadLock = _activeReloadLock = Object();
    final server = await serve(
      handler,
      InternetAddress.anyIPv4,
      resolvedPort,
      shared: true,
    );
    if (reloadLock != _activeReloadLock) {
      await server.close();
      return server;
    }
    await _activeServer?.close();
    _activeServer = server;

    // Geração estática (`jaspr build` em mode: static): destrava o crawler
    // reportando a raiz (as demais rotas são reportadas na 1ª requisição, no
    // handler) e escreve o .htaccess na pasta de saída.
    if (kGenerateMode) {
      await ServerApp.requestRouteGeneration('/');
      if (emitHtaccess) {
        const outDir = String.fromEnvironment(
          'jaspr.dev.web',
          defaultValue: 'build/jaspr',
        );
        try {
          File('$outDir/.htaccess').writeAsStringSync(_htaccess);
        } catch (_) {
          // Ambiente sem acesso de escrita — ignora silenciosamente.
        }
      }
    }
    return server;
  }

  /// Config Apache/LiteSpeed padrão para deploy estático (SPA/multi-página).
  static const String _htaccess =
      'DirectoryIndex index.html\n'
      'ErrorDocument 404 /404.html\n'
      'Options -Indexes -MultiViews\n'
      '<IfModule mod_rewrite.c>\n'
      '  RewriteEngine On\n'
      '  RewriteCond %{HTTP_HOST} ^www\\.(.+)\$ [NC]\n'
      '  RewriteRule ^ https://%1%{REQUEST_URI} [L,R=301]\n'
      '</IfModule>\n'
      '<IfModule mod_deflate.c>\n'
      '  AddOutputFilterByType DEFLATE text/html text/css application/javascript application/json image/svg+xml\n'
      '</IfModule>\n'
      '<IfModule mod_expires.c>\n'
      '  ExpiresActive On\n'
      '  ExpiresByType text/css "access plus 1 year"\n'
      '  ExpiresByType application/javascript "access plus 1 year"\n'
      '  ExpiresByType image/webp "access plus 1 year"\n'
      '  ExpiresByType image/png "access plus 1 year"\n'
      '  ExpiresByType image/jpeg "access plus 1 year"\n'
      '  ExpiresByType text/html "access plus 1 hour"\n'
      '</IfModule>\n';

  static HttpServer? _activeServer;
  static Object? _activeReloadLock;

  static List<StyleRule> get _resetStyles => [
    css('html, body').styles(
      width: 100.percent,
      minHeight: 100.vh,
      padding: .zero,
      margin: .zero,
    ),
    css('h1').styles(margin: .unset),
  ];
}
