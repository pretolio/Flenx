import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Frequência com que a campanha volta a aparecer após ser fechada.
enum FlenxPromoRepeat { once, daily, session, always }

/// Uma campanha de propaganda agendada exibida no [PromoModal].
///
/// O período é definido por [start]/[end] (datas ISO `YYYY-MM-DD` ou
/// `YYYY-MM-DDTHH:MM`). A verificação ocorre no navegador a cada carregamento:
/// deixe várias campanhas cadastradas com datas diferentes que o site mostra a
/// que estiver no ar no momento — sem republicar entre campanhas.
///
/// Imagens: use [imageUrl] para uma única imagem, ou [images] (2+) para um
/// carrossel automático com setas e indicadores.
class FlenxPromo {
  const FlenxPromo({
    required this.id,
    required this.title,
    required this.message,
    this.imageUrl,
    this.images = const [],
    this.ctaLabel,
    this.ctaHref,
    this.start,
    this.end,
    this.repeat = FlenxPromoRepeat.daily,
  });

  final String id;
  final String title;
  final String message;

  /// Imagem única no topo do card. Ignorada se [images] tiver itens.
  final String? imageUrl;

  /// Duas ou mais imagens → carrossel automático (com setas e bolinhas).
  final List<String> images;

  final String? ctaLabel;
  final String? ctaHref;
  final String? start;
  final String? end;
  final FlenxPromoRepeat repeat;
}

/// Modal de propaganda no centro da tela, agendado por período. Passe uma lista
/// de [Promo] com datas; o modal escolhe, no navegador, a primeira campanha
/// ativa (dentro do período e ainda não fechada) e a exibe centralizada, com
/// overlay, carrossel de imagens opcional, botão de fechar e ação opcional.
/// Renderize via `floatingButtons`.
class FlenxPromoModal extends StatelessComponent {
  const FlenxPromoModal({
    required this.promos,
    required this.accentColor,
    this.delayMs = 1200,
    this.intervalMs = 4000,
    super.key,
  });

  final List<FlenxPromo> promos;
  final String accentColor;

  /// Atraso (ms) antes de exibir, para não competir com o carregamento inicial.
  final int delayMs;

  /// Tempo (ms) entre trocas automáticas de slide no carrossel.
  final int intervalMs;

  String get _css => '''
.fxpromo-ov{position:fixed;inset:0;z-index:2147483000;display:flex;align-items:center;justify-content:center;padding:20px;background:rgba(15,23,42,.62);backdrop-filter:blur(3px);opacity:0;transition:opacity .28s ease}
.fxpromo-ov.show{opacity:1}
.fxpromo-card{position:relative;width:100%;max-width:420px;background:#fff;border-radius:18px;overflow:hidden;box-shadow:0 24px 70px rgba(2,6,23,.45);transform:translateY(16px) scale(.97);transition:transform .3s cubic-bezier(.2,.8,.2,1)}
.fxpromo-ov.show .fxpromo-card{transform:none}
.fxpromo-img{display:block;width:100%;height:auto;max-height:220px;object-fit:cover}
.fxpromo-carousel{position:relative;overflow:hidden}
.fxpromo-track{display:flex;transition:transform .45s cubic-bezier(.2,.8,.2,1)}
.fxpromo-track .fxpromo-img{min-width:100%;flex:0 0 100%}
.fxpromo-nav{position:absolute;top:50%;transform:translateY(-50%);width:32px;height:32px;border:0;border-radius:50%;background:rgba(15,23,42,.5);color:#fff;font-size:20px;line-height:32px;text-align:center;cursor:pointer;padding:0;z-index:2}
.fxpromo-nav:hover{background:rgba(15,23,42,.78)}
.fxpromo-nav.prev{left:10px}
.fxpromo-nav.next{right:10px}
.fxpromo-dots{position:absolute;left:0;right:0;bottom:10px;display:flex;gap:7px;justify-content:center;z-index:2}
.fxpromo-dots button{width:8px;height:8px;padding:0;border:0;border-radius:50%;background:rgba(255,255,255,.55);cursor:pointer;transition:background .16s ease,transform .16s ease}
.fxpromo-dots button.active{background:#fff;transform:scale(1.25)}
.fxpromo-body{padding:24px 24px 26px;text-align:center}
.fxpromo-title{margin:0 0 8px;font-family:'Barlow Condensed',Impact,sans-serif;font-weight:800;font-size:1.6rem;line-height:1.1;color:#0f172a;text-transform:uppercase;letter-spacing:.3px}
.fxpromo-msg{margin:0;color:#475569;font-size:1rem;line-height:1.5}
.fxpromo-cta{display:inline-block;margin-top:18px;padding:12px 26px;border-radius:999px;background:$accentColor;color:#fff;font-weight:700;font-size:.98rem;text-decoration:none;box-shadow:0 8px 22px rgba(2,6,23,.22);transition:transform .16s ease}
.fxpromo-cta:hover{transform:translateY(-2px)}
.fxpromo-x{position:absolute;top:10px;right:10px;width:34px;height:34px;border:0;border-radius:50%;background:rgba(15,23,42,.55);color:#fff;font-size:20px;line-height:34px;text-align:center;cursor:pointer;padding:0;z-index:3}
.fxpromo-x:hover{background:rgba(15,23,42,.8)}
@media(max-width:480px){.fxpromo-title{font-size:1.4rem}}
@media(prefers-reduced-motion:reduce){.fxpromo-ov,.fxpromo-card,.fxpromo-track{transition:none}}
''';

