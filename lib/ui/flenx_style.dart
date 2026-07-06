import 'package:jaspr/dom.dart' show Selector, StyleRule, Styles;

String _px(double v) => v == v.roundToDouble() ? '${v.toInt()}px' : '${v}px';

/// Espaçamento (padding/margin) no estilo `EdgeInsets` do Flutter, mas
/// puro-Dart — não depende de `dart:ui` (que não roda na geração estática).
class FlenxInsets {
  const FlenxInsets.all(double value)
    : top = value,
      right = value,
      bottom = value,
      left = value;

  const FlenxInsets.symmetric({double horizontal = 0, double vertical = 0})
    : top = vertical,
      bottom = vertical,
      left = horizontal,
      right = horizontal;

  const FlenxInsets.only({
    this.top = 0,
    this.right = 0,
    this.bottom = 0,
    this.left = 0,
  });

  final double top;
  final double right;
  final double bottom;
  final double left;

  String get css => '${_px(top)} ${_px(right)} ${_px(bottom)} ${_px(left)}';
}

/// Estilo global no padrão Flutter (nomes de propriedades tipados), convertido
/// em CSS pela flenx. Puro-Dart (seguro na geração estática — sem `dart:ui`).
///
/// Usado em `FlenxApp.run(globalStyles: [...])`:
/// ```dart
/// FlenxStyle('.brand-img', height: 48)
/// FlenxStyle('h1', color: '#fff', fontSize: 48, fontWeight: 700, textAlign: 'center')
/// FlenxStyle('.card', background: '#111827', padding: FlenxInsets.all(16), borderRadius: 12)
/// ```
class FlenxStyle {
  const FlenxStyle(
    this.selector, {
    this.color,
    this.background,
    this.width,
    this.height,
    this.minWidth,
    this.maxWidth,
    this.minHeight,
    this.maxHeight,
    this.padding,
    this.margin,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.borderRadius,
    this.opacity,
    this.gap,
    this.raw,
  });

  /// Seletor CSS (ex.: `.brand-img`, `h1`, `.card a`).
  final String selector;

  /// Cor do texto — qualquer cor CSS (`'#fff'`, `'rgb(0,0,0)'`, `'white'`).
  final String? color;

  /// Cor/gradiente de fundo (CSS).
  final String? background;
  final double? width;
  final double? height;
  final double? minWidth;
  final double? maxWidth;
  final double? minHeight;
  final double? maxHeight;
  final FlenxInsets? padding;
  final FlenxInsets? margin;
  final double? fontSize;

  /// Peso da fonte 100–900 (ex.: 400 normal, 700 bold).
  final int? fontWeight;

  /// `'left'` | `'center'` | `'right'` | `'justify'`.
  final String? textAlign;
  final double? borderRadius;
  final double? opacity;

  /// Espaço entre filhos (flex/grid `gap`), em px.
  final double? gap;

  /// Escape para propriedades CSS não cobertas (ex.: `{'letter-spacing': '.02em'}`).
  final Map<String, String>? raw;

  StyleRule toRule() => StyleRule(
    selector: Selector(selector),
    styles: Styles(raw: toCss()),
  );

  Map<String, String> toCss() => {
    if (color != null) 'color': color!,
    if (background != null) 'background': background!,
    if (width != null) 'width': _px(width!),
    if (height != null) 'height': _px(height!),
    if (minWidth != null) 'min-width': _px(minWidth!),
    if (maxWidth != null) 'max-width': _px(maxWidth!),
    if (minHeight != null) 'min-height': _px(minHeight!),
    if (maxHeight != null) 'max-height': _px(maxHeight!),
    if (padding != null) 'padding': padding!.css,
    if (margin != null) 'margin': margin!.css,
    if (fontSize != null) 'font-size': _px(fontSize!),
    if (fontWeight != null) 'font-weight': '$fontWeight',
    if (textAlign != null) 'text-align': textAlign!,
    if (borderRadius != null) 'border-radius': _px(borderRadius!),
    if (opacity != null) 'opacity': '$opacity',
    if (gap != null) 'gap': _px(gap!),
    ...?raw,
  };
}
