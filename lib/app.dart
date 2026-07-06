/// API de mais alto nível do Flenx: um `main.server.dart` declarativo.
///
/// Cada rota é definida UMA vez ([FlenxRoute] = SEO + componente juntos). O app
/// só lista as rotas e chama `FlenxApp.run(...)`. Pensado para iniciantes.
/// Importe `package:flenx/app.dart` (lado servidor).
library;

import 'dart:async';

import 'package:jaspr/dom.dart' show StyleRule, css, script, link;
import 'package:jaspr/server.dart';

import 'ads/ads_config.dart';
import 'api/api.dart';
import 'auth/token_verifier.dart';
import 'blog/blog.dart';
import 'blog/sources/blog_source.dart';
import 'blog/sources/database_blog_source.dart';
import 'blog/sources/dynamic_blog_route_source.dart';
import 'blog/sources/markdown_blog_source.dart';
import 'seo/seo.dart';
import 'site_server.dart';

// Reexporta o barrel principal para o app importar só `package:flenx/app.dart`
// e ter SeoConfig, RouteMeta, JsonlDbExecutor, ApiEndpoint, modelos, etc.
export 'package:jaspr/server.dart' show ServerOptions;
// Estilos (css/Styles/StyleRule) — para o app customizar globalStyles/rawGlobalStyles sem
// precisar importar jaspr diretamente (ex.: css(':root'), css.keyframes(...)).
export 'package:jaspr/dom.dart' show css, Styles, StyleRule;
export 'flenx.dart';
export 'site_server.dart' show PageResult;

/// Contexto passado para cada rota: caminho e query string.
class RouteContext {
  const RouteContext(this.path, this.query);

  final String path;
  final Map<String, String> query;

  /// Atalho para um parâmetro de query (ex.: `ctx['q']`).
  String? operator [](String key) => query[key];
}

/// Constrói o conteúdo de uma rota.
typedef FlenxPageBuilder = Component Function(RouteContext ctx);

/// Transforma a página do blog no layout do site (header/footer).
typedef BlogLayoutBuilder = Component Function(Component blogPage);

/// Uma rota do site: o SEO ([meta]) e o componente ([builder]) juntos — uma
/// única definição alimenta o render, as meta tags, o sitemap e o llms.txt.
class FlenxRoute {
  const FlenxRoute(this.meta, this.builder, {this.island = false});

  /// Atalho para rotas que são **ilhas Flutter** (widgets interativos).
  const FlenxRoute.island(this.meta, this.builder) : island = true;

  final RouteMeta meta;
  final FlenxPageBuilder builder;

  /// `true` → renderiza como ilha Flutter (injeta o bootstrap do Flutter).
  final bool island;
}

