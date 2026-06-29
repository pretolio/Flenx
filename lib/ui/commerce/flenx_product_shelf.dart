import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Prateleira de produtos: cabeçalho colorido (com contador opcional) +
/// carrossel horizontal de cards. Passe os cards prontos em [products].
class FlenxProductShelf extends StatelessComponent {
  const FlenxProductShelf({
    required this.title,
    required this.products,
    this.subtitle,
    this.countdown,
    super.key,
  });

  final String title;
  final List<Component> products;
  final String? subtitle;

  /// Contador no formato `HH:MM:SS` (estático). Nulo = sem contador.
  final String? countdown;

  @override
  Component build(BuildContext context) {
    return div(classes: 'fxz-wrap', [
      div(classes: 'fxz-shelf', [
        div(classes: 'fxz-shelf-head', [
          span(classes: 't', [Component.text(title)]),
          if (countdown != null)
            div(classes: 'fxz-clock', [
              for (final part in _parts(countdown!)) ...[
                if (part == ':') Component.text(':') else b([Component.text(part)]),
              ],
            ]),
          if (subtitle != null) span(classes: 'sub', [Component.text(subtitle!)]),
        ]),
        div(classes: 'fxz-carousel', products),
      ]),
    ]);
  }

  static List<String> _parts(String c) {
    final out = <String>[];
    final segs = c.split(':');
    for (var i = 0; i < segs.length; i++) {
      out.add(segs[i]);
      if (i < segs.length - 1) out.add(':');
    }
    return out;
  }
}

/// Grade de produtos (catálogo) usando os mesmos cards.
class FlenxProductGrid extends StatelessComponent {
  const FlenxProductGrid({required this.products, this.title, super.key});

  final List<Component> products;
  final String? title;

  @override
  Component build(BuildContext context) {
    return div(classes: 'fxz-wrap', [
      if (title != null) div(classes: 'fxz-sec-title', [Component.text(title!)]),
      div(classes: 'fxz-grid', products),
    ]);
  }
}
