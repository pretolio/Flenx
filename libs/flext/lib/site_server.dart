/// Bootstrap do servidor (SSR) do Flext. Concentra todo o boilerplate de
/// servidor — rotas SEO, APIs, render do Document (meta tags + estilos +
/// bootstrap de ilha Flutter), 404 e shelf — para o app só fornecer o
/// conteúdo (um resolvedor de rota). Importe `package:flext/site_server.dart`
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
typedef PageResolver = FutureOr<PageResult?> Function(
    String path, Map<String, String> query);

/// Servidor SSR pronto do Flext.
class FlextServer {
  FlextServer({
    required this.seo,
    required this.registry,
    required this.resolvePage,
    required this.notFound,
    this.apis = const [],
    this.db,
    this.onEmail,
    this.tokenVerifier,
    this.globalStyles = const [],
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

  /// Estilos globais extra (somados ao reset padrão).
  final List<StyleRule> globalStyles;
  final String lang;
  final String flutterBootstrap;

  /// Sobe o servidor. Se [port] for nulo, usa a variável de ambiente `PORT`
  /// (definida pelo `jaspr serve`/`jaspr build`) ou 8080.
  Future<HttpServer> start({int? port}) async {
    final resolvedPort =
        port ?? int.tryParse(Platform.environment['PORT'] ?? '') ?? 8080;
    final meta = MetaTagsBuilder(seo);
    final router = Router();

    // /robots.txt, /sitemap.xml, /llms.txt, /llms-full.txt automáticos.
    SeoEndpoints(config: seo, registry: registry).mountOn(router);

    // APIs declarativas (envelope/validação/paginação/auth padrão).
    if (apis.isNotEmpty && db != null) {
      FlextApi(apis, db!, onEmail: onEmail, tokenVerifier: tokenVerifier)
          .mountOn(router);
    }

    router.mount('/', serveApp((request, render) async {
      final path = request.requestedUri.path.isEmpty
          ? '/'
          : request.requestedUri.path;
      final result = await resolvePage(path, request.requestedUri.queryParameters);
      final known = result != null;

      final routeMeta = await registry.find(path) ??
          (known
              ? RouteMeta(
                  path: path, title: seo.siteName, description: seo.description)
              : const RouteMeta(
                  path: '/404',
                  title: '404 — Página não encontrada',
                  description: 'A página que você procura não existe.',
                  noindex: true,
                ));

      final document = Document(
        title: routeMeta.title,
        lang: lang,
        styles: [..._resetStyles, ...globalStyles],
        head: [
          ...meta.build(routeMeta),
          if (result?.island ?? false)
            script(src: flutterBootstrap, defer: true),
        ],
        body: result?.body ?? notFound,
      );

      final response = await render(document);
      if (known) return response;
      final html = await response.readAsString();
      return Response.notFound(html,
          headers: {'content-type': 'text/html; charset=utf-8'});
    }));

    final handler =
        const Pipeline().addMiddleware(logRequests()).addHandler(router.call);

    // Controle de hot-reload do jaspr: fecha o servidor anterior ao recarregar.
    final reloadLock = _activeReloadLock = Object();
    final server =
        await serve(handler, InternetAddress.anyIPv4, resolvedPort, shared: true);
    if (reloadLock != _activeReloadLock) {
      await server.close();
      return server;
    }
    await _activeServer?.close();
    _activeServer = server;
    return server;
  }

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
