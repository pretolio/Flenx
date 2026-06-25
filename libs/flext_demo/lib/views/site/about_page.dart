import 'package:flext/flext.dart';
import 'package:jaspr/jaspr.dart';

import 'sections/site_footer.dart';
import 'site_nav.dart';

/// Página "Sobre" — conteúdo institucional, montado só com o kit Dart.
class AboutPage extends StatelessComponent {
  const AboutPage({super.key});

  static const _cards = [
    ('🎯', 'A missão', 'Levar a web ao patamar de PHP, Next e Astro — só que em Dart, reaproveitando os widgets do seu app.'),
    ('⚙️', 'Como funciona', 'SSR com jaspr, ilhas de widgets Flutter reais e SEO/GEO/AEO gerados a partir das rotas.'),
    ('👥', 'Para quem', 'De iniciantes que querem um site rápido a times que já têm um app Flutter e querem web de verdade.'),
  ];

  @override
  Component build(BuildContext context) {
    return SiteLayout(
      brand: siteBrand,
      links: siteNavLinks,
      loginOptions: siteLoginOptions,
      footer: const SiteFooter(),
      child: FlextColumn(cross: FlextAlign.stretch, [
        FlextSection(
          child: FlextColumn(gap: 14, maxWidthPx: 760, [
            const FlextText('Sobre o projeto',
                color: FlextPalette.primary, weight: 700),
            const FlextHeading('Flutter para a web, do jeito certo', level: 1),
            const FlextText(
                'O Flext é um framework web em Dart, no espírito do Next.js: '
                'renderiza HTML no servidor (SSR) para SEO real, mas mantém os '
                'widgets Flutter do seu app como ilhas interativas.',
                color: FlextPalette.muted,
                lineHeight: 1.6),
            const FlextText(
                'A ideia é simples: escreva uma vez, rode no app e na web — '
                'com sitemap, robots e llms.txt automáticos, sem configuração.',
                color: FlextPalette.muted,
                lineHeight: 1.6),
          ]),
        ),
        FlextSection(
          background: FlextPalette.surface,
          child: FlextColumn(gap: 28, cross: FlextAlign.stretch, [
            const FlextText('Por que existe',
                align: FlextTextAlign.center,
                color: FlextPalette.primary,
                weight: 700),
            const FlextHeading('A web merece a DX do Flutter',
                align: FlextTextAlign.center),
            FlextGrid(
              minItemWidth: 280,
              [
                for (final c in _cards)
                  FlextCard(FlextColumn(gap: 8, [
                    FlextText(c.$1, size: 30),
                    FlextHeading(c.$2, level: 3),
                    FlextText(c.$3, color: FlextPalette.muted),
                  ])),
              ],
            ),
          ]),
        ),
        FlextSection(
          child: FlextColumn(gap: 12, cross: FlextAlign.center, [
            const FlextText('Demonstração',
                align: FlextTextAlign.center,
                color: FlextPalette.primary,
                weight: 700),
            const FlextHeading('Embute qualquer site ou vídeo',
                align: FlextTextAlign.center),
            const FlextText(
                'É só passar a URL — o Flext carrega num iframe responsivo.',
                align: FlextTextAlign.center,
                color: FlextPalette.muted),
            const FlextColumn(maxWidthPx: 760, cross: FlextAlign.stretch, [
              IframeEmbed('https://www.youtube.com/embed/dQw4w9WgXcQ',
                  title: 'Vídeo de exemplo', ratio: '16 / 9'),
            ]),
          ]),
        ),
        FlextCta(
          title: 'Quer fazer parte?',
          subtitle: 'O Flext é open source (MIT). Fale com a gente e participe.',
          action: const FlextButton('Fale com a gente',
              href: '/#contato', variant: FlextButtonVariant.ghost),
        ),
      ]),
    );
  }
}
