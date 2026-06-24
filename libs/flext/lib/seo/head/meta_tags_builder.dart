import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../generators/json_ld_generator.dart';
import '../models/route_meta.dart';
import '../models/seo_config.dart';
import '../utils/json_utils.dart';

/// Constrói os componentes do `<head>` para uma rota: meta description, robots,
/// canonical, Open Graph, Twitter Cards, theme-color, hreflang e os blocos
/// JSON-LD. O `<title>` é tratado pelo `Document(title:)`.
class MetaTagsBuilder {
  MetaTagsBuilder(this.config) : _jsonLd = JsonLdGenerator(config);

  final SeoConfig config;
  final JsonLdGenerator _jsonLd;

  List<Component> build(RouteMeta r) {
    final canonical = config.url(r.path);
    return [
      meta(name: 'description', content: r.description),
      meta(
        name: 'robots',
        content: r.noindex
            ? 'noindex, nofollow'
            : 'index, follow, max-snippet:-1, max-image-preview:large, max-video-preview:-1',
      ),
      if (r.keywords.isNotEmpty)
        meta(name: 'keywords', content: r.keywords.join(', ')),
      link(rel: 'canonical', href: canonical),
      if (config.themeColor != null)
        meta(name: 'theme-color', content: config.themeColor),
      // Open Graph
      _prop('og:type', r.kind.ogType),
      _prop('og:title', r.title),
      _prop('og:description', r.description),
      _prop('og:url', canonical),
      _prop('og:site_name', config.siteName),
      _prop('og:locale', config.defaultLocale),
      if (r.image != null) _prop('og:image', config.url(r.image!)),
      // Twitter Cards
      meta(name: 'twitter:card', content: 'summary_large_image'),
      meta(name: 'twitter:title', content: r.title),
      meta(name: 'twitter:description', content: r.description),
      if (config.twitterHandle != null)
        meta(name: 'twitter:site', content: config.twitterHandle),
      if (r.image != null)
        meta(name: 'twitter:image', content: config.url(r.image!)),
      if (r.author != null) meta(name: 'author', content: r.author),
      // hreflang
      for (final e in r.alternates.entries)
        link(rel: 'alternate', href: e.value, attributes: {'hreflang': e.key}),
      // JSON-LD (Organization, WebSite, página, FAQ, Breadcrumb)
      for (final data in _jsonLd.build(r))
        script(
          attributes: const {'type': 'application/ld+json'},
          content: JsonUtils.encode(data),
        ),
    ];
  }

  /// Meta tag baseada em `property` (usada pelo Open Graph).
  Component _prop(String property, String content) =>
      meta(attributes: {'property': property}, content: content);
}
