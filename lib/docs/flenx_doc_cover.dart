import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Capa de documento: imagem de fundo (cover) + gradiente + conteúdo alinhado
/// na base. Na tela ocupa quase a altura toda; na impressão ocupa uma página A4
/// inteira e força a quebra de página em seguida (o resto começa na página 2).
class FlenxDocCover extends StatelessComponent {
  const FlenxDocCover({
    required this.imageSrc,
    required this.child,
    this.overlay = 'linear-gradient(to top, rgba(5,11,28,.94), rgba(5,11,28,.45) 55%, rgba(5,11,28,.12))',
    this.minHeightVh = 90,
    super.key,
  });

  final String imageSrc;
  final Component child;
  final String overlay;
  final int minHeightVh;

  static const _css = '''
.fxcover{position:relative;overflow:hidden;display:flex;flex-direction:column;justify-content:flex-end;padding:52px 24px}
.fxcover__bg{position:absolute;inset:0;background-position:center;background-size:cover}
.fxcover__ov{position:absolute;inset:0}
.fxcover__inner{position:relative;z-index:1;max-width:1120px;margin:0 auto;width:100%;box-sizing:border-box}
@media print{
.fxcover{height:246mm;min-height:0 !important;break-after:page;page-break-after:always;
-webkit-print-color-adjust:exact !important;print-color-adjust:exact !important}
}
''';

  @override
  Component build(BuildContext context) {
    return Component.element(
      tag: 'section',
      classes: 'fxcover',
      styles: Styles(raw: {'min-height': '${minHeightVh}vh'}),
      children: [
        Component.element(tag: 'style', children: const [RawText(_css)]),
        div(classes: 'fxcover__bg', styles: Styles(raw: {'background-image': 'url($imageSrc)'}), []),
        div(classes: 'fxcover__ov', styles: Styles(raw: {'background': overlay}), []),
        div(classes: 'fxcover__inner', [child]),
      ],
    );
  }
}
