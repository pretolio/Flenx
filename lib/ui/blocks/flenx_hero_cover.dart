import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../flenx_animated.dart';
import '../flenx_column.dart';
import '../flenx_heading.dart';
import '../flenx_row.dart';
import '../flenx_text.dart';
import '../flenx_ui_enums.dart';

/// Hero de tela cheia com **imagem de fundo** (com zoom Ken Burns), **logo**
/// opcional flutuando acima do título e conteúdo com animação de entrada.
/// Só Dart — o CSS/keyframes vão embutidos no próprio componente.
///
/// ```dart
/// FlenxHeroCover(
///   imageSrc: '/assets/hero.webp',
///   logoSrc: '/assets/logo-white.png',
///   title: 'Frete e Entregas com qualidade',
///   subtitle: 'Serviços flexíveis para todo o Brasil.',
///   actions: [FlenxButton('Solicitar', href: '/pedido')],
/// )
/// ```
class FlenxHeroCover extends StatelessComponent {
  const FlenxHeroCover({
    required this.imageSrc,
    required this.title,
    this.subtitle,
    this.actions = const [],
    this.logoSrc,
    this.logoAlt = '',
    this.logoHeight = 120,
    this.overlay = 'linear-gradient(rgba(0,0,0,0.55), rgba(0,0,0,0.65))',
    this.background = '#111827',
    this.paddingY = 96,
    this.titleColor = '#ffffff',
    this.subtitleColor = '#E5E7EB',
    this.titleSize = 48,
    this.kenBurns = true,
    this.id,
    super.key,
  });

  /// Imagem de fundo (ex.: `/assets/hero.webp`).
  final String imageSrc;
  final String title;
  final String? subtitle;

  /// Botões/ações (ex.: `[FlenxButton(...)]`).
  final List<Component> actions;

  /// Logo exibido acima do título (flutua suavemente). Null = sem logo.
  final String? logoSrc;
  final String logoAlt;
  final double logoHeight;

  /// Overlay (cor/gradiente) sobre a imagem, para legibilidade do texto.
  final String overlay;
  final String background;
  final double paddingY;
  final String titleColor;
  final String subtitleColor;
  final double titleSize;

  /// Anima o fundo com um leve zoom contínuo (Ken Burns).
  final bool kenBurns;
  final String? id;

  static String _px(double v) =>
      v == v.roundToDouble() ? '${v.toInt()}px' : '${v}px';

  String get _css =>
      '.flenx-hero-cover{position:relative;overflow:hidden;padding:${_px(paddingY)} 24px;background:$background}'
      '.flenx-hero-cover__bg{position:absolute;inset:0;z-index:0;background-size:cover;background-position:center'
      '${kenBurns ? ';animation:flenxKenBurns 22s ease-in-out infinite alternate' : ''}}'
      '.flenx-hero-cover__inner{position:relative;z-index:1;max-width:1120px;margin:0 auto}'
      '.flenx-hero-cover__logo{height:${_px(logoHeight)};max-width:90%;width:auto'
      '${logoSrc != null ? ';animation:flenxFloat 5s ease-in-out infinite' : ''}}'
      '@keyframes flenxKenBurns{from{transform:scale(1)}to{transform:scale(1.12)}}'
      '@keyframes flenxFloat{0%,100%{transform:translateY(0)}50%{transform:translateY(-12px)}}';

  @override
  Component build(BuildContext context) {
    return section(id: id, classes: 'flenx-hero-cover', [
      Component.element(tag: 'style', children: [RawText(_css)]),
      div(
        const [],
        classes: 'flenx-hero-cover__bg',
        styles: Styles(raw: {'background-image': '$overlay, url($imageSrc)'}),
      ),
      div(classes: 'flenx-hero-cover__inner', [
        FlenxColumn(gap: 20, cross: FlenxAlign.start, [
          if (logoSrc != null)
            img(src: logoSrc!, alt: logoAlt, classes: 'flenx-hero-cover__logo'),
          FlenxHeading(
            title,
            level: 1,
            color: titleColor,
            size: titleSize,
            animation: FlenxAnimation.slideUp,
          ),
          if (subtitle != null)
            FlenxAnimated(
              FlenxText(subtitle!, size: 18, color: subtitleColor),
              animation: FlenxAnimation.fadeIn,
              delay: 150,
            ),
          if (actions.isNotEmpty)
            FlenxAnimated(
              FlenxRow(gap: 12, wrap: true, actions),
              animation: FlenxAnimation.fadeIn,
              delay: 300,
            ),
        ]),
      ]),
    ]);
  }
}
