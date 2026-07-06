import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../flenx_palette.dart';

/// Player de áudio — reproduz arquivos locais ou streams (rádio online).
/// Play/pause controlado por JS; sem bibliotecas externas.
///
/// **Arquivo local ou remoto:**
/// ```dart
/// FlenxAudioPlayer('/assets/musica.mp3', title: 'Nome da Faixa', subtitle: 'Artista')
/// ```
///
/// **Rádio online:**
/// ```dart
/// FlenxAudioPlayer(
///   'https://stream.exemplo.com/radio',
///   title: 'Rádio Exemplo',
///   subtitle: 'Ao vivo • Pop & Rock',
///   isRadio: true,
///   accentColor: '#b5602f',
/// )
/// ```
class FlenxAudioPlayer extends StatelessComponent {
  const FlenxAudioPlayer(
    this.src, {
    this.title,
    this.subtitle,
    this.autoplay = false,
    this.loop = false,
    this.isRadio = false,
    this.accentColor = FlenxPalette.primary,
    this.background = '#ffffff',
    super.key,
  });

  /// URL do áudio — caminho local (`/assets/music.mp3`) ou stream remoto.
  final String src;

  /// Nome da faixa ou da rádio.
  final String? title;

  /// Artista, gênero ou descrição.
  final String? subtitle;

  /// Inicia a reprodução automaticamente (requer interação do usuário em alguns browsers).
  final bool autoplay;

  /// Repete a faixa ao terminar.
  final bool loop;

  /// Modo rádio — oculta a barra de progresso e exibe indicador LIVE.
  final bool isRadio;

  /// Cor do botão play/pause e da barra de progresso.
  final String accentColor;

  /// Cor de fundo do card do player.
  final String background;

  String get _id => 'fap${src.hashCode.abs().toRadixString(16)}';

  static const _css = r'''
.fap{display:flex;align-items:center;gap:14px;padding:16px 20px;border-radius:14px;border:1px solid #e2e8f0;font-family:inherit;user-select:none}
.fap-btn{width:46px;height:46px;border-radius:50%;border:none;cursor:pointer;display:inline-flex;align-items:center;justify-content:center;flex-shrink:0;transition:transform .15s,filter .15s;color:#fff;font-size:17px;line-height:1}
.fap-btn:hover{transform:scale(1.08);filter:brightness(1.12)}
.fap-info{flex:1;min-width:0}
.fap-title{font-weight:700;font-size:15px;color:#0f172a;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.fap-sub{font-size:13px;color:#64748b;margin-top:2px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.fap-bw{margin-top:10px;height:5px;background:#e2e8f0;border-radius:4px;cursor:pointer;position:relative;overflow:hidden}
.fap-bar{height:100%;border-radius:4px;width:0%;transition:width .25s linear;pointer-events:none}
.fap-times{display:flex;justify-content:space-between;margin-top:4px;font-size:11px;color:#94a3b8;font-variant-numeric:tabular-nums}
.fap-live{display:inline-flex;align-items:center;gap:5px;font-size:11px;font-weight:700;letter-spacing:.06em;padding:3px 9px;border-radius:20px;color:#fff;flex-shrink:0}
.fap-dot{width:7px;height:7px;border-radius:50%;background:#fff;animation:fap-blink 1.2s ease-in-out infinite}
@keyframes fap-blink{0%,100%{opacity:1}50%{opacity:.25}}
''';

  String get _accentCss =>
      '.fap-btn-$_id{background:$accentColor}'
      '.fap-bar-$_id{background:$accentColor}'
      '.fap-live-$_id{background:$accentColor}';

  String get _js =>
      '''
(function(){
  var id='$_id';
  var audio=document.getElementById(id+'-a');
  var btn=document.getElementById(id+'-btn');
  var bar=document.getElementById(id+'-bar');
  var timeEl=document.getElementById(id+'-t');
  var durEl=document.getElementById(id+'-d');
  var bw=document.getElementById(id+'-bw');
  function fmt(s){if(!isFinite(s)||s<0)return'--:--';var m=Math.floor(s/60);var sc=Math.floor(s%60);return m+':'+(sc<10?'0':'')+sc;}
  btn.onclick=function(){try{audio.paused?audio.play():audio.pause();}catch(e){}};
  audio.onplay=function(){btn.textContent='⏸';};
  audio.onpause=function(){btn.textContent='▶';};
  audio.onerror=function(){btn.title='Erro ao carregar áudio';};
  audio.ontimeupdate=function(){
    if(audio.duration&&isFinite(audio.duration)){
      if(bar)bar.style.width=(audio.currentTime/audio.duration*100)+'%';
      if(timeEl)timeEl.textContent=fmt(audio.currentTime);
      if(durEl)durEl.textContent=fmt(audio.duration);
    }
  };
  audio.onloadedmetadata=function(){if(durEl&&isFinite(audio.duration))durEl.textContent=fmt(audio.duration);};
  if(bw)bw.onclick=function(e){
    if(!audio.duration||!isFinite(audio.duration))return;
    var r=bw.getBoundingClientRect();
    audio.currentTime=((e.clientX-r.left)/r.width)*audio.duration;
    e.stopPropagation();
  };
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
      classes: 'fap-btn fap-btn-$_id',
      attributes: {'type': 'button', 'aria-label': 'Play'},
      children: [.text('▶')],
    );

    final liveChip = isRadio
        ? span(classes: 'fap-live fap-live-$_id', [
            span(classes: 'fap-dot', []),
            .text('AO VIVO'),
          ])
        : null;

    final progressArea = isRadio
        ? null
        : div(classes: 'fap-info-progress', [
            div(id: '$_id-bw', classes: 'fap-bw', [
              div(id: '$_id-bar', classes: 'fap-bar fap-bar-$_id', []),
            ]),
            div(classes: 'fap-times', [
              span(id: '$_id-t', [.text('0:00')]),
              span(id: '$_id-d', [.text('--:--')]),
            ]),
          ]);

    final info = div(classes: 'fap-info', [
      if (title != null || liveChip != null)
        div(
          styles: Styles(
            raw: {
              'display': 'flex',
              'align-items': 'center',
              'gap': '8px',
              'min-width': '0',
            },
          ),
          [
            if (title != null) span(classes: 'fap-title', [.text(title!)]),
            if (liveChip != null) liveChip,
          ],
        ),
      if (subtitle != null) div(classes: 'fap-sub', [.text(subtitle!)]),
      if (progressArea != null) progressArea,
    ]);

    return span(styles: Styles(raw: {'display': 'contents'}), [
      Component.element(tag: 'style', children: [RawText('$_css$_accentCss')]),
      div(classes: 'fap', styles: Styles(raw: {'background': background}), [
        audioEl,
        playBtn,
        info,
      ]),
      // Script DEPOIS do div para que os elementos já estejam no DOM
      Component.element(tag: 'script', children: [RawText(_js)]),
    ]);
  }
}
