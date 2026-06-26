import '../models/seo_config.dart';
import '../utils/xml_utils.dart';

/// Gera um `<sitemapindex>` apontando para múltiplos sitemaps — usado quando o
/// site excede 50.000 URLs (ou 50MB) por arquivo.
class SitemapIndexGenerator {
  const SitemapIndexGenerator(this.config);

  final SeoConfig config;

  /// [shardPaths]: caminhos relativos dos sitemaps filhos
  /// (ex.: `/sitemap-0.xml`). [lastmod] aplicado a todos.
  String generate(List<String> shardPaths, {DateTime? lastmod}) {
    final buffer = StringBuffer()
      ..writeln('<?xml version="1.0" encoding="UTF-8"?>')
      ..writeln(
          '<sitemapindex xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">');
    for (final path in shardPaths) {
      buffer
        ..writeln('  <sitemap>')
        ..writeln('    <loc>${XmlUtils.escape(config.url(path))}</loc>');
      if (lastmod != null) {
        buffer.writeln('    <lastmod>${XmlUtils.w3cDate(lastmod)}</lastmod>');
      }
      buffer.writeln('  </sitemap>');
    }
    buffer.writeln('</sitemapindex>');
    return buffer.toString();
  }
}
