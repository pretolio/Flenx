import 'package:flenx/flenx.dart';

/// Seção que mostra as novidades da 0.2.0 — grade animada (scroll-reveal) de
/// cards + alertas. Tudo só com componentes Dart do kit.
class NovidadesSection extends StatelessComponent {
  const NovidadesSection({super.key});

  static const _itens = [
    ('🎬', 'Animações', 'Scroll-reveal (fadeIn, slideUp, zoomIn…) em qualquer componente.'),
    ('🎨', 'Temas', 'Defina a cor da marca no FlenxPage e todo o site acompanha.'),
    ('📻', 'Áudio & rádio', 'FlenxAudioPlayer toca faixas ou streams ao vivo, sem libs.'),
    ('✨', 'Lottie & Rive', 'Animações vetoriais via CDN, declaradas em Dart.'),
    ('🖼️', 'SVG', 'FlenxSvg externo ou inline, estilizável por CSS.'),
    ('🧱', 'Hero split', 'Hero em duas colunas; no mobile a imagem vira fundo.'),
    ('🔔', 'Banner & alertas', 'Avisos no topo e caixas de alerta (info/sucesso/erro).'),
    ('📍', 'SEO local', 'LocalBusiness com endereço, telefone e geo no JSON-LD.'),
  ];

  @override
  Component build(BuildContext context) {
    return FlenxSection(
      background: '#f6f9fc',
      id: 'novidades',
      animation: FlenxAnimation.fadeIn,
      child: FlenxColumn(gap: 22, cross: FlenxAlign.stretch, [
        const FlenxText('Novidades · 0.2.0',
            color: FlenxPalette.primary,
            weight: 700,
            align: FlenxTextAlign.center),
        const FlenxHeading('Mais poder — e sempre só em Dart',
            align: FlenxTextAlign.center),
        FlenxGrid(
          minItemWidth: 250,
          animation: FlenxAnimation.slideUp,
          [
            for (final i in _itens)
              FlenxCard(FlenxColumn(gap: 8, [
                FlenxText(i.$1, size: 40),
                FlenxHeading(i.$2, level: 3),
                FlenxText(i.$3, color: FlenxPalette.muted),
              ])),
          ],
        ),
        const FlenxSpacer(6),
        const FlenxAlert(
          'Todos os componentes acima funcionam no SSR e como ilhas Flutter — sem escrever HTML ou CSS.',
          title: 'Tudo em Dart',
          variant: FlenxAlertVariant.success,
        ),
      ]),
    );
  }
}
