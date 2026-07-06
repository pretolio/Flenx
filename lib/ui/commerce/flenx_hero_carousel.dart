import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'commerce_models.dart';

/// Hero em carrossel: vários slides com imagem de fundo que **trocam
/// automaticamente** (fade), com indicadores. Cada slide tem eyebrow, título,
/// subtítulo, preço de chamada e botão. Só Dart — o HTML/JS fica aqui na lib.
class FlenxHeroCarousel extends StatelessComponent {
  const FlenxHeroCarousel({
    required this.slides,
    this.intervalMs = 5000,
    super.key,
  });

  final List<FlenxHeroSlide> slides;
  final int intervalMs;

  @override
  Component build(BuildContext context) {
    return div(classes: 'fxz-hero', [
      for (var i = 0; i < slides.length; i++) _slide(slides[i], i == 0),
      a(
        [Component.text('‹')],
        href: slides.isNotEmpty ? slides.first.ctaHref : '#',
        classes: 'fxz-arrow l',
      ),
      a(
        [Component.text('›')],
        href: slides.isNotEmpty ? slides.first.ctaHref : '#',
        classes: 'fxz-arrow r',
      ),
      div(classes: 'fxz-dots', [
        for (var i = 0; i < slides.length; i++)
          span(classes: i == 0 ? 'on' : null, []),
      ]),
      Component.element(tag: 'script', children: [RawText(_js(intervalMs))]),
    ]);
  }

  Component _slide(FlenxHeroSlide s, bool active) {
    final styles = s.backgroundImage != null
        ? Styles(raw: {'background-image': "url('${s.backgroundImage}')"})
        : null;
    return div(classes: active ? 'fxz-slide on' : 'fxz-slide', styles: styles, [
      div(classes: 'fxz-hero-in', [
        div([
          if (s.eyebrow != null)
            span(classes: 'eyebrow', [Component.text(s.eyebrow!)]),
          h2([Component.text(s.title)]),
          if (s.subtitle != null) p([Component.text(s.subtitle!)]),
          a([Component.text(s.ctaLabel)], href: s.ctaHref, classes: 'cta'),
        ]),
        if (s.priceValue != null)
          div(classes: 'price', [
            if (s.priceFrom != null) span([Component.text(s.priceFrom!)]),
            span(classes: 'big', [Component.text(s.priceValue!)]),
          ]),
      ]),
    ]);
  }

  static String _js(int ms) =>
      '''
(function(){
  if(window.__fxzHero)return;window.__fxzHero=1;
  function init(){
    document.querySelectorAll('.fxz-hero').forEach(function(h){
      var sl=h.querySelectorAll('.fxz-slide'),dt=h.querySelectorAll('.fxz-dots span');
      if(sl.length<2)return;var i=0;
      function go(n){sl[i].classList.remove('on');if(dt[i])dt[i].classList.remove('on');
        i=(n+sl.length)%sl.length;
        sl[i].classList.add('on');if(dt[i])dt[i].classList.add('on');}
      var t=setInterval(function(){go(i+1);},$ms);
      dt.forEach(function(d,k){d.style.cursor='pointer';d.addEventListener('click',function(){clearInterval(t);go(k);t=setInterval(function(){go(i+1);},$ms);});});
    });
  }
  if(document.readyState!=='loading')init();else document.addEventListener('DOMContentLoaded',init);
})();
''';
}
