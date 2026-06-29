import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Hero em duas colunas: texto à esquerda, imagem à direita.
/// No mobile a imagem se converte em fundo desfocado atrás do texto.
///
/// ```dart
/// FlenxHeroSplit(
///   imageSrc: '/assets/hero.jpg',
///   background: '#1A1A1A',
///   paddingY: 96,
///   child: FlenxColumn(
///     gap: 24,
///     [
///       FlenxHeading('Título', level: 1, color: '#fff'),
///       FlenxText('Subtítulo', color: '#ccc'),
///       FlenxRow(gap: 12, [
///         FlenxButton('CTA', href: '/'),
///         FlenxButton('Secundário', href: '#', variant: FlenxButtonVariant.ghost),
///       ]),
///     ],
///   ),
/// )
/// ```
class FlenxHeroSplit extends StatelessComponent {
  const FlenxHeroSplit({
    required this.child,
    required this.imageSrc,
    this.imageAlt = '',
    this.imageRadius = 20.0,
    this.background,
    this.paddingY = 80.0,
    this.maxWidthPx = 1120.0,
    this.mobileBlurPx = 14.0,
    this.mobileImageOpacity = 0.20,
    this.id,
    super.key,
  });

  /// Conteúdo da coluna de texto (esquerda no desktop).
  final Component child;

  /// URL da imagem de destaque (direita no desktop / fundo no mobile).
  final String imageSrc;
  final String imageAlt;

  /// Arredondamento dos cantos da imagem (desktop).
  final double imageRadius;

  /// Cor/gradiente de fundo da seção.
  final String? background;
  final double paddingY;
  final double maxWidthPx;

  /// Intensidade do desfoque da imagem de fundo no mobile (px).
  final double mobileBlurPx;

  /// Opacidade da imagem de fundo no mobile (0.0 – 1.0).
  final double mobileImageOpacity;

  final String? id;

  String get _uid => 'fhs${imageSrc.hashCode.abs().toRadixString(16)}';

  String get _css => '''
.fhs-$_uid{display:flex;align-items:center;gap:56px}
.fhs-text-$_uid{flex:1;min-width:0}
.fhs-iw-$_uid{flex:0 0 44%;max-width:480px}
.fhs-img-$_uid{width:100%;display:block;object-fit:cover;border-radius:${imageRadius}px;box-shadow:0 20px 60px rgba(0,0,0,.35)}
.fhs-bg-$_uid{display:none;position:absolute;inset:-40px;background-image:url('${imageSrc.replaceAll("'", "\\'")}');background-size:cover;background-position:center;filter:blur(${mobileBlurPx}px);opacity:$mobileImageOpacity;pointer-events:none}
@media(max-width:768px){
  .fhs-$_uid{flex-direction:column;gap:0}
  .fhs-iw-$_uid{display:none}
  .fhs-bg-$_uid{display:block}
  .fhs-text-$_uid{position:relative;z-index:1;width:100%}
}
''';

  @override
  Component build(BuildContext context) {
    return span(styles: Styles(raw: {'display': 'contents'}), [
      Component.element(tag: 'style', children: [RawText(_css)]),
      Component.element(
        tag: 'section',
        id: id,
        styles: Styles(raw: {
          'position': 'relative',
          'overflow': 'hidden',
          'padding': '${paddingY}px 24px',
          if (background != null) 'background': background!,
        }),
        children: [
          // Fundo desfocado (visível apenas no mobile)
          div(classes: 'fhs-bg-$_uid', []),
          // Container central com max-width
          div(
            styles: Styles(raw: {
              'max-width': '${maxWidthPx}px',
              'margin': '0 auto',
              'position': 'relative',
              'z-index': '1',
            }),
            [
              div(classes: 'fhs-$_uid', [
                // Coluna de texto
                div(classes: 'fhs-text-$_uid', [child]),
                // Coluna de imagem
                div(classes: 'fhs-iw-$_uid', [
                  img(
                    src: imageSrc,
                    alt: imageAlt,
                    classes: 'fhs-img-$_uid',
                    attributes: {'loading': 'lazy'},
                  ),
                ]),
              ]),
            ],
          ),
        ],
      ),
    ]);
  }
}
