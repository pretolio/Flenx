import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Animação Rive — carrega um arquivo `.riv` via [@rive-app/canvas](https://rive.app/).
/// O runtime JS é carregado do CDN automaticamente (uma vez por página).
///
/// ```dart
/// FlenxRive('/assets/logo.riv', width: 300, height: 200)
///
/// FlenxRive(
///   '/assets/character.riv',
///   width: 400,
///   height: 400,
///   artboard: 'Main',
///   stateMachine: 'Idle',
///   autoplay: true,
/// )
/// ```
class FlenxRive extends StatelessComponent {
  const FlenxRive(
    this.src, {
    this.width,
    this.height,
    this.size,
    this.artboard,
    this.stateMachine,
    this.autoplay = true,
    super.key,
  });

  /// URL do arquivo `.riv` (local ou remoto).
  final String src;

  final double? width;
  final double? height;

  /// Atalho: define largura e altura iguais.
  final double? size;

  /// Nome do artboard a renderizar. Nulo = artboard padrão.
  final String? artboard;

  /// Nome da state machine a ativar. Nulo = sem state machine.
  final String? stateMachine;

  /// Inicia a animação automaticamente.
  final bool autoplay;

  double? get _w => size ?? width;
  double? get _h => size ?? height;

  String get _id => 'frive-${src.hashCode.abs().toRadixString(16)}';

  String _esc(String s) => s.replaceAll("'", "\\'");

  String get _js {
    final artboardOpt = artboard != null
        ? "artboard:'${_esc(artboard!)}',"
        : '';
    final smOpt = stateMachine != null
        ? "stateMachines:'${_esc(stateMachine!)}',"
        : '';
    return '''
(function(){
  var id='$_id';
  function init(){
    var canvas=document.getElementById(id);
    if(!canvas||canvas.dataset.ri)return;
    canvas.dataset.ri='1';
    var r=new rive.Rive({
      src:'${_esc(src)}',
      canvas:canvas,
      autoplay:${autoplay ? 'true' : 'false'},
      $artboardOpt
      $smOpt
      onLoad:function(){ r.resizeDrawingSurfaceToCanvas(); }
    });
  }
  window.__fRiveQ=window.__fRiveQ||[];
  window.__fRiveQ.push(init);
  if(window.rive){
    init();
  } else if(!document.getElementById('frive-cdn')){
    var s=document.createElement('script');
    s.id='frive-cdn';
    s.src='https://unpkg.com/@rive-app/canvas';
    s.onload=function(){window.__fRiveQ.forEach(function(fn){fn();});window.__fRiveQ=[];};
    document.head.appendChild(s);
  }
})();
''';
  }

  @override
  Component build(BuildContext context) {
    return span(styles: Styles(raw: {'display': 'contents'}), [
      Component.element(tag: 'script', children: [RawText(_js)]),
      Component.element(
        tag: 'canvas',
        id: _id,
        styles: Styles(
          raw: {
            if (_w != null) 'width': '${_w}px',
            if (_h != null) 'height': '${_h}px',
            if (_w == null) 'width': '100%',
            'display': 'block',
          },
        ),
        attributes: {
          if (_w != null) 'width': '${_w!.toInt()}',
          if (_h != null) 'height': '${_h!.toInt()}',
        },
        children: [],
      ),
    ]);
  }
}
