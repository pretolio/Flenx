import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../flenx_palette.dart';

/// Seção "spotlight": um texto (eyebrow + título + descrição + bullets) ao lado
/// de uma imagem/screenshot com moldura. Alterna o lado com [imageLeft].
/// Responsivo: em telas estreitas vira uma coluna (imagem embaixo).
class FlenxFeatureSpotlight extends StatelessComponent {
  const FlenxFeatureSpotlight({
    required this.title,
    required this.imageSrc,
    this.eyebrow,
    this.description,
    this.bullets = const [],
    this.imageAlt = '',
    this.imageLeft = false,
    this.background,
    this.accent = FlenxPalette.primary,
    this.titleColor = FlenxPalette.ink,
    this.textColor = FlenxPalette.muted,
    this.paddingY = 64,
    this.id,
    super.key,
  });

  final String title;
  final String imageSrc;
  final String? eyebrow;
  final String? description;
  final List<String> bullets;
  final String imageAlt;
  final bool imageLeft;
  final String? background;
  final String accent;
  final String titleColor;
  final String textColor;
  final int paddingY;
  final String? id;

  static const _css = '''
.fxspot{max-width:1120px;margin:0 auto;padding:0 24px;display:grid;
grid-template-columns:1fr 1fr;gap:48px;align-items:center}
.fxspot--right .fxspot__media{order:2}
@media(max-width:860px){.fxspot{grid-template-columns:1fr;gap:28px}
.fxspot--right .fxspot__media{order:0}}
.fxspot__eyebrow{font-size:.72rem;font-weight:800;letter-spacing:.2em;text-transform:uppercase;margin:0 0 10px}
.fxspot__title{font-size:clamp(24px,3.2vw,34px);font-weight:800;letter-spacing:-.02em;line-height:1.1;margin:0}
.fxspot__desc{font-size:1.05rem;line-height:1.6;margin:14px 0 0}
.fxspot__list{list-style:none;padding:0;margin:18px 0 0;display:flex;flex-direction:column;gap:10px}
.fxspot__list li{display:flex;gap:10px;align-items:flex-start;font-size:.98rem;line-height:1.45}
.fxspot__ck{flex:none;width:22px;height:22px;border-radius:6px;display:flex;align-items:center;
justify-content:center;color:#fff;font-size:13px;font-weight:900;margin-top:1px}
.fxspot__media{margin:0}
.fxspot__media img{width:100%;height:auto;display:block;border-radius:14px;
border:1px solid rgba(15,30,56,.1);box-shadow:0 30px 70px -30px rgba(7,28,67,.55)}
''';

  @override
  Component build(BuildContext context) {
    final section = div(
      classes: imageLeft ? 'fxspot fxspot--right' : 'fxspot',
      [
        // Texto
        div([
          if (eyebrow != null)
            p(classes: 'fxspot__eyebrow', styles: Styles(raw: {'color': accent}), [Component.text(eyebrow!)]),
          h2(classes: 'fxspot__title', styles: Styles(raw: {'color': titleColor}), [Component.text(title)]),
          if (description != null)
            p(classes: 'fxspot__desc', styles: Styles(raw: {'color': textColor}), [Component.text(description!)]),
          if (bullets.isNotEmpty)
            ul(classes: 'fxspot__list', [
              for (final b in bullets)
                li([
                  span(classes: 'fxspot__ck', styles: Styles(raw: {'background': accent}), [Component.text('✓')]),
                  span(styles: Styles(raw: {'color': titleColor}), [Component.text(b)]),
                ]),
            ]),
        ]),
        // Imagem
        div(classes: 'fxspot__media', [
          img(src: imageSrc, alt: imageAlt.isEmpty ? title : imageAlt),
        ]),
      ],
    );

    return Component.element(
      tag: 'section',
      id: id,
      styles: Styles(raw: {
        'padding': '${paddingY}px 0',
        if (background != null) 'background': background!,
      }),
      children: [
        Component.element(tag: 'style', children: const [RawText(_css)]),
        section,
      ],
    );
  }
}
