import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Imagem — como o `Image` do Flutter. [src] é a URL/caminho. Estilo por
/// parâmetros; nada de CSS.
class FlextImage extends StatelessComponent {
  const FlextImage(
    this.src, {
    this.alt = '',
    this.widthPx,
    this.heightPx,
    this.radius = 0,
    super.key,
  });

  final String src;
  final String alt;
  final double? widthPx;
  final double? heightPx;
  final double radius;

  @override
  Component build(BuildContext context) {
    return img(
      src: src,
      alt: alt,
      styles: Styles(raw: {
        'max-width': '100%',
        'display': 'block',
        if (widthPx != null) 'width': '${widthPx}px',
        if (heightPx != null) 'height': '${heightPx}px',
        if (radius > 0) 'border-radius': '${radius}px',
      }),
    );
  }
}
