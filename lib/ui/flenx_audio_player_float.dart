import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../flenx_palette.dart';

/// Player de áudio flutuante — barra fixa no bottom da tela, persiste durante
/// o scroll. Ideal para rádio online ou trilha sonora do site.
///
/// **Rádio ao vivo:**
/// ```dart
/// FlenxAudioPlayerFloat(
///   'https://stream.minharadio.com.br/live',
///   title: 'Rádio Exemplo',
///   subtitle: 'Pop • Sertanejo • Ao vivo 24h',
///   isRadio: true,
///   accentColor: '#b5602f',
///   autoplay: false,
/// )
/// ```
///
/// **Faixa com progresso:**
/// ```dart
/// FlenxAudioPlayerFloat(
///   '/assets/podcast.mp3',
///   title: 'Episódio 42',
///   subtitle: 'Meu Podcast',
///   accentColor: '#b5602f',
/// )
/// ```
class FlenxAudioPlayerFloat extends StatelessComponent {
  const FlenxAudioPlayerFloat(
    this.src, {
    this.title,
    this.subtitle,
    this.autoplay = false,
    this.loop = false,
    this.isRadio = false,
    this.accentColor = FlenxPalette.primary,
    this.background = '#ffffff',
    this.initiallyVisible = true,
    super.key,
  });

  /// URL do áudio — caminho local ou stream remoto.
  final String src;

  final String? title;
  final String? subtitle;
  final bool autoplay;
  final bool loop;

  /// Modo rádio — oculta a barra de progresso e exibe indicador AO VIVO.
  final bool isRadio;

  final String accentColor;
  final String background;

  /// Se `false`, o player começa recolhido (oculto) e pode ser aberto via JS:
  /// `document.getElementById('{id}').classList.remove('fapfl-hidden')`.
  final bool initiallyVisible;

  String get _id => 'fapfl${src.hashCode.abs().toRadixString(16)}';

  static const _css = r'''
.fapfl{position:fixed;bottom:0;left:0;right:0;z-index:9999;display:flex;align-items:center;gap:12px;padding:12px 24px 12px;border-top:1px solid rgba(0,0,0,.08);box-shadow:0 -4px 24px rgba(0,0,0,.10);transition:transform .3s cubic-bezier(.4,0,.2,1);font-family:inherit}
.fapfl.fapfl-hidden{transform:translateY(110%)}
.fapfl-play{width:40px;height:40px;border-radius:50%;border:none;cursor:pointer;display:inline-flex;align-items:center;justify-content:center;flex-shrink:0;font-size:15px;color:#fff;transition:transform .15s,filter .15s}
.fapfl-play:hover{transform:scale(1.08);filter:brightness(1.12)}
.fapfl-meta{display:flex;flex-direction:column;min-width:0;flex-shrink:0;max-width:200px}
.fapfl-title{font-weight:700;font-size:14px;color:#0f172a;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.fapfl-sub{font-size:12px;color:#64748b;margin-top:1px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.fapfl-prog{flex:1;display:flex;align-items:center;gap:10px;min-width:0}
.fapfl-bw{flex:1;height:4px;background:#e2e8f0;border-radius:4px;cursor:pointer;position:relative;overflow:hidden;min-width:80px}
.fapfl-bar{height:100%;border-radius:4px;width:0%;transition:width .25s linear;pointer-events:none}
.fapfl-time{font-size:11px;color:#94a3b8;font-variant-numeric:tabular-nums;white-space:nowrap;flex-shrink:0}
.fapfl-live{display:inline-flex;align-items:center;gap:5px;font-size:11px;font-weight:700;letter-spacing:.06em;padding:3px 10px;border-radius:20px;color:#fff;flex-shrink:0}
.fapfl-dot{width:7px;height:7px;border-radius:50%;background:#fff;animation:fapfl-blink 1.2s ease-in-out infinite}
@keyframes fapfl-blink{0%,100%{opacity:1}50%{opacity:.25}}
.fapfl-close{width:32px;height:32px;border-radius:50%;border:none;background:rgba(0,0,0,.06);cursor:pointer;display:inline-flex;align-items:center;justify-content:center;flex-shrink:0;font-size:16px;color:#64748b;line-height:1;transition:background .15s}
.fapfl-close:hover{background:rgba(0,0,0,.12)}
@media(max-width:600px){.fapfl-prog{display:none}.fapfl-meta{max-width:calc(100vw - 160px)}}
''';

