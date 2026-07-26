/// Camada de *growth*/omnipresença do Flenx: rastreamento (pixels/analytics),
/// eventos e consentimento — tudo **config-driven**, genérico para QUALQUER
/// site/projeto. Um provedor é injetado só se o projeto passar seu ID.
library;

/// Contrato de um provedor de rastreamento. Cada provedor sabe emitir:
/// - [headHtml]: JS de inicialização para o `<head>`;
/// - [trackFn]: uma função JS `function(ev,p){...}` que dispara um evento no
///   SDK do provedor (chamada pelo dispatcher `flenx.track`);
/// - [noscriptHtml]: fallback opcional (`<noscript>`).
///
/// [consentMode] = respeita o Google Consent Mode (pode inicializar de
/// imediato, pois a própria plataforma segura os dados até o consentimento).
/// Provedores sem consent mode só inicializam APÓS o aceite (LGPD).
///
/// Para um provedor não coberto por [FlenxTracking], use [CustomPixel] — a lib
/// não precisa ser alterada.
abstract class TrackingProvider {
  const TrackingProvider();

  /// Identificador curto e único (ex.: `ga4`, `meta`).
  String get id;

  /// Respeita o Google Consent Mode (init imediato). Padrão: não.
  bool get consentMode => false;

  /// ID usado no loader externo do gtag (só provedores Google retornam algo).
  String? get gtagLoaderId => null;

  /// Snippet JS de inicialização (sem a tag `<script>`).
  String headHtml();

  /// Função JS `function(ev,p){...}` chamada a cada evento rastreado.
  String trackFn();

  /// HTML de fallback para `<noscript>` (vazio = nenhum).
  String noscriptHtml() => '';
}

/// Provedor genérico: cole o snippet do fornecedor e pronto — cobre Taboola,
/// Outbrain, Pinterest, TikTok, Hotjar, Clarity ou qualquer pixel futuro sem
/// alterar a lib.
class CustomPixel extends TrackingProvider {
  const CustomPixel({
    required this.id,
    required String head,
    String track = 'function(ev,p){}',
    this.consentMode = false,
    String noscript = '',
  })  : _head = head,
        _track = track,
        _noscript = noscript;

  @override
  final String id;
  @override
  final bool consentMode;
  final String _head;
  final String _track;
  final String _noscript;

  @override
  String headHtml() => _head;
  @override
  String trackFn() => _track;
  @override
  String noscriptHtml() => _noscript;
}
