import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../flenx_palette.dart';

/// Visualizador de um PDF em tela cheia: opcionalmente uma barra (voltar +
/// imprimir + baixar) por cima do PDF embutido. Usado para servir um
/// documento comercial já gerado em PDF — imprime/baixa sempre igual, sem
/// depender do CSS de impressão do navegador.
class FlenxPdfViewer extends StatelessComponent {
  const FlenxPdfViewer({
    required this.pdfUrl,
    required this.title,
    this.showBar = true,
    this.backHref = '/comercial',
    this.backLabel = 'Central',
    this.accent = FlenxPalette.primary,
    this.barColor = '#071C43',
    this.downloadName,
    super.key,
  });

  final String pdfUrl;
  final String title;

  /// Sem a barra, é só o PDF em tela cheia — voltar/imprimir/baixar ficam
  /// por conta do próprio visualizador nativo do navegador (e do botão
  /// voltar). Sem chrome nenhum por cima do documento.
  final bool showBar;
  final String backHref;
  final String backLabel;
  final String accent;
  final String barColor;
  final String? downloadName;

  static const _css = '''
.fxpv{position:fixed;inset:0;display:flex;flex-direction:column;background:#525659;
font-family:system-ui,-apple-system,"Segoe UI",Roboto,sans-serif}
.fxpv__bar{display:flex;align-items:center;gap:14px;padding:12px 20px;color:#fff}
.fxpv__back{display:inline-flex;align-items:center;gap:7px;font-weight:700;font-size:.9rem;color:#cfe0ff;text-decoration:none;opacity:.9}
.fxpv__back:hover{opacity:1}
.fxpv__title{flex:1;font-weight:800;font-size:.98rem;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.fxpv__dl{display:inline-flex;align-items:center;gap:8px;padding:9px 18px;border-radius:999px;
font-weight:800;font-size:.9rem;color:#fff;text-decoration:none;transition:transform .15s ease}
.fxpv__dl:hover{transform:translateY(-1px)}
.fxpv__print{display:inline-flex;align-items:center;gap:8px;padding:9px 16px;border-radius:999px;
border:1px solid rgba(255,255,255,.35);background:transparent;cursor:pointer;
font-weight:800;font-size:.9rem;font-family:inherit;color:#fff;transition:transform .15s ease}
.fxpv__print:hover{transform:translateY(-1px);border-color:rgba(255,255,255,.6)}
.fxpv__frame{flex:1;border:0;width:100%}
@media print{.fxpv__bar{display:none !important}.fxpv{position:static;background:none}}
''';

  /// Safari (WebKit) ignora `#toolbar=1` — o visor nativo dele não mostra
  /// nenhuma barra dentro de iframe — e ignora o atributo `download` em
  /// links de PDF, abrindo o arquivo em vez de baixar. Por isso o clique no
  /// botão baixa via fetch+blob (funciona em qualquer navegador) em vez de
  /// depender só do atributo `download`; se o fetch falhar, cai para a
  /// navegação normal do link. O botão de imprimir foca a `contentWindow` do
  /// iframe e chama `print()` nela — no Safari, `window.print()` no
  /// documento-pai imprimiria uma folha em branco no lugar do PDF.
  static const _js = '''
(function(){
  var dl=document.getElementById('fxpv-dl');
  if(dl&&!dl.__b){dl.__b=1;
    dl.addEventListener('click',function(ev){
      ev.preventDefault();
      var url=dl.getAttribute('href'), name=dl.getAttribute('data-name')||'documento.pdf';
      fetch(url).then(function(r){return r.blob();}).then(function(blob){
        var obj=URL.createObjectURL(blob), a=document.createElement('a');
        a.href=obj; a.download=name; document.body.appendChild(a); a.click(); a.remove();
        setTimeout(function(){URL.revokeObjectURL(obj);},1000);
      }).catch(function(){window.location.href=url;});
    });
  }
  var pr=document.getElementById('fxpv-print');
  if(pr&&!pr.__b){pr.__b=1;
    pr.addEventListener('click',function(){
      var f=document.getElementById('fxpv-frame');
      if(f&&f.contentWindow){try{f.contentWindow.focus();f.contentWindow.print();return;}catch(e){}}
      window.print();
    });
  }
})();
''';

  @override
  Component build(BuildContext context) {
    return div(classes: 'fxpv', [
      Component.element(tag: 'style', children: const [RawText(_css)]),
      if (showBar)
        div(classes: 'fxpv__bar', styles: Styles(raw: {'background': barColor}), [
          a([Component.text('← $backLabel')], href: backHref, classes: 'fxpv__back'),
          span(classes: 'fxpv__title', [Component.text(title)]),
          button(id: 'fxpv-print', classes: 'fxpv__print', [Component.text('🖨  Imprimir')]),
          a(
            [Component.text('⭳  Baixar PDF')],
            href: pdfUrl,
            download: downloadName ?? '',
            id: 'fxpv-dl',
            classes: 'fxpv__dl',
            styles: Styles(raw: {'background': accent}),
            attributes: {'data-name': downloadName ?? 'documento.pdf'},
          ),
        ]),
      Component.element(
        tag: 'iframe',
        id: 'fxpv-frame',
        classes: 'fxpv__frame',
        attributes: {'src': '$pdfUrl#toolbar=1&view=FitH', 'title': title},
        children: const [],
      ),
      if (showBar) Component.element(tag: 'script', children: const [RawText(_js)]),
    ]);
  }
}
