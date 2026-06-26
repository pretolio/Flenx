import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'generators/llms_full_generator.dart';
import 'generators/llms_txt_generator.dart';
import 'generators/robots_txt_generator.dart';
import 'generators/sitemap_xml_generator.dart';
import 'models/seo_config.dart';
import 'sources/route_registry.dart';

/// Monta os endpoints de otimização servidos automaticamente pelo servidor:
/// `/robots.txt`, `/sitemap.xml`, `/llms.txt` e `/llms-full.txt`.
///
/// Todos derivam da mesma [RouteRegistry] — qualquer rota (estática ou dinâmica)
/// adicionada ao registry aparece automaticamente em todos eles.
class SeoEndpoints {
  SeoEndpoints({required this.config, required this.registry})
      : _sitemap = SitemapXmlGenerator(config),
        _robots = RobotsTxtGenerator(config),
        _llms = LlmsTxtGenerator(config),
        _llmsFull = LlmsFullGenerator(config);

  final SeoConfig config;
  final RouteRegistry registry;
  final SitemapXmlGenerator _sitemap;
  final RobotsTxtGenerator _robots;
  final LlmsTxtGenerator _llms;
  final LlmsFullGenerator _llmsFull;

  /// Registra as rotas no [router] shelf da aplicação.
  void mountOn(Router router) {
    router.get('/robots.txt', (Request _) async {
      return _text(_robots.generate());
    });

    router.get('/sitemap.xml', (Request _) async {
      final routes = await registry.indexable();
      return _xml(_sitemap.generate(routes));
    });

    router.get('/llms.txt', (Request _) async {
      final routes = await registry.resolveAll();
      return _text(_llms.generate(routes));
    });

    router.get('/llms-full.txt', (Request _) async {
      final routes = await registry.resolveAll();
      return _text(_llmsFull.generate(routes));
    });
  }

  Response _xml(String body) => Response.ok(
        body,
        headers: {'content-type': 'application/xml; charset=utf-8'},
      );

  Response _text(String body) => Response.ok(
        body,
        headers: {'content-type': 'text/plain; charset=utf-8'},
      );
}