  static String _js(String? v) {
    if (v == null) return 'null';
    final e = v
        .replaceAll(r'\', r'\\')
        .replaceAll("'", r"\'")
        .replaceAll('\n', r'\n')
        .replaceAll('\r', '')
        .replaceAll('</', r'<\/');
    return "'$e'";
  }

  static String _jsArr(List<String> xs) => '[${xs.map(_js).join(',')}]';

  String _promoLiteral(FlenxPromo p) =>
      '{id:${_js(p.id)},title:${_js(p.title)},message:${_js(p.message)},'
      'image:${_js(p.imageUrl)},images:${_jsArr(p.images)},'
      'ctaLabel:${_js(p.ctaLabel)},ctaHref:${_js(p.ctaHref)},'
      'start:${_js(p.start)},end:${_js(p.end)},repeat:${_js(p.repeat.name)}}';

  String get _script {
    final list = promos.map(_promoLiteral).join(',');
    return '''
(function(){
  var P=[$list],DELAY=$delayMs,IVAL=$intervalMs;
  function within(p){var n=new Date();
    if(p.start&&n<new Date(p.start))return false;
    if(p.end){var e=new Date(p.end);if(p.end.length<=10)e.setHours(23,59,59,999);if(n>e)return false;}
    return true;}
  function today(){return new Date().toISOString().slice(0,10);}
  function store(p){return p.repeat==='session'?sessionStorage:localStorage;}
  function seen(p){try{if(p.repeat==='always')return false;var v=store(p).getItem('fxpromo:'+p.id);
    if(!v)return false;return p.repeat==='daily'?v===today():true;}catch(e){return false;}}
  function mark(p){try{if(p.repeat==='always')return;store(p).setItem('fxpromo:'+p.id,p.repeat==='daily'?today():'1');}catch(e){}}
  function img(src){var im=document.createElement('img');im.className='fxpromo-img';im.src=src;im.alt='';im.loading='lazy';return im;}
  function carousel(srcs){
    var wrap=document.createElement('div');wrap.className='fxpromo-carousel';
    var track=document.createElement('div');track.className='fxpromo-track';
    srcs.forEach(function(s){track.appendChild(img(s));});
    wrap.appendChild(track);
    var dots=document.createElement('div');dots.className='fxpromo-dots';
    var i=0,timer=null;
    function go(n){i=(n+srcs.length)%srcs.length;track.style.transform='translateX('+(-i*100)+'%)';
      Array.prototype.forEach.call(dots.children,function(d,k){d.className=k===i?'active':'';});}
    function play(){stop();timer=setInterval(function(){go(i+1);},IVAL);}
    function stop(){if(timer){clearInterval(timer);timer=null;}}
    srcs.forEach(function(_,k){var b=document.createElement('button');b.type='button';b.setAttribute('aria-label','Imagem '+(k+1));
      b.addEventListener('click',function(){go(k);play();});dots.appendChild(b);});
    var prev=document.createElement('button');prev.className='fxpromo-nav prev';prev.type='button';prev.setAttribute('aria-label','Anterior');prev.innerHTML='&#8249;';
    var next=document.createElement('button');next.className='fxpromo-nav next';next.type='button';next.setAttribute('aria-label','Próxima');next.innerHTML='&#8250;';
    prev.addEventListener('click',function(){go(i-1);play();});
    next.addEventListener('click',function(){go(i+1);play();});
    wrap.appendChild(prev);wrap.appendChild(next);wrap.appendChild(dots);
    wrap.addEventListener('mouseenter',stop);wrap.addEventListener('mouseleave',play);
    go(0);play();
    return wrap;
  }
  function run(){
    var pick=null;for(var i=0;i<P.length;i++){if(within(P[i])&&!seen(P[i])){pick=P[i];break;}}
    if(!pick)return;
    var imgs=(pick.images&&pick.images.length)?pick.images:(pick.image?[pick.image]:[]);
    var ov=document.createElement('div');ov.className='fxpromo-ov';ov.setAttribute('role','dialog');ov.setAttribute('aria-modal','true');
    var card=document.createElement('div');card.className='fxpromo-card';
    var x=document.createElement('button');x.className='fxpromo-x';x.type='button';x.setAttribute('aria-label','Fechar');x.innerHTML='&times;';
    card.appendChild(x);
    if(imgs.length>1)card.appendChild(carousel(imgs));
    else if(imgs.length===1)card.appendChild(img(imgs[0]));
    var body=document.createElement('div');body.className='fxpromo-body';
    var h=document.createElement('h3');h.className='fxpromo-title';h.textContent=pick.title;body.appendChild(h);
    var m=document.createElement('p');m.className='fxpromo-msg';m.textContent=pick.message;body.appendChild(m);
    if(pick.ctaLabel&&pick.ctaHref){var a=document.createElement('a');a.className='fxpromo-cta';a.href=pick.ctaHref;a.textContent=pick.ctaLabel;a.addEventListener('click',function(){mark(pick);});body.appendChild(a);}
    card.appendChild(body);ov.appendChild(card);
    function close(){mark(pick);ov.classList.remove('show');setTimeout(function(){if(ov.parentNode)ov.parentNode.removeChild(ov);},320);document.removeEventListener('keydown',onKey);}
    function onKey(e){if(e.key==='Escape')close();}
    x.addEventListener('click',close);
    ov.addEventListener('click',function(e){if(e.target===ov)close();});
    document.addEventListener('keydown',onKey);
    document.body.appendChild(ov);
    requestAnimationFrame(function(){ov.classList.add('show');});
  }
  function boot(){setTimeout(run,DELAY);}
  if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',boot);else boot();
})();
''';
  }

  @override
  Component build(BuildContext context) {
    if (promos.isEmpty) return Component.fragment(const []);
    return Component.fragment([
      Component.element(tag: 'style', children: [RawText(_css)]),
      Component.element(
        tag: 'script',
        attributes: const {'defer': ''},
        children: [RawText(_script)],
      ),
    ]);
  }
}