/// Ponto de entrada declarativo do site Flenx.
class FlenxApp {
  /// Sobe o site com uma única chamada. [routes] é a fonte única: cada
  /// [FlenxRoute] traz o SEO e o componente. Se [blog] for informado, `/blog*`
  /// é resolvido sozinho. [extraSources] adiciona fontes dinâmicas de sitemap.
  static Future<void> run({
    required ServerOptions options,
    required SeoConfig seo,
    required List<FlenxRoute> routes,
    required Component notFound,
    String? blog,
    Blog? blogInstance,
    List<BlogSource> blogSources = const [],
    bool blogFromDb = false,
    String blogTable = 'blog_posts',
    BlogLayoutBuilder? blogLayout,
    List<IRouteSource> extraSources = const [],
    List<ApiEndpoint> apis = const [],
    DbExecutor? db,
    EmailSender? onEmail,
    TokenVerifier? tokenVerifier,
    // Estilos globais TIPADOS (Dart) — ex.: `css('.x').styles(color: ..., padding: ...)`.
    List<StyleRule> globalStyles = const [],
    // Escape hatch de CSS puro (só quando a API tipada não cobre) —
    // ex.: `css('.x').styles(raw: {'height': '48px'})`.
    List<StyleRule> rawGlobalStyles = const [],
    AdsConfig? ads,
    String lang = 'pt-BR',
    int? port,
    // Cor da marca: define o token CSS `--primary` (e `--primary-dark`) usado
    // por botões, links e destaques. Sem precisar escrever CSS.
    String? primaryColor,
    String? primaryColorDark,
    // Favicon: emite <link rel="icon"> e <link rel="apple-touch-icon"> no <head>.
    String? faviconUrl,
    String? appleTouchIconUrl,
    // Scripts globais (URLs) injetados em toda página com `defer`
    // (ex.: analytics: `['/assets/js/gtag.js']`).
    List<String> globalScripts = const [],
    // Botões flutuantes globais (aparecem em todas as páginas) — ex.:
    // `[FlenxFloatingButton.whatsapp(href: ...)]`.
    List<Component> floatingButtons = const [],
  }) async {
    Jaspr.initializeApp(options: options);

    final byPath = {for (final r in routes) r.meta.path: r};

    final sources = <IRouteSource>[
      StaticRouteSource([for (final r in routes) r.meta]),
      ...extraSources,
    ];
    // Monta as fontes de posts (Markdown e/ou banco). Quando há fonte de banco,
    // o blog é DINÂMICO: recarrega a cada request, então posts criados pelo
    // admin em runtime aparecem sem reiniciar o servidor.
    final blogSrcs = <BlogSource>[
      if (blog != null) MarkdownBlogSource(blog),
      ...blogSources,
      if (blogFromDb && db != null) DatabaseBlogSource(db, table: blogTable),
    ];
    final dynamicBlog =
        blogInstance == null && blogSrcs.any((s) => s is DatabaseBlogSource);

    Blog? loaded = blogInstance;
    if (loaded == null && blogSrcs.isNotEmpty && !dynamicBlog) {
      loaded = await Blog.fromSources(blogSrcs);
    }
    if (loaded != null) {
      sources.add(loaded.routeSource);
    } else if (dynamicBlog) {
      sources.add(DynamicBlogRouteSource(blogSrcs));
    }
    final registry = RouteRegistry(sources);

    bool handlesBlog(String path) =>
        path == '/blog' || path.startsWith('/blog/');

    Future<Blog?> blogFor(String path) async {
      if (!handlesBlog(path)) return null;
      if (loaded != null) return loaded;
      if (dynamicBlog) return Blog.fromSources(blogSrcs);
      return null;
    }

    await FlenxServer(
      seo: seo,
      registry: registry,
      apis: apis,
      db: db,
      onEmail: onEmail,
      tokenVerifier: tokenVerifier,
      notFound: notFound,
      globalStyles: [
        // Token da marca (--primary) definido cedo para valer em toda a UI.
        if (primaryColor != null)
          css(':root').styles(
            raw: {
              '--primary': primaryColor,
              if (primaryColorDark != null) '--primary-dark': primaryColorDark,
            },
          ),
        ...globalStyles,
        ...rawGlobalStyles,
      ],
      headExtra: [
        if (faviconUrl != null) link(rel: 'icon', href: faviconUrl),
        if (appleTouchIconUrl != null)
          link(rel: 'apple-touch-icon', href: appleTouchIconUrl),
        for (final src in globalScripts) script(src: src, defer: true),
        if (ads != null && ads.enabled)
          script(
            src: ads.loaderUrl,
            async: true,
            attributes: const {'crossorigin': 'anonymous'},
          ),
      ],
      floatingButtons: floatingButtons,
      lang: lang,
      resolvePage: (path, query) async {
        final blogNow = await blogFor(path);
        if (blogNow != null && blogNow.handles(path)) {
          final page = blogNow.pageFor(
            path,
            query: query['q'],
            page: int.tryParse(query['page'] ?? '') ?? 1,
          );
          if (page == null) return null;
          return PageResult(blogLayout != null ? blogLayout(page) : page);
        }
        final route = byPath[path];
        if (route == null) return null;
        return PageResult(
          route.builder(RouteContext(path, query)),
          island: route.island,
        );
      },
    ).start(port: port);
  }
}
