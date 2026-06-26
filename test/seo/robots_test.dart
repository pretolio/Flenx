import 'package:flutter_test/flutter_test.dart';
import 'package:flenx/seo/models/seo_config.dart';
import 'package:flenx/seo/generators/robots_txt_generator.dart';

void main() {
  const config = SeoConfig(
    baseUrl: 'https://exemplo.com',
    siteName: 'Exemplo',
    description: 'desc',
    globalDisallow: ['/api/private/'],
  );

  group('RobotsTxtGenerator', () {
    final robots = const RobotsTxtGenerator(config).generate();

    test('permite crawlers de IA úteis', () {
      expect(robots, contains('User-agent: GPTBot'));
      expect(robots, contains('User-agent: PerplexityBot'));
      expect(robots, contains('User-agent: OAI-SearchBot'));
      expect(robots, contains('User-agent: ClaudeBot'));
    });

    test('bloqueia crawlers abusivos', () {
      expect(robots, contains('User-agent: Bytespider'));
      expect(robots, contains('User-agent: CCBot'));
      // Bytespider deve ter Disallow: /
      final idx = robots.indexOf('User-agent: Bytespider');
      expect(robots.substring(idx), contains('Disallow: /'));
    });

    test('aplica disallow global e anuncia o sitemap', () {
      expect(robots, contains('Disallow: /api/private/'));
      expect(robots, contains('Sitemap: https://exemplo.com/sitemap.xml'));
    });
  });
}

