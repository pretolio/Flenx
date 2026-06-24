import '../models/route_meta.dart';
import '../models/seo_config.dart';

/// Gera o `/llms.txt` no formato llmstxt.org: H1 com o nome, blockquote de
/// resumo e seções H2 com listas de links curados `- [título](url): resumo`.
///
/// As rotas são agrupadas por [RouteMeta.section]; rotas sem seção vão para
/// uma seção padrão. Rotas `noindex` são omitidas.
class LlmsTxtGenerator {
  const LlmsTxtGenerator(this.config, {this.defaultSection = 'Páginas'});

  final SeoConfig config;
  final String defaultSection;

  String generate(List<RouteMeta> routes) {
    final visible = routes.where((r) => !r.noindex).toList();
    final grouped = <String, List<RouteMeta>>{};
    for (final r in visible) {
      grouped.putIfAbsent(r.section ?? defaultSection, () => []).add(r);
    }

    final b = StringBuffer()
      ..writeln('# ${config.siteName}')
      ..writeln()
      ..writeln('> ${config.description}')
      ..writeln();

    for (final entry in grouped.entries) {
      b
        ..writeln('## ${entry.key}')
        ..writeln();
      for (final r in entry.value) {
        b.writeln('- [${r.title}](${config.url(r.path)}): ${r.effectiveSummary}');
      }
      b.writeln();
    }
    return b.toString();
  }
}