  String get _accentCss =>
      '.fapfl-play-$_id{background:$accentColor}'
      '.fapfl-bar-$_id{background:$accentColor}'
      '.fapfl-live-$_id{background:$accentColor}';

  String get _js => '''
(function(){
  var id='$_id';
  var root=document.getElementById(id);
  var audio=document.getElementById(id+'-a');
  var btn=document.getElementById(id+'-btn');
  var bar=document.getElementById(id+'-bar');
  var timeEl=document.getElementById(id+'-t');
  var bw=document.getElementById(id+'-bw');
  var closeBtn=document.getElementById(id+'-x');
  function fmt(s){if(!isFinite(s)||s<0)return'--:--';var m=Math.floor(s/60);var sc=Math.floor(s%60);return m+':'+(sc<10?'0':'')+sc;}
  btn.onclick=function(){try{audio.paused?audio.play():audio.pause();}catch(e){}};
  audio.onplay=function(){btn.textContent='⏸';};
  audio.onpause=function(){btn.textContent='▶';};
  audio.onerror=function(){if(timeEl)timeEl.textContent='erro';};
  audio.ontimeupdate=function(){
    if(audio.duration&&isFinite(audio.duration)){
      if(bar)bar.style.width=(audio.currentTime/audio.duration*100)+'%';
      if(timeEl)timeEl.textContent=fmt(audio.currentTime)+' / '+fmt(audio.duration);
    }
  };
  audio.onloadedmetadata=function(){if(timeEl&&isFinite(audio.duration))timeEl.textContent='0:00 / '+fmt(audio.duration);};
  if(bw)bw.onclick=function(e){
    if(!audio.duration||!isFinite(audio.duration))return;
    var r=bw.getBoundingClientRect();
    audio.currentTime=((e.clientX-r.left)/r.width)*audio.duration;
    e.stopPropagation();
  };
  if(closeBtn)closeBtn.onclick=function(){root.classList.add('fapfl-hidden');audio.pause();};
  if(${autoplay ? 'true' : 'false'}){try{audio.play();}catch(e){}}
})();
''';

  @override
  Component build(BuildContext context) {
    final audioEl = Component.element(
      tag: 'audio',
      id: '$_id-a',
      attributes: {
        'src': src,
        'preload': isRadio ? 'none' : 'metadata',
        if (loop) 'loop': '',
      },
      children: [],
    );

    final playBtn = Component.element(
      tag: 'button',
      id: '$_id-btn',
      classes: 'fapfl-play fapfl-play-$_id',
      attributes: {'type': 'button', 'aria-label': 'Play/Pause'},
      children: [.text('▶')],
    );

    final meta = div(classes: 'fapfl-meta', [
      if (title != null) div(classes: 'fapfl-title', [.text(title!)]),
      if (subtitle != null) div(classes: 'fapfl-sub', [.text(subtitle!)]),
    ]);

    final progress = isRadio
        ? span(classes: 'fapfl-live fapfl-live-$_id', [
            span(classes: 'fapfl-dot', []),
            .text('AO VIVO'),
          ])
        : div(classes: 'fapfl-prog', [
            div(id: '$_id-bw', classes: 'fapfl-bw', [
              div(id: '$_id-bar', classes: 'fapfl-bar fapfl-bar-$_id', []),
            ]),
            span(id: '$_id-t', classes: 'fapfl-time', [.text('0:00')]),
          ]);

    final closeBtn = Component.element(
      tag: 'button',
      id: '$_id-x',
      classes: 'fapfl-close',
      attributes: {'type': 'button', 'aria-label': 'Fechar player'},
      children: [.text('✕')],
    );

    final classes = initiallyVisible ? 'fapfl' : 'fapfl fapfl-hidden';

    return span(styles: Styles(raw: {'display': 'contents'}), [
      Component.element(tag: 'style', children: [RawText('$_css$_accentCss')]),
      div(
        id: _id,
        classes: classes,
        styles: Styles(raw: {'background': background}),
        [audioEl, playBtn, meta, progress, closeBtn],
      ),
      Component.element(tag: 'script', children: [RawText(_js)]),
    ]);
  }
}
