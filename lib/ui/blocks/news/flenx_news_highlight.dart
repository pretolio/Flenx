import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../../flenx_palette.dart';

/// Manchete principal (estilo G1): imagem larga 16:9, chapéu da editoria,
/// título grande responsivo, linha-fina e meta (autor · data).
class FlenxNewsHighlight extends StatelessComponent {
  const FlenxNewsHighlight({
    required this.title,
    required this.imageUrl,
    required this.href,
    this.hat,
    this.subtitle,
    this.meta,
    super.key,
  });

  final String title;
  final String imageUrl;
  final String href;

  /// Chapéu acima do título (editoria). Opcional.
  final String? hat;

  /// Linha-fina abaixo do título. Opcional.
  final String? subtitle;

  /// Linha de meta (ex.: `Por Fulano · 21/06/2026`). Opcional.
  final String? meta;

  @override
  Component build(BuildContext context) {
    return a(href: href, classes: 'fnews-lead', [
      div(
        classes: 'fnews-thumb',
        styles: Styles(raw: {'aspect-ratio': '16 / 9'}),
        [img(src: imageUrl, alt: title)],
      ),
      div(styles: Styles(raw: {'padding': '14px 0 0'}), [
        if (hat != null) span(classes: 'fnews-hat', [Component.text(hat!)]),
        div(
          classes: 'fnews-title',
          styles: Styles(raw: {'margin': '6px 0 8px'}),
          [Component.text(title)],
        ),
        if (subtitle != null)
          p(
            styles: Styles(raw: {
              'color': FlenxPalette.ink,
              'font-size': '17px',
              'line-height': '1.45',
              'margin': '0 0 8px',
            }),
            [Component.text(subtitle!)],
          ),
        if (meta != null)
          span(
            styles: Styles(raw: {
              'color': FlenxPalette.muted,
              'font-size': '13px',
            }),
            [Component.text(meta!)],
          ),
      ]),
    ]);
  }
}
