import 'package:flenx/flenx.dart';

/// FAQ em acordeão (CSS puro, sem JS) — demonstra o FlenxAccordion da 0.2.0.
class FaqSection extends StatelessComponent {
  const FaqSection({super.key});

  @override
  Component build(BuildContext context) {
    return FlenxSection(
      id: 'faq',
      child: FlenxColumn(gap: 16, cross: FlenxAlign.stretch, maxWidthPx: 760, [
        const FlenxText('FAQ', color: FlenxPalette.primary, weight: 700, align: FlenxTextAlign.center),
        const FlenxHeading('Perguntas frequentes', align: FlenxTextAlign.center, animation: FlenxAnimation.fadeIn),
        const FlenxAccordion(
          items: [
            FlenxAccordionItem(
              'Preciso saber HTML ou CSS?',
              'Não. Você compõe tudo com componentes Dart (FlenxHero, FlenxCard, FlenxGrid…) e o Flenx gera o HTML/CSS por baixo.',
              open: true,
            ),
            FlenxAccordionItem(
              'Roda em qualquer hospedagem?',
              'Sim. Gera PHP/MySQL para hospedagem compartilhada (Hostinger, cPanel) ou roda como servidor Dart (Render, Fly.io, Cloud Run, VPS).',
            ),
            FlenxAccordionItem(
              'Funciona com Flutter?',
              'Sim — widgets Flutter reais entram como ilhas interativas dentro das páginas renderizadas no servidor.',
            ),
            FlenxAccordionItem(
              'E o SEO?',
              'Meta tags, Open Graph, JSON-LD, sitemap.xml, robots.txt e llms.txt são gerados automaticamente a partir das rotas.',
            ),
          ],
        ),
      ]),
    );
  }
}
