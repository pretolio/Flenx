import 'package:flutter_test/flutter_test.dart';
import 'package:flext/seo/models/route_meta.dart';
import 'package:flext/seo/models/seo_config.dart';
import 'package:flext/seo/generators/llms_txt_generator.dart';
import 'package:flext/seo/generators/llms_full_generator.dart';
import 'package:flext/seo/models/faq_item.dart';

void main() {
  const config = SeoConfig(
    baseUrl: 'https://exemplo.com',
    siteName: 'Exemplo',
    description: 'Resumo do site.',
  );

  final routes = [
    const RouteMeta(
      path: '/',
      title: 'Home',
      description: 'Pagina inicial.',
      section: 'Principal',
      faqs: [FaqItem(question: 'O que é?', answer: 'Um teste.')],
    ),
    const RouteMeta(
      path: '/secreto',
      title: 'Secreto',
      description: 'oculto',
      noindex: true,
    ),
  ];

  group('LlmsTxtGenerator', () {
    final out = LlmsTxtGenerator(config).generate(routes);

    test('segue o formato llmstxt.org (H1 + blockquote + seção)', () {
      expect(out, contains('# Exemplo'));
      expect(out, contains('> Resumo do site.'));
      expect(out, contains('## Principal'));
      expect(out, contains('[Home](https://exemplo.com/): Pagina inicial.'));
    });

    test('omite rotas noindex', () {
      expect(out, isNot(contains('Secreto')));
    });
  });

  group('LlmsFullGenerator', () {
    final out = LlmsFullGenerator(config).generate(routes);

    test('inclui conteúdo e FAQs como pergunta-resposta', () {
      expect(out, contains('# Home'));
      expect(out, contains('URL: https://exemplo.com/'));
      expect(out, contains('### O que é?'));
      expect(out, contains('Um teste.'));
    });
  });
}

