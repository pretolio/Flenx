import 'package:flutter/widgets.dart';
import 'package:jaspr/dom.dart' show Selector, StyleRule, Styles;

/// Estilo global no **padrão Flutter**: um seletor + propriedades tipadas
/// (Color, EdgeInsets, FontWeight…). A flenx converte em CSS por baixo.
///
/// Usado em `FlenxApp.run(globalStyles: [...])`:
/// ```dart
/// FlenxStyle('.brand-img', height: 48)
/// FlenxStyle('h1', color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold)
/// FlenxStyle('.card', background: Color(0xFF111827), padding: EdgeInsets.all(16), borderRadius: 12)
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
  final Color? color;
  final Color? background;
  final double? width;
  final double? height;
  final double? minWidth;
  final double? maxWidth;
  final double? minHeight;
  final double? maxHeight;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final double? borderRadius;
  final double? opacity;

  /// Espaço entre filhos (flex/grid `gap`), em px.
  final double? gap;

  /// Escape para propriedades CSS não cobertas (ex.: `{'letter-spacing': '.02em'}`).
  final Map<String, String>? raw;

  StyleRule toRule() {
    return StyleRule(
      selector: Selector(selector),
      styles: Styles(raw: toCss()),
    );
  }

  Map<String, String> toCss() => {
    if (color != null) 'color': _color(color!),
    if (background != null) 'background': _color(background!),
    if (width != null) 'width': _px(width!),
    if (height != null) 'height': _px(height!),
    if (minWidth != null) 'min-width': _px(minWidth!),
    if (maxWidth != null) 'max-width': _px(maxWidth!),
    if (minHeight != null) 'min-height': _px(minHeight!),
    if (maxHeight != null) 'max-height': _px(maxHeight!),
    if (padding != null) 'padding': _edge(padding!),
    if (margin != null) 'margin': _edge(margin!),
    if (fontSize != null) 'font-size': _px(fontSize!),
    if (fontWeight != null) 'font-weight': '${fontWeight!.value}',
    if (textAlign != null) 'text-align': _align(textAlign!),
    if (borderRadius != null) 'border-radius': _px(borderRadius!),
    if (opacity != null) 'opacity': '$opacity',
    if (gap != null) 'gap': _px(gap!),
    ...?raw,
  };

  static String _px(double v) =>
      v == v.roundToDouble() ? '${v.toInt()}px' : '${v}px';

  static String _color(Color c) {
    final r = (c.r * 255).round();
    final g = (c.g * 255).round();
    final b = (c.b * 255).round();
    return c.a >= 1
        ? 'rgb($r, $g, $b)'
        : 'rgba($r, $g, $b, ${c.a.toStringAsFixed(3)})';
  }

  static String _edge(EdgeInsets e) =>
      '${_px(e.top)} ${_px(e.right)} ${_px(e.bottom)} ${_px(e.left)}';

  static String _align(TextAlign a) => switch (a) {
    TextAlign.center => 'center',
    TextAlign.right || TextAlign.end => 'right',
    TextAlign.justify => 'justify',
    _ => 'left',
  };
}
