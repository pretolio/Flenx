import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../flenx_palette.dart';

/// Uma campanha de propaganda agendada exibida no [FlenxPromoModal].
///
/// O período é definido por [start]/[end] (datas ISO `YYYY-MM-DD` ou
/// `YYYY-MM-DDTHH:MM`). A verificação ocorre no navegador a cada carregamento,
/// então basta deixar várias campanhas cadastradas com datas diferentes que o
/// site mostra a que estiver no ar no momento — sem republicar.
class FlenxPromo {
  const FlenxPromo({
    required this.id,
    required this.title,
    required this.message,
    this.imageUrl,
    this.ctaLabel,
    this.ctaHref,
    this.start,
    this.end,
    this.repeat = FlenxPromoRepeat.daily,
  });

  /// Identificador único e estável (usado para lembrar que o usuário fechou).
  final String id;
  final String title;
  final String message;

  /// Imagem opcional exibida no topo do card (banner da campanha).
  final String? imageUrl;

  /// Botão de ação opcional (ex.: "Aproveitar", "Solicitar agora").
  final String? ctaLabel;
  final String? ctaHref;

  /// Início do período (inclusive). Ex.: `'2026-07-20'`. Nulo = sem início.
  final String? start;

  /// Fim do período (inclusive). Ex.: `'2026-07-31'`. Nulo = sem fim.
  final String? end;

  /// Com que frequência reaparece depois de fechado.
  final FlenxPromoRepeat repeat;
}

/// Frequência com que a campanha volta a aparecer após ser fechada.
enum FlenxPromoRepeat {
  /// Uma única vez por navegador (lembra para sempre).
  once,

  /// Uma vez por dia.
  daily,

  /// Uma vez por sessão (volta ao reabrir o navegador).
  session,

  /// Sempre que a página carregar (não lembra o fechamento).
  always,
}

/// Modal de propaganda no centro da tela, agendado por período.
///
/// Passe uma lista de [FlenxPromo] com datas; o modal escolhe, no navegador,
/// a primeira campanha ativa (dentro do período e ainda não fechada) e a exibe
/// centralizada, com overlay, botão de fechar e uma ação opcional. Sem HTML/CSS
/// no app — é autossuficiente. Renderize-o via `floatingButtons` no `FlenxApp.run`.
///
/// ```dart
/// FlenxPromoModal(
///   accentColor: alstopOrange,
///   promos: const [
///     FlenxPromo(
///       id: 'julho-10off',
///       title: 'Promoção de Julho',
///       message: '10% de desconto em todas as entregas até o fim do mês!',
///       ctaLabel: 'Solicitar agora',
///       ctaHref: '/pedido',
///       start: '2026-07-20',
///       end: '2026-07-31',
///     ),
///   ],
/// )
/// ```
class FlenxPromoModal extends StatelessComponent {
  const FlenxPromoModal({
    required this.promos,
    this.accentColor = FlenxPalette.primary,
    this.delayMs = 1200,
    super.key,
  });

  final List<FlenxPromo> promos;
  final String accentColor;

  /// Atraso (ms) antes de exibir, para não competir com o carregamento inicial.
  final int delayMs;

  String get _css => '''
.fxpromo-ov{position:fixed;inset:0;z-index:2147483000;display:flex;align-items:center;justify-content:center;padding:20px;background:rgba(15,23,42,.62);backdrop-filter:blur(3px);opacity:0;transition:opacity .28s ease}
.fxpromo-ov.show{opacity:1}
.fxpromo-card{position:relative;width:100%;max-width:420px;background:#fff;border-radius:18px;overflow:hidden;box-shadow:0 24px 70px rgba(2,6,23,.45);transform:translateY(16px) scale(.97);transition:transform .3s cubic-bezier(.2,.8,.2,1)}
.fxpromo-ov.show .fxpromo-card{transform:none}
.fxpromo-img{display:block;width:100%;height:auto;max-height:220px;object-fit:cover}
.fxpromo-body{padding:24px 24px 26px;text-align:center}
.fxpromo-title{margin:0 0 8px;font-family:'Barlow Condensed',Impact,sans-serif;font-weight:800;font-size:1.6rem;line-height:1.1;color:#0f172a;text-transform:uppercase;letter-spacing:.3px}
.fxpromo-msg{margin:0;color:#475569;font-size:1rem;line-height:1.5}
.fxpromo-cta{display:inline-block;margin-top:18px;padding:12px 26px;border-radius:999px;background:$accentColor;color:#fff;font-weight:700;font-size:.98rem;text-decoration:none;box-shadow:0 8px 22px rgba(2,6,23,.22);transition:transform .16s ease}
.fxpromo-cta:hover{transform:translateY(-2px)}
.fxpromo-x{position:absolute;top:10px;right:10px;width:34px;height:34px;border:0;border-radius:50%;background:rgba(15,23,42,.55);color:#fff;font-size:20px;line-height:34px;text-align:center;cursor:pointer;padding:0;z-index:2}
.fxpromo-x:hover{background:rgba(15,23,42,.8)}
@media(max-width:480px){.fxpromo-title{font-size:1.4rem}}
@media(prefers-reduced-motion:reduce){.fxpromo-ov,.fxpromo-card{transition:none}}
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

  String _promoLiteral(FlenxPromo p) =>
      '{id:${_js(p.id)},title:${_js(p.title)},message:${_js(p.message)},'
      'image:${_js(p.imageUrl)},ctaLabel:${_js(p.ctaLabel)},ctaHref:${_js(p.ctaHref)},'
      'start:${_js(p.start)},end:${_js(p.end)},repeat:${_js(p.repeat.name)}}';

  String get _script {
    final list = promos.map(_promoLiteral).join(',');
    return '''
(function(){
  var P=[$list],DELAY=$delayMs;
  function within(p){var n=new Date();
    if(p.start&&n<new Date(p.start))return false;
    if(p.end){var e=new Date(p.end);if(p.end.length<=10)e.setHours(23,59,59,999);if(n>e)return false;}
    return true;}
  function today(){return new Date().toISOString().slice(0,10);}
  function store(p){return p.repeat==='session'?sessionStorage:localStorage;}
  function seen(p){try{if(p.repeat==='always')return false;var v=store(p).getItem('fxpromo:'+p.id);
    if(!v)return false;return p.repeat==='daily'?v===today():true;}catch(e){return false;}}
  function mark(p){try{if(p.repeat==='always')return;store(p).setItem('fxpromo:'+p.id,p.repeat==='daily'?today():'1');}catch(e){}}
  function run(){
    var pick=null;for(var i=0;i<P.length;i++){if(within(P[i])&&!seen(P[i])){pick=P[i];break;}}
    if(!pick)return;
    var ov=document.createElement('div');ov.className='fxpromo-ov';ov.setAttribute('role','dialog');ov.setAttribute('aria-modal','true');
    var card=document.createElement('div');card.className='fxpromo-card';
    var x=document.createElement('button');x.className='fxpromo-x';x.type='button';x.setAttribute('aria-label','Fechar');x.innerHTML='&times;';
    card.appendChild(x);
    if(pick.image){var im=document.createElement('img');im.className='fxpromo-img';im.src=pick.image;im.alt='';im.loading='lazy';card.appendChild(im);}
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
