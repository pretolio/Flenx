import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../../flenx_palette.dart';

/// Cartão de notícia (estilo G1): thumb 16:9, chapéu (editoria) e título.
class FlenxNewsCard extends StatelessComponent {
  const FlenxNewsCard({
    required this.title,
    required this.imageUrl,
    required this.href,
    this.hat,
    this.description,
    super.key,
  });

  final String title;
  final String imageUrl;
  final String href;
  final String? hat;
  final String? description;

  @override
  Component build(BuildContext context) {
    return a(href: href, classes: 'fnews-card', [
      div(
        classes: 'fnews-thumb',
        styles: Styles(raw: {'aspect-ratio': '16 / 9'}),
        [img(src: imageUrl, alt: title)],
      ),
      div(styles: Styles(raw: {'padding': '10px 0 0'}), [
        if (hat != null) span(classes: 'fnews-hat', [Component.text(hat!)]),
        div(
          classes: 'fnews-title',
          styles: Styles(raw: {'margin': '6px 0 0', 'font-size': '18px'}),
          [Component.text(title)],
        ),
        if (description != null)
          p(
            styles: Styles(raw: {
              'color': FlenxPalette.muted,
              'font-size': '14px',
              'line-height': '1.4',
              'margin': '6px 0 0',
            }),
            [Component.text(description!)],
          ),
      ]),
    ]);
  }
}
