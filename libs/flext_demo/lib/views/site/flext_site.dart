import 'package:flext/flext.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'sections/lead_section.dart';
import 'sections/site_footer.dart';
import 'site_nav.dart';

/// Landing do Flext — montada SÓ com componentes Dart do kit (FlextHero,
/// FlextTrustBar, FlextSteps, FlextCta...). Nada de HTML/CSS na mão.
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

  static const _code = "@FlextPage('/')\n@Ssr\nclass HomePage extends FlextWidget {\n"
      "  // SSR + SEO + sitemap: tudo automático\n  Widget build(context) => Hero();\n}";

  @override
  Component build(BuildContext context) {
    return div(classes: 'flext-site', [
      // CSS base do site (header/features/form ainda usam classes). Os blocos do
      // kit são auto-estilizados (inline), então não dependem disto.
      Component.element(tag: 'style', children: [RawText(flextSiteCss)]),
      const SiteHeader(
        brand: siteBrand,
        links: siteNavLinks,
        loginLabel: 'Entrar',
        loginOptions: siteLoginOptions,
      ),
      const FlextHero(
        eyebrow: 'Framework web em Dart',
        title: 'Flutter na web como nunca antes',
        subtitle: 'SSR real, widgets Flutter de verdade e SEO/GEO/AEO '
            'automáticos — tudo em Dart, com a DX de um framework moderno.',
        actions: [
          FlextButton('Começar agora', href: '#contato'),
          FlextButton('Ver no GitHub',
              href: 'https://github.com/flext',
              variant: FlextButtonVariant.ghost,
              newTab: true),
        ],
        aside: FlextCodeCard(_code),
      ),
      const FlextTrustBar(
        label: 'Construído sobre',
        items: ['jaspr', 'Flutter', 'Dart', 'shelf'],
      ),
      const FeaturesSection(features: _features),
      const FlextSteps(
        eyebrow: 'Como funciona',
        title: 'Do código ao SEO em 3 passos',
        steps: [
          FlextStep('Escreva uma vez',
              'Seus widgets Flutter rodam no app e na web — mesmo código.'),
          FlextStep('Anote a rota',
              'Com @FlextPage/@Ssr o build gera SSR, sitemap, robots e llms.txt.'),
          FlextStep('Publique',
              'Conteúdo indexável por Google e por motores de IA, sem esforço.'),
        ],
      ),
      const FlextCta(
        title: 'Pronto para subir o patamar da sua web?',
        subtitle: 'Comece com o Flext hoje — open source e gratuito.',
        action: FlextButton('Quero começar',
            href: '#contato', variant: FlextButtonVariant.ghost),
      ),
      LeadSection(action: config.leadAction, submitted: submitted),
      const SiteFooter(),
      WhatsappButton(url: config.whatsappUrl),
    ]);
  }
}
