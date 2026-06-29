import 'package:flenx/flenx.dart';

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
      child: FlenxColumn(cross: FlenxAlign.stretch, [
        FlenxSection(
          child: FlenxColumn(gap: 14, maxWidthPx: 760, [
            const FlenxText('Sobre o projeto',
                color: FlenxPalette.primary, weight: 700),
            const FlenxHeading('Flutter para a web, do jeito certo', level: 1),
            const FlenxText(
                'O Flenx é um framework web em Dart, no espírito do Next.js: '
                'renderiza HTML no servidor (SSR) para SEO real, mas mantém os '
                'widgets Flutter do seu app como ilhas interativas.',
                color: FlenxPalette.muted,
                lineHeight: 1.6),
            const FlenxText(
                'A ideia é simples: escreva uma vez, rode no app e na web — '
                'com sitemap, robots e llms.txt automáticos, sem configuração.',
                color: FlenxPalette.muted,
                lineHeight: 1.6),
          ]),
        ),
        FlenxSection(
          background: FlenxPalette.surface,
          child: FlenxColumn(gap: 28, cross: FlenxAlign.stretch, [
            const FlenxText('Por que existe',
                align: FlenxTextAlign.center,
                color: FlenxPalette.primary,
                weight: 700),
            const FlenxHeading('A web merece a DX do Flutter',
                align: FlenxTextAlign.center),
            FlenxGrid(
              minItemWidth: 280,
              [
                for (final c in _cards)
                  FlenxCard(FlenxColumn(gap: 8, [
                    FlenxText(c.$1, size: 30),
                    FlenxHeading(c.$2, level: 3),
                    FlenxText(c.$3, color: FlenxPalette.muted),
                  ])),
              ],
            ),
          ]),
        ),
        FlenxSection(
          child: FlenxColumn(gap: 12, cross: FlenxAlign.center, [
            const FlenxText('Demonstração',
                align: FlenxTextAlign.center,
                color: FlenxPalette.primary,
                weight: 700),
            const FlenxHeading('Embute qualquer site ou vídeo',
                align: FlenxTextAlign.center),
            const FlenxText(
                'É só passar a URL — o Flenx carrega num iframe responsivo.',
                align: FlenxTextAlign.center,
                color: FlenxPalette.muted),
            const FlenxColumn(maxWidthPx: 760, cross: FlenxAlign.stretch, [
              IframeEmbed('https://www.youtube.com/embed/dQw4w9WgXcQ',
                  title: 'Vídeo de exemplo', ratio: '16 / 9'),
            ]),
          ]),
        ),
        FlenxCta(
          title: 'Quer fazer parte?',
          subtitle: 'O Flenx é open source (MIT). Fale com a gente e participe.',
          action: const FlenxButton('Fale com a gente',
              href: '/#contato', variant: FlenxButtonVariant.ghost),
        ),
      ]),
    );
  }
}
