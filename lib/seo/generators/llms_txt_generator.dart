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

    // Bloco de identidade da empresa (contato, endereço)
    final hasContact =
        config.telephone != null ||
        config.email != null ||
        config.address != null ||
        config.sameAs.isNotEmpty;
    if (hasContact) {
      b.writeln('## Informações da empresa');
      b.writeln();
      if (config.telephone != null) {
        b.writeln('- **Telefone:** ${config.telephone}');
      }
      if (config.email != null) b.writeln('- **E-mail:** ${config.email}');
      if (config.address != null) {
        final a = config.address!;
        b.writeln(
          '- **Endereço:** ${a.streetAddress}, ${a.addressLocality}${a.addressRegion != null ? " – ${a.addressRegion}" : ""}, ${a.postalCode}, ${a.addressCountry}',
        );
        if (a.hasGeo) {
          b.writeln('- **Coordenadas:** ${a.latitude}, ${a.longitude}');
        }
      }
      for (final s in config.sameAs) {
        b.writeln('- **Perfil:** $s');
      }
      b.writeln();
    }

    if (config.about != null) {
      b
        ..writeln('## Sobre')
        ..writeln()
        ..writeln(config.about!.trim())
        ..writeln();
    }

    for (final entry in grouped.entries) {
      b
        ..writeln('## ${entry.key}')
        ..writeln();
      for (final r in entry.value) {
        b.writeln(
          '- [${r.title}](${config.url(r.path)}): ${r.effectiveSummary}',
        );
      }
      b.writeln();
    }
    return b.toString();
  }
}
