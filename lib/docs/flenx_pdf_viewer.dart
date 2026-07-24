import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../flenx_palette.dart';

/// Visualizador de um PDF em tela cheia: barra (voltar + baixar) + o PDF
/// embutido. Usado para servir um documento comercial já gerado em PDF —
/// imprime/baixa sempre igual, sem depender do CSS de impressão do navegador.
class FlenxPdfViewer extends StatelessComponent {
  const FlenxPdfViewer({
    required this.pdfUrl,
    required this.title,
    this.backHref = '/comercial',
    this.backLabel = 'Central',
    this.accent = FlenxPalette.primary,
    this.barColor = '#071C43',
    this.downloadName,
    super.key,
  });

  final String pdfUrl;
  final String title;
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
.fxpv__frame{flex:1;border:0;width:100%}
''';

  /// Safari (WebKit) ignora `#toolbar=1` — o visor nativo dele não mostra
  /// nenhuma barra dentro de iframe — e ignora o atributo `download` em
  /// links de PDF, abrindo o arquivo em vez de baixar. Por isso o clique no
  /// botão baixa via fetch+blob (funciona em qualquer navegador) em vez de
  /// depender só do atributo `download`; se o fetch falhar, cai para a
  /// navegação normal do link.
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
})();
''';

  @override
  Component build(BuildContext context) {
    return div(classes: 'fxpv', [
      Component.element(tag: 'style', children: const [RawText(_css)]),
      div(classes: 'fxpv__bar', styles: Styles(raw: {'background': barColor}), [
        a([Component.text('← $backLabel')], href: backHref, classes: 'fxpv__back'),
        span(classes: 'fxpv__title', [Component.text(title)]),
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
      Component.element(tag: 'script', children: const [RawText(_js)]),
    ]);
  }
}
