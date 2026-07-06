import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Animação Lottie — carrega um arquivo `.json` via [lottie-web](https://github.com/airbnb/lottie-web).
/// O runtime JS é carregado do CDN automaticamente (uma vez por página).
///
/// ```dart
/// FlenxLottie('/assets/loading.json', width: 200, height: 200)
///
/// FlenxLottie(
///   'https://assets10.lottiefiles.com/packages/lf20_xxx.json',
///   width: 300,
///   height: 300,
///   loop: true,
///   autoplay: true,
/// )
/// ```
class FlenxLottie extends StatelessComponent {
  const FlenxLottie(
    this.src, {
    this.width,
    this.height,
    this.size,
    this.loop = true,
    this.autoplay = true,
    this.renderer = 'svg',
    super.key,
  });

  /// URL do arquivo de animação `.json` (local ou remoto).
  final String src;

  final double? width;
  final double? height;

  /// Atalho: define largura e altura iguais.
  final double? size;

  /// Repete a animação infinitamente.
  final bool loop;

  /// Inicia a animação automaticamente.
  final bool autoplay;

  /// Motor de renderização: `'svg'` (padrão), `'canvas'` ou `'html'`.
  final String renderer;

  double? get _w => size ?? width;
  double? get _h => size ?? height;

  String get _id => 'flottie-${src.hashCode.abs().toRadixString(16)}';

  String get _js =>
      '''
(function(){
  var id='$_id';
  var opts={container:null,renderer:'$renderer',loop:${loop ? 'true' : 'false'},autoplay:${autoplay ? 'true' : 'false'},path:'${src.replaceAll("'", "\\'")}' };
  function init(){
    var el=document.getElementById(id);
    if(!el||el.dataset.li)return;
    el.dataset.li='1';
    lottie.loadAnimation(Object.assign({},opts,{container:el}));
  }
  window.__fLottieQ=window.__fLottieQ||[];
  window.__fLottieQ.push(init);
  if(window.lottie){
    init();
  } else if(!document.getElementById('flottie-cdn')){
    var s=document.createElement('script');
    s.id='flottie-cdn';
    s.src='https://cdnjs.cloudflare.com/ajax/libs/lottie-web/5.12.2/lottie.min.js';
    s.onload=function(){window.__fLottieQ.forEach(function(fn){fn();});window.__fLottieQ=[];};
    document.head.appendChild(s);
  }
})();
''';

  @override
  Component build(BuildContext context) {
    return span(styles: Styles(raw: {'display': 'contents'}), [
      Component.element(tag: 'script', children: [RawText(_js)]),
      div(
        id: _id,
        styles: Styles(
          raw: {
            if (_w != null) 'width': '${_w}px',
            if (_h != null) 'height': '${_h}px',
            if (_w == null && _h == null) 'width': '100%',
            'overflow': 'hidden',
          },
        ),
        [],
      ),
    ]);
  }
}
