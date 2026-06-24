import 'package:flext/flext.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'sections/hero_section.dart';
import 'sections/lead_section.dart';
import 'sections/site_footer.dart';
import 'sections/steps_section.dart';
import 'site_nav.dart';

/// Site institucional real do Flext — landing completa (SSR). Conteúdo e
/// configuração ([config]) são personalizáveis. [submitted] mostra o
/// agradecimento após o envio do formulário de leads.
class FlextSite extends StatelessComponent {
  const FlextSite({this.config = const SiteConfig(), this.submitted = false, super.key});

  final SiteConfig config;
  final bool submitted;

  static const _features = [
    Feature(icon: '⚡', title: 'SSR real', description: 'HTML renderizado no servidor — performance e SEO de verdade.'),
    Feature(icon: '🧩', title: 'Widgets Flutter', description: 'O mesmo código roda no app mobile e na web, como ilhas.'),
    Feature(icon: '🔍', title: 'SEO automático', description: 'Meta tags, Open Graph, JSON-LD, sitemap e robots gerados sozinhos.'),
    Feature(icon: '🤖', title: 'Pronto para IA', description: 'llms.txt e llms-full.txt + boas práticas de GEO/AEO embutidas.'),
    Feature(icon: '📝', title: 'Blog em markdown', description: 'Content collections com categorias e tags, estilo Astro.'),
    Feature(icon: '🎨', title: 'Shell responsivo', description: 'Sidebar/drawer e top menu prontos, no app e no site.'),
  ];

  @override
  Component build(BuildContext context) {
    return div(classes: 'flext-site', [
      Component.element(tag: 'style', children: [RawText(flextSiteCss)]),
      const SiteHeader(
        brand: siteBrand,
        links: siteNavLinks,
        loginLabel: 'Entrar',
        loginOptions: siteLoginOptions,
      ),
      const HeroSection(),
      _trust(),
      const FeaturesSection(features: _features),
      const StepsSection(),
      _cta(),
      LeadSection(action: config.leadAction, submitted: submitted),
      SiteFooter(email: config.contactEmail),
      WhatsappButton(url: config.whatsappUrl),
    ]);
  }

  Component _trust() => section(classes: 'section-sm trust', [
        div(classes: 'container', [
          div(classes: 'row', [
            span([.text('Construído sobre')]),
            span([b([.text('jaspr')])]),
            span([b([.text('Flutter')])]),
            span([b([.text('Dart')])]),
            span([b([.text('shelf')])]),
          ]),
        ]),
      ]);

  Component _cta() => section(classes: 'section', [
        div(classes: 'container', [
          div(classes: 'cta', [
            h2([.text('Pronto para subir o patamar da sua web?')]),
            p([.text('Comece com o Flext hoje — open source e gratuito.')]),
            a([.text('Quero começar')], href: '#contato', classes: 'btn btn-ghost'),
          ]),
        ]),
      ]);
}
