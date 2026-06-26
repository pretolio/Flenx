import '../models/route_meta.dart';
import '../models/seo_config.dart';
import '../utils/xml_utils.dart';

/// Gera um `sitemap.xml` (urlset) válido conforme sitemaps.org 0.9, incluindo
/// `lastmod`, `changefreq`, `priority` e alternâncias hreflang quando houver.
class SitemapXmlGenerator {
  const SitemapXmlGenerator(this.config);

  final SeoConfig config;

  /// Limite oficial de URLs por arquivo de sitemap.
  static const int maxUrlsPerFile = 50000;

  String generate(List<RouteMeta> routes) {
    final hasAlternates = routes.any((r) => r.alternates.isNotEmpty);
    final buffer = StringBuffer()
      ..writeln('<?xml version="1.0" encoding="UTF-8"?>')
      ..write('<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"');
    if (hasAlternates) {
      buffer.write(' xmlns:xhtml="http://www.w3.org/1999/xhtml"');
    }
    buffer.writeln('>');

    for (final route in routes) {
      _writeUrl(buffer, route);
    }
    buffer.writeln('</urlset>');
    return buffer.toString();
  }

  void _writeUrl(StringBuffer b, RouteMeta r) {
    b
      ..writeln('  <url>')
      ..writeln('    <loc>${XmlUtils.escape(config.url(r.path))}</loc>');
    if (r.lastmod != null) {
      b.writeln('    <lastmod>${XmlUtils.w3cDate(r.lastmod!)}</lastmod>');
    }
    if (r.changeFreq != null) {
      b.writeln('    <changefreq>${r.changeFreq!.value}</changefreq>');
    }
    if (r.priority != null) {
      b.writeln('    <priority>${r.priority!.toStringAsFixed(1)}</priority>');
    }
    r.alternates.forEach((locale, href) {
      b.writeln('    <xhtml:link rel="alternate" hreflang="$locale" '
          'href="${XmlUtils.escape(href)}"/>');
    });
    b.writeln('  </url>');
  }
}
