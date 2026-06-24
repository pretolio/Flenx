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
