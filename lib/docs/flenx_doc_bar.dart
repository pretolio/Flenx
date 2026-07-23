import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../flenx_palette.dart';

/// Barra fixa no topo de um documento: voltar à Central + imprimir.
/// Não aparece na impressão. O botão dispara `window.print()`.
class FlenxDocBar extends StatelessComponent {
  const FlenxDocBar({
    required this.title,
    required this.backHref,
    this.backLabel = 'Central',
    this.accent = FlenxPalette.primary,
    this.barColor = '#071C43',
    super.key,
  });

  final String title;
  final String backHref;
  final String backLabel;
  final String accent;
  final String barColor;

  static const _css = '''
.fxdoc-bar{position:sticky;top:0;z-index:50;display:flex;align-items:center;gap:14px;
padding:12px 20px;color:#fff;backdrop-filter:blur(6px);box-shadow:0 2px 14px rgba(0,0,0,.2);
font-family:system-ui,-apple-system,"Segoe UI",Roboto,sans-serif}
.fxdoc-bar a.fxdoc-back{display:inline-flex;align-items:center;gap:7px;font-weight:700;
font-size:.9rem;color:#cfe0ff;text-decoration:none;opacity:.9}
.fxdoc-bar a.fxdoc-back:hover{opacity:1}
.fxdoc-bar .fxdoc-title{flex:1;font-weight:800;font-size:.98rem;white-space:nowrap;
overflow:hidden;text-overflow:ellipsis}
.fxdoc-print{display:inline-flex;align-items:center;gap:8px;border:0;cursor:pointer;
padding:9px 18px;border-radius:999px;font-weight:800;font-size:.9rem;font-family:inherit;
color:#fff;transition:transform .15s ease}
.fxdoc-print:hover{transform:translateY(-1px)}
@media print{.fxdoc-bar{display:none !important}}
''';

  static const _js = '''
(function(){var b=document.getElementById('fxdoc-print');if(b&&!b.__b){b.__b=1;
b.addEventListener('click',function(){window.print();});}
if(location.search.indexOf('print=1')!==-1){window.addEventListener('load',function(){
setTimeout(function(){window.print();},400);});}})();
''';

  @override
  Component build(BuildContext context) {
    return div(classes: 'fxdoc-bar', styles: Styles(raw: {'background': barColor}), [
      Component.element(tag: 'style', children: const [RawText(_css)]),
      a([Component.text('← $backLabel')], href: backHref, classes: 'fxdoc-back'),
      span(classes: 'fxdoc-title', [Component.text(title)]),
      button(
        id: 'fxdoc-print',
        classes: 'fxdoc-print',
        styles: Styles(raw: {'background': accent}),
        [Component.text('🖨  Imprimir')],
      ),
      Component.element(tag: 'script', children: const [RawText(_js)]),
    ]);
  }
}
