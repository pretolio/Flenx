import 'package:flenx/flenx.dart';

import 'sections/faq_section.dart';
import 'sections/lead_section.dart';
import 'sections/novidades_section.dart';
import 'sections/site_footer.dart';
import 'site_nav.dart';

/// Landing do Flenx — montada SÓ com componentes Dart do kit. Mostra os
/// recursos da 0.2.0: tema da marca, banner, animações (scroll-reveal),
/// hero split, alertas e FAQ em acordeão.
class FlenxSite extends StatelessComponent {
  const FlenxSite({this.config = const SiteConfig(), this.submitted = false, super.key});

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

  static const _code = "@FlenxPage('/')\n@Ssr\nclass HomePage extends FlenxWidget {\n"
      "  // SSR + SEO + sitemap: tudo automático\n  Widget build(context) => Hero();\n}";

  @override
  Component build(BuildContext context) {
    return FlenxPage(
      primaryColor: '#01589B',
      primaryDarkColor: '#02406f',
      secondaryColor: '#0a86e0',
      [
        FlenxBanner(
          message: '✨ Flenx 0.2.0 — animações, temas, áudio, Lottie/Rive, SVG e mais',
          action: FlenxButton('Ver novidades', href: '#novidades'),
        ),
        const SiteHeader(
          brand: siteBrand,
          links: siteNavLinks,
          loginLabel: 'Entrar',
          loginOptions: siteLoginOptions,
        ),
        const FlenxHero(
          eyebrow: 'Framework web em Dart',
          title: 'Flutter na web como nunca antes',
          subtitle: 'SSR real, widgets Flutter de verdade e SEO/GEO/AEO '
              'automáticos — tudo em Dart, com a DX de um framework moderno.',
          actions: [
            FlenxButton('Começar agora', href: '#contato'),
            FlenxButton('Ver no GitHub',
                href: 'https://github.com/pretolio/Flenx',
                variant: FlenxButtonVariant.ghost,
                newTab: true),
          ],
          aside: FlenxCodeCard(_code),
        ),
        const FlenxTrustBar(
          label: 'Construído sobre',
          items: ['jaspr', 'Flutter', 'Dart', 'shelf'],
        ),
        const FeaturesSection(features: _features, animate: true),
        const NovidadesSection(),
        FlenxHeroSplit(
          imageSrc: 'https://picsum.photos/seed/flenx-web/720/460',
          imageAlt: 'Mesmo código no app e na web',
          background: '#ffffff',
          child: FlenxColumn(gap: 14, [
            const FlenxText('Um código, dois mundos',
                color: FlenxPalette.primary, weight: 700),
            const FlenxHeading('Do app mobile à web, sem reescrever'),
            const FlenxText(
                'Seus widgets Flutter viram ilhas interativas dentro das páginas '
                'SSR. A vitrine é indexável; a interação é Flutter de verdade.',
                color: FlenxPalette.muted,
                lineHeight: 1.6),
            FlenxButton('Conhecer os exemplos',
                href: '#novidades', variant: FlenxButtonVariant.ghost),
          ]),
        ),
        const FlenxSteps(
          eyebrow: 'Como funciona',
          title: 'Do código ao SEO em 3 passos',
          animate: true,
          steps: [
            FlenxStep('Escreva uma vez',
                'Seus widgets Flutter rodam no app e na web — mesmo código.'),
            FlenxStep('Anote a rota',
                'Com @FlenxPage/@Ssr o build gera SSR, sitemap, robots e llms.txt.'),
            FlenxStep('Publique',
                'Conteúdo indexável por Google e por motores de IA, sem esforço.'),
          ],
        ),
        const FaqSection(),
        const FlenxCta(
          title: 'Pronto para subir o patamar da sua web?',
          subtitle: 'Comece com o Flenx hoje — open source e gratuito.',
          action: FlenxButton('Quero começar',
              href: '#contato', variant: FlenxButtonVariant.ghost),
        ),
        LeadSection(action: config.leadAction, submitted: submitted),
        const SiteFooter(),
        WhatsappButton(url: config.whatsappUrl),
      ],
    );
  }
}
