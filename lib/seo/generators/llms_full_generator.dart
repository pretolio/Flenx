import '../models/route_meta.dart';
import '../models/seo_config.dart';

/// Gera o `/llms-full.txt`: todo o conteúdo do site concatenado em Markdown,
/// para ingestão completa por LLMs/agentes.
///
/// Usa [RouteMeta.markdown] quando presente; senão sintetiza um bloco a partir
/// de título, descrição e FAQs (que já são pergunta-resposta — ótimo p/ AEO).
class LlmsFullGenerator {
  const LlmsFullGenerator(this.config);

  final SeoConfig config;

  String generate(List<RouteMeta> routes) {
    final visible = routes.where((r) => !r.noindex);
    final b = StringBuffer()
      ..writeln('# ${config.siteName} — Conteúdo completo')
      ..writeln()
      ..writeln('> ${config.description}')
      ..writeln();

    // Dados estruturados da empresa
    final addr = config.address;
    if (config.telephone != null || config.email != null || addr != null || config.sameAs.isNotEmpty) {
      b.writeln('## Contato e localização');
      b.writeln();
      if (config.telephone != null) b.writeln('- **Telefone:** ${config.telephone}');
      if (config.email != null) b.writeln('- **E-mail:** ${config.email}');
      if (addr != null) {
        b.writeln('- **Endereço:** ${addr.streetAddress}, ${addr.addressLocality}${addr.addressRegion != null ? " – ${addr.addressRegion}" : ""}, ${addr.postalCode}');
        if (addr.hasGeo) b.writeln('- **Geo:** latitude ${addr.latitude}, longitude ${addr.longitude}');
      }
      for (final s in config.sameAs) b.writeln('- **Social:** $s');
      b.writeln();
    }

    if (config.about != null) {
      b
        ..writeln('## Sobre a empresa')
        ..writeln()
        ..writeln(config.about!.trim())
        ..writeln();
    }

    for (final r in visible) {
      b
        ..writeln('---')
        ..writeln()
        ..writeln('# ${r.title}')
        ..writeln()
        ..writeln('URL: ${config.url(r.path)}')
        ..writeln();
      if (r.markdown != null && r.markdown!.trim().isNotEmpty) {
        b
          ..writeln(r.markdown!.trim())
          ..writeln();
      } else {
        b
          ..writeln(r.description)
          ..writeln();
      }
      if (r.faqs.isNotEmpty) {
        b
          ..writeln('## Perguntas frequentes')
          ..writeln();
        for (final faq in r.faqs) {
          b
            ..writeln('### ${faq.question}')
            ..writeln()
            ..writeln(faq.answer)
            ..writeln();
        }
      }
    }
    return b.toString();
  }
}
