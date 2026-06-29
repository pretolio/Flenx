import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Prateleira de produtos: cabeçalho colorido (com contador opcional) +
/// carrossel horizontal de cards. Passe os cards prontos em [products].
class FlenxProductShelf extends StatelessComponent {
  const FlenxProductShelf({
    required this.title,
    required this.products,
    this.subtitle,
    this.countdown,
    super.key,
  });

  final String title;
  final List<Component> products;
  final String? subtitle;

  /// Contador no formato `HH:MM:SS` (estático). Nulo = sem contador.
  final String? countdown;

  @override
  Component build(BuildContext context) {
    return div(classes: 'fxz-wrap', [
      div(classes: 'fxz-shelf', [
        div(classes: 'fxz-shelf-head', [
          span(classes: 't', [Component.text(title)]),
          if (countdown != null)
            div(classes: 'fxz-clock', [
              for (final part in _parts(countdown!)) ...[
                if (part == ':') Component.text(':') else b([Component.text(part)]),
              ],
            ]),
          if (subtitle != null) span(classes: 'sub', [Component.text(subtitle!)]),
        ]),
        div(classes: 'fxz-carousel', products),
      ]),
      Component.element(tag: 'script', children: [RawText(_shelfJs)]),
    ]);
  }

  /// Contador regressivo (tick a cada 1s, reinicia ao zerar) + carrossel com
  /// avanço automático (pausa ao passar o mouse). Roda uma vez por página.
  static const _shelfJs = '''
(function(){
  if(window.__fxzShelf)return;window.__fxzShelf=1;
  function pad(n){return(n<10?'0':'')+n;}
  function init(){
    document.querySelectorAll('.fxz-clock').forEach(function(cl){
      var b=cl.querySelectorAll('b');if(b.length<3)return;
      var t=(+b[0].textContent)*3600+(+b[1].textContent)*60+(+b[2].textContent);
      setInterval(function(){t=t>0?t-1:8*3600;
        b[0].textContent=pad(Math.floor(t/3600));
        b[1].textContent=pad(Math.floor(t%3600/60));
        b[2].textContent=pad(t%60);},1000);
    });
    document.querySelectorAll('.fxz-carousel').forEach(function(c){
      setInterval(function(){
        if(c.matches(':hover'))return;
        var max=c.scrollWidth-c.clientWidth;
        if(c.scrollLeft>=max-4)c.scrollTo({left:0,behavior:'smooth'});
        else c.scrollBy({left:258,behavior:'smooth'});
      },2800);
    });
  }
  if(document.readyState!=='loading')init();
  else document.addEventListener('DOMContentLoaded',init);
})();
''';

  static List<String> _parts(String c) {
    final out = <String>[];
    final segs = c.split(':');
    for (var i = 0; i < segs.length; i++) {
      out.add(segs[i]);
      if (i < segs.length - 1) out.add(':');
    }
    return out;
  }
}

/// Grade de produtos (catálogo) usando os mesmos cards.
class FlenxProductGrid extends StatelessComponent {
  const FlenxProductGrid({required this.products, this.title, super.key});

  final List<Component> products;
  final String? title;

  @override
  Component build(BuildContext context) {
    return div(classes: 'fxz-wrap', [
      if (title != null) div(classes: 'fxz-sec-title', [Component.text(title!)]),
      div(classes: 'fxz-grid', products),
    ]);
  }
}
