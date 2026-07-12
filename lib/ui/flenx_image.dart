import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Imagem — como o `Image` do Flutter. [src] é a URL/caminho. Estilo por
/// parâmetros; nada de CSS.
class FlenxImage extends StatelessComponent {
  const FlenxImage(
    this.src, {
    this.alt = '',
    this.widthPx,
    this.heightPx,
    this.radius = 0,
    this.srcset,
    this.sizes,
    this.loading,
    super.key,
  });

  final String src;
  final String alt;
  final double? widthPx;
  final double? heightPx;
  final double radius;

  /// `srcset` para imagens responsivas (por densidade `1x/2x` ou largura `w`).
  final String? srcset;

  /// `sizes` — usado com `srcset` de largura (`w`) para o browser escolher.
  final String? sizes;

  /// `loading` nativo (`'lazy'` para imagens fora da dobra).
  final String? loading;

  @override
  Component build(BuildContext context) {
    return img(
      src: src,
      alt: alt,
      attributes: {
        if (srcset != null) 'srcset': srcset!,
        if (sizes != null) 'sizes': sizes!,
        if (loading != null) 'loading': loading!,
      },
      styles: Styles(
        raw: {
          'max-width': '100%',
          'display': 'block',
          if (widthPx != null) 'width': '${widthPx}px',
          if (heightPx != null) 'height': '${heightPx}px',
          if (radius > 0) 'border-radius': '${radius}px',
        },
      ),
    );
  }
}
