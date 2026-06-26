import 'package:flutter_test/flutter_test.dart';
import 'package:flenx/seo/models/change_freq.dart';
import 'package:flenx/seo/models/route_meta.dart';
import 'package:flenx/seo/models/seo_config.dart';
import 'package:flenx/seo/generators/sitemap_xml_generator.dart';
import 'package:flenx/seo/generators/sitemap_index_generator.dart';

void main() {
  const config = SeoConfig(
    baseUrl: 'https://exemplo.com',
    siteName: 'Exemplo',
    description: 'desc',
  );

  group('SitemapXmlGenerator', () {
    test('gera urlset válido com loc, lastmod, changefreq e priority', () {
      final xml = const SitemapXmlGenerator(config).generate([
        RouteMeta(
          path: '/',
          title: 'Home',
          description: 'd',
          priority: 1.0,
          changeFreq: ChangeFreq.daily,
          lastmod: DateTime.utc(2026, 6, 22),
        ),
      ]);

      expect(xml, contains('<?xml version="1.0" encoding="UTF-8"?>'));
      expect(xml, contains('http://www.sitemaps.org/schemas/sitemap/0.9'));
      expect(xml, contains('<loc>https://exemplo.com/</loc>'));
      expect(xml, contains('<changefreq>daily</changefreq>'));
      expect(xml, contains('<priority>1.0</priority>'));
      expect(xml, contains('<lastmod>2026-06-22T00:00:00.000Z</lastmod>'));
    });

    test('escapa caracteres reservados na URL', () {
      final xml = const SitemapXmlGenerator(config).generate([
        const RouteMeta(path: '/busca?q=a&b', title: 't', description: 'd'),
      ]);
      expect(xml, contains('q=a&amp;b'));
    });
  });

  group('SitemapIndexGenerator', () {
    test('gera sitemapindex com os shards', () {
      final xml = const SitemapIndexGenerator(config)
          .generate(['/sitemap-0.xml', '/sitemap-1.xml']);
      expect(xml, contains('<sitemapindex'));
      expect(xml, contains('<loc>https://exemplo.com/sitemap-0.xml</loc>'));
      expect(xml, contains('<loc>https://exemplo.com/sitemap-1.xml</loc>'));
    });
  });
}

