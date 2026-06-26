import '../models/seo_config.dart';

/// Gera o `robots.txt` a partir das regras por crawler do [SeoConfig],
/// referenciando o sitemap. Inclui buscadores tradicionais e crawlers de IA.
class RobotsTxtGenerator {
  const RobotsTxtGenerator(this.config);

  final SeoConfig config;

  /// [sitemapPaths]: caminhos dos sitemaps a anunciar (ex.: `/sitemap.xml`).
  String generate({List<String> sitemapPaths = const ['/sitemap.xml']}) {
    final b = StringBuffer()
      ..writeln('# robots.txt — ${config.siteName}')
      ..writeln('# Gerado automaticamente pelo Flenx');

    for (final rule in config.crawlerRules) {
      b
        ..writeln()
        ..writeln('User-agent: ${rule.userAgent}');
      // Disallow globais aplicados a cada grupo, antes dos específicos.
      for (final path in config.globalDisallow) {
        b.writeln('Disallow: $path');
      }
      for (final path in rule.disallow) {
        b.writeln('Disallow: $path');
      }
      for (final path in rule.allow) {
        b.writeln('Allow: $path');
      }
      if (rule.crawlDelay != null) {
        b.writeln('Crawl-delay: ${rule.crawlDelay}');
      }
    }

    b.writeln();
    for (final path in sitemapPaths) {
      b.writeln('Sitemap: ${config.url(path)}');
    }
    // Aponta o llms.txt como comentário (não há diretiva oficial).
    b.writeln('# LLMs: ${config.url('/llms.txt')}');
    return b.toString();
  }
}
