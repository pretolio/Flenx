import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Embute uma URL qualquer (outro site, vídeo do YouTube, mapa, formulário…)
/// dentro do seu site, num `<iframe>` responsivo e seguro.
///
/// Exemplos:
/// ```dart
/// IframeEmbed('https://exemplo.com')                       // altura fixa (480px)
/// IframeEmbed('https://youtube.com/embed/ID', ratio: '16 / 9') // responsivo
/// IframeEmbed('https://site.com', height: 600, rounded: false)
/// ```
class IframeEmbed extends StatelessComponent {
  const IframeEmbed(
    this.url, {
    this.title = 'Conteúdo incorporado',
    this.ratio,
    this.height = 480,
    this.cssHeight,
    this.rounded = true,
    this.lazy = true,
    this.allowFullscreen = true,
    this.allow,
    this.sandbox,
    this.classes,
    super.key,
  });

  /// URL a carregar (pode ser outro site).
  final String url;

  /// Título acessível do quadro.
  final String title;

  /// Proporção responsiva (ex.: `'16 / 9'`, `'4 / 3'`). Se definido, ignora
  /// [height] e o iframe ocupa 100% da largura mantendo a proporção.
  final String? ratio;

  /// Altura fixa em px quando [ratio] e [cssHeight] são nulos.
  final int height;

  /// Altura em CSS puro (ex.: `'calc(100vh - 72px)'`). Tem prioridade sobre
  /// [height] quando definido. Ignorado quando [ratio] estiver definido.
  final String? cssHeight;

  /// Cantos arredondados.
  final bool rounded;

  /// Carregamento adiado (só carrega ao chegar perto da viewport).
  final bool lazy;

  /// Permite tela cheia (adiciona `fullscreen` ao `allow`).
  final bool allowFullscreen;

  /// Permissões extras (ex.: `'clipboard-write; geolocation; encrypted-media'`).
  final String? allow;

  /// `sandbox` do iframe. `null` = sem sandbox (carrega tudo); `''` = restrição
  /// máxima; ou tokens (ex.: `'allow-scripts allow-same-origin'`).
  final String? sandbox;

  /// Classes CSS aplicadas ao elemento externo.
  final String? classes;

  String? get _allow {
    final parts = [
      if (allowFullscreen) 'fullscreen',
      if (allow != null && allow!.isNotEmpty) allow!,
    ];
    return parts.isEmpty ? null : parts.join('; ');
  }

  @override
  Component build(BuildContext context) {
    final responsive = ratio != null;

    final frame = iframe(
      const [],
      src: url,
      loading: lazy ? MediaLoading.lazy : MediaLoading.eager,
      allow: _allow,
      sandbox: sandbox,
      classes: responsive ? null : classes,
      attributes: {'title': title},
      styles: Styles(
        raw: {
          'border': '0',
          if (rounded) 'border-radius': '12px',
          if (responsive) ...{
            'position': 'absolute',
            'inset': '0',
            'width': '100%',
            'height': '100%',
          } else ...{
            'display': 'block',
            'width': '100%',
            'height': cssHeight ?? '${height}px',
          },
        },
      ),
    );

    if (!responsive) return frame;

    // Wrapper que mantém a proporção (responsivo).
    return div(
      classes: classes,
      styles: Styles(
        raw: {'position': 'relative', 'width': '100%', 'aspect-ratio': ratio!},
      ),
      [frame],
    );
  }
}
