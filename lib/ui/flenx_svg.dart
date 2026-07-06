import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Componente SVG — arquivo externo (via `<img>`) ou inline (string SVG direto
/// no DOM, permitindo estilização via CSS).
///
/// **Externo** (`<img>`):
/// ```dart
/// FlenxSvg('/assets/logo.svg', width: 120, height: 40)
/// ```
///
/// **Inline** (CSS styling dos elementos internos):
/// ```dart
/// FlenxSvg.inline('<svg viewBox="0 0 24 24">...</svg>', size: 32)
/// ```
class FlenxSvg extends StatelessComponent {
  const FlenxSvg(
    this.src, {
    this.width,
    this.height,
    this.size,
    this.alt = '',
    this.fit = 'contain',
    super.key,
  }) : _inline = false,
       _svgContent = null;

  const FlenxSvg.inline(
    String svgContent, {
    this.width,
    this.height,
    this.size,
    this.alt = '',
    this.fit = 'contain',
    super.key,
  }) : _inline = true,
       _svgContent = svgContent,
       src = '';

  final String src;

  /// Largura em px. Se [size] for informado, usa como largura e altura.
  final double? width;

  /// Altura em px.
  final double? height;

  /// Atalho: define largura e altura iguais (quadrado).
  final double? size;

  final String alt;

  /// Como a imagem ocupa o espaço — `'contain'`, `'cover'` ou `'fill'`.
  final String fit;

  final bool _inline;
  final String? _svgContent;

  double? get _w => size ?? width;
  double? get _h => size ?? height;

  @override
  Component build(BuildContext context) {
    final svgContent = _svgContent;
    if (_inline && svgContent != null) {
      return span(
        styles: Styles(
          raw: {
            'display': 'inline-flex',
            'align-items': 'center',
            'justify-content': 'center',
            if (_w != null) 'width': '${_w}px',
            if (_h != null) 'height': '${_h}px',
          },
        ),
        [RawText(svgContent)],
      );
    }

    return img(
      src: src,
      alt: alt,
      styles: Styles(
        raw: {
          'display': 'block',
          'object-fit': fit,
          if (_w != null) 'width': '${_w}px',
          if (_h != null) 'height': '${_h}px',
          if (_w == null && _h == null) 'max-width': '100%',
        },
      ),
    );
  }
}
