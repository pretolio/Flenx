import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'flenx_animation.dart';

export 'flenx_animation.dart';

/// Envolve qualquer componente com uma animação — scroll-reveal ou loop.
///
/// **Scroll-reveal** (aparecem ao entrar na viewport):
/// ```dart
/// FlenxAnimated(FlenxCard(...), animation: FlenxAnimation.slideUp)
/// FlenxAnimated(FlenxHeading(...), animation: FlenxAnimation.fadeIn, delay: 200)
/// ```
///
/// **Loop** (contínuo):
/// ```dart
/// FlenxAnimated(icone, animation: FlenxAnimation.float)
/// FlenxAnimated(badge, animation: FlenxAnimation.pulse)
/// ```
class FlenxAnimated extends StatelessComponent {
  const FlenxAnimated(
    this.child, {
    required this.animation,
    this.delay = 0,
    this.duration = 600,
    super.key,
  });

  final Component child;
  final FlenxAnimation animation;

  /// Atraso em ms antes de a animação começar.
  final int delay;

  /// Duração em ms (scroll-reveal) ou da iteração (loop).
  final int duration;

  static const _revealSet = {
    FlenxAnimation.fadeIn,
    FlenxAnimation.slideUp,
    FlenxAnimation.slideDown,
    FlenxAnimation.slideLeft,
    FlenxAnimation.slideRight,
    FlenxAnimation.zoomIn,
  };

  bool get _isReveal => _revealSet.contains(animation);

  String get _revealClass => switch (animation) {
        FlenxAnimation.fadeIn => '',
        FlenxAnimation.slideUp => 'fa-up',
        FlenxAnimation.slideDown => 'fa-down',
        FlenxAnimation.slideLeft => 'fa-left',
        FlenxAnimation.slideRight => 'fa-right',
        FlenxAnimation.zoomIn => 'fa-zoom',
        _ => '',
      };

  String get _loopClass => switch (animation) {
        FlenxAnimation.pulse => 'fa-pulse',
        FlenxAnimation.bounce => 'fa-bounce',
        FlenxAnimation.float => 'fa-float',
        FlenxAnimation.spin => 'fa-spin',
        _ => '',
      };

  // ── CSS scroll-reveal ────────────────────────────────────────────────────
  static const _revealCss = '''
.fa-reveal{opacity:0;transition-property:opacity,transform;transition-timing-function:cubic-bezier(.4,0,.2,1);will-change:opacity,transform}
.fa-reveal.fa-visible{opacity:1;transform:none!important}
.fa-up{transform:translateY(36px)}
.fa-down{transform:translateY(-36px)}
.fa-left{transform:translateX(36px)}
.fa-right{transform:translateX(-36px)}
.fa-zoom{transform:scale(.92)}
''';

  // ── CSS animações contínuas ──────────────────────────────────────────────
  static const _loopCss = '''
@keyframes fa-pulse{0%,100%{transform:scale(1)}50%{transform:scale(1.06)}}
@keyframes fa-bounce{0%,100%{transform:translateY(0)}50%{transform:translateY(-10px)}}
@keyframes fa-float{0%,100%{transform:translateY(0)}50%{transform:translateY(-7px)}}
@keyframes fa-spin{from{transform:rotate(0deg)}to{transform:rotate(360deg)}}
.fa-pulse{animation:fa-pulse var(--fa-dur,1.6s) ease-in-out infinite}
.fa-bounce{animation:fa-bounce var(--fa-dur,1s) ease-in-out infinite}
.fa-float{animation:fa-float var(--fa-dur,3s) ease-in-out infinite}
.fa-spin{animation:fa-spin var(--fa-dur,2s) linear infinite}
''';

  // ── IntersectionObserver (injetado uma vez; guard no início) ────────────
  static const _observerJs = '''
(function(){
if(window.__faObs)return;
var o=new IntersectionObserver(function(es){
  es.forEach(function(e){if(e.isIntersecting){e.target.classList.add('fa-visible');o.unobserve(e.target);}});
},{threshold:0.12,rootMargin:'0px 0px -40px 0px'});
function watch(){document.querySelectorAll('.fa-reveal:not([data-o])').forEach(function(el){el.setAttribute('data-o','1');o.observe(el);})}
if(document.readyState==='loading'){document.addEventListener('DOMContentLoaded',watch);}else{watch();}
new MutationObserver(watch).observe(document.documentElement,{childList:true,subtree:true});
window.__faObs=o;
})();
''';

  @override
  Component build(BuildContext context) {
    if (_isReveal) {
      final cls = 'fa-reveal${_revealClass.isEmpty ? '' : ' $_revealClass'}';
      return span(styles: Styles(raw: {'display': 'contents'}), [
        Component.element(tag: 'style', children: [RawText(_revealCss)]),
        Component.element(tag: 'script', children: [RawText(_observerJs)]),
        div(
          classes: cls,
          styles: Styles(raw: {
            'transition-duration': '${duration}ms',
            if (delay > 0) 'transition-delay': '${delay}ms',
          }),
          [child],
        ),
      ]);
    }

    return span(styles: Styles(raw: {'display': 'contents'}), [
      Component.element(tag: 'style', children: [RawText(_loopCss)]),
      div(
        classes: _loopClass,
        styles: Styles(raw: {
          '--fa-dur': '${duration}ms',
          if (delay > 0) 'animation-delay': '${delay}ms',
        }),
        [child],
      ),
    ]);
  }
}
