import 'package:flutter_test/flutter_test.dart';
import 'package:flenx/seo/models/faq_item.dart';
import 'package:flenx/seo/models/page_kind.dart';
import 'package:flenx/seo/models/route_meta.dart';
import 'package:flenx/seo/models/seo_config.dart';
import 'package:flenx/seo/generators/json_ld_generator.dart';

void main() {
  const config = SeoConfig(
    baseUrl: 'https://exemplo.com',
    siteName: 'Exemplo',
    description: 'desc',
    organizationName: 'Exemplo Ltda',
    searchUrlTemplate: '/busca?q={search_term_string}',
  );

  final gen = const JsonLdGenerator(config);

  test('sempre inclui Organization e WebSite', () {
    final out = gen.build(
      const RouteMeta(path: '/', title: 'Home', description: 'd'),
    );
    final types = out.map((m) => m['@type']).toList();
    expect(types, containsAll(['Organization', 'WebSite', 'WebPage']));
    final website = out.firstWhere((m) => m['@type'] == 'WebSite');
    expect(website['potentialAction']['@type'], 'SearchAction');
  });

  test('gera FAQPage quando há faqs', () {
    final out = gen.build(
      const RouteMeta(
        path: '/',
        title: 'Home',
        description: 'd',
        faqs: [FaqItem(question: 'P?', answer: 'R.')],
      ),
    );
    final faq = out.firstWhere((m) => m['@type'] == 'FAQPage');
    expect(faq['mainEntity'], hasLength(1));
    expect(faq['mainEntity'][0]['name'], 'P?');
  });

  test('artigo usa headline e author', () {
    final out = gen.build(
      const RouteMeta(
        path: '/blog/x',
        title: 'Post',
        description: 'd',
        kind: PageKind.blogPost,
        author: 'Maria',
      ),
    );
    final article = out.firstWhere((m) => m['@type'] == 'BlogPosting');
    expect(article['headline'], 'Post');
    expect(article['author']['name'], 'Maria');
  });
}
