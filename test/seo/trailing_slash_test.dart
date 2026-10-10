import 'package:flutter_test/flutter_test.dart';
import 'package:flenx/seo/generators/sitemap_xml_generator.dart';
import 'package:flenx/seo/models/route_meta.dart';
import 'package:flenx/seo/models/seo_config.dart';

void main() {
  const sem = SeoConfig(baseUrl: 'https://x.com', siteName: 'X', description: 'd');
  const com = SeoConfig(baseUrl: 'https://x.com', siteName: 'X', description: 'd', trailingSlash: true);

  group('SeoConfig.url com trailingSlash', () {
    test('padrão (desligado) não mexe em nada', () {
      expect(sem.url('/sobre'), 'https://x.com/sobre');
      expect(sem.url('sobre'), 'https://x.com/sobre');
    });
    test('páginas ganham barra final; a raiz fica', () {
      expect(com.url('/'), 'https://x.com/');
      expect(com.url('/sobre'), 'https://x.com/sobre/');
      expect(com.url('/servicos/frota'), 'https://x.com/servicos/frota/');
      expect(com.url('/sobre/'), 'https://x.com/sobre/');
    });
    test('arquivos e URLs absolutas não mudam', () {
      expect(com.url('/assets/og.png'), 'https://x.com/assets/og.png');
      expect(com.url('/sitemap.xml'), 'https://x.com/sitemap.xml');
      expect(com.url('/llms.txt'), 'https://x.com/llms.txt');
      expect(com.url('https://outro.com/a'), 'https://outro.com/a');
    });
    test('query e âncora ficam depois da barra', () {
      expect(com.url('/busca?q=a'), 'https://x.com/busca/?q=a');
      expect(com.url('/pagina#topo'), 'https://x.com/pagina/#topo');
    });
    test('o sitemap usa a mesma URL do canonical', () {
      final xml = const SitemapXmlGenerator(com).generate([
        const RouteMeta(path: '/', title: 't', description: 'd'),
        const RouteMeta(path: '/sobre', title: 't', description: 'd'),
      ]);
      expect(xml, contains('<loc>https://x.com/</loc>'));
      expect(xml, contains('<loc>https://x.com/sobre/</loc>'));
    });
  });
}
