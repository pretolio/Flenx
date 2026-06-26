import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'flenx_ui_enums.dart';

/// Título — como um `Text` de destaque. [level] 1–3 vira `<h1>..<h3>` (bom para
/// SEO); o tamanho default segue o nível, mas pode ser sobrescrito com [size].
class FlenxHeading extends StatelessComponent {
  const FlenxHeading(
    this.data, {
    this.level = 2,
    this.size,
    this.color,
    this.align,
    this.weight = 800,
    super.key,
  });

  final String data;
  final int level;
  final double? size;
  final String? color;
  final FlenxTextAlign? align;
  final int weight;

  double get _size => size ?? const {1: 44.0, 2: 32.0, 3: 20.0}[level] ?? 32.0;

  @override
  Component build(BuildContext context) {
    return Component.element(
      tag: 'h${level.clamp(1, 6)}',
      styles: Styles(raw: {
        'margin': '0',
        'font-size': '${_size}px',
        'font-weight': '$weight',
        'line-height': '1.15',
        if (color != null) 'color': color!,
        if (align != null) 'text-align': align!.name,
      }),
      children: [.text(data)],
    );
  }
}
