import 'package:jaspr/dom.dart' show script, RawText;
import 'package:jaspr/jaspr.dart';

import 'tracking_provider.dart';

/// Configuração de rastreamento/omnipresença do site. Genérica: passe só os
/// provedores que o projeto usa (nenhum é fixo). O dispatcher `flenx.track`
/// distribui um evento para TODOS os provedores de uma vez.
///
/// ```dart
/// FlenxTracking(providers: [
///   Ga4('G-XXXX'),
///   MetaPixel('123'),
///   GoogleAds('AW-1', conversions: {'Lead':'AW-1/abc'}),
/// ])
/// ```
class FlenxTracking {
  const FlenxTracking({required this.providers});

  final List<TrackingProvider> providers;

  bool get isEmpty => providers.isEmpty;

  /// Runtime `window.flenx` — fila de eventos + gating por consentimento.
  static const _runtime = '''
window.flenx=window.flenx||{};flenx._providers=flenx._providers||[];flenx._pending=flenx._pending||[];flenx._q=flenx._q||[];
flenx.consent=(function(){try{return localStorage.getItem('flenx_consent')==='granted'}catch(e){return false}})();
flenx.track=function(ev,p){flenx._q.push([ev,p||{}]);flenx._flush()};
flenx._flush=function(){if(!flenx.consent)return;while(flenx._q.length){var e=flenx._q.shift();for(var i=0;i<flenx._providers.length;i++){try{flenx._providers[i](e[0],e[1])}catch(_){}}}};
flenx._runPending=function(){for(var i=0;i<flenx._pending.length;i++){try{flenx._pending[i]()}catch(_){}}flenx._pending=[]};
flenx.grantConsent=function(){flenx.consent=true;try{localStorage.setItem('flenx_consent','granted')}catch(e){}if(window.gtag)gtag('consent','update',{ad_storage:'granted',analytics_storage:'granted',ad_user_data:'granted',ad_personalization:'granted'});flenx._runPending();flenx._flush()};
flenx.denyConsent=function(){flenx.consent=false;try{localStorage.setItem('flenx_consent','denied')}catch(e){}};
''';

  /// Componentes para o `<head>`. [requireConsent] = há um banner LGPD, então
  /// provedores sem consent mode só inicializam depois do aceite.
  List<Component> headComponents({required bool requireConsent}) {
    if (providers.isEmpty) return const [];
    final buf = StringBuffer();
    final gtagId = providers
        .map((p) => p.gtagLoaderId)
        .firstWhere((id) => id != null, orElse: () => null);

    // Base gtag + Consent Mode (default negado quando há banner LGPD).
    buf.write('window.dataLayer=window.dataLayer||[];function gtag(){dataLayer.push(arguments)}');
    if (gtagId != null) {
      buf.write("gtag('js',new Date());");
      if (requireConsent) {
        buf.write("gtag('consent','default',{ad_storage:'denied',analytics_storage:'denied',ad_user_data:'denied',ad_personalization:'denied',wait_for_update:500});");
      }
    }

    buf.write(_runtime);

    // Registra cada provedor: função de track + init (imediato ou adiado).
    for (final p in providers) {
      buf.write('flenx._providers.push(${p.trackFn()});');
      final init = p.headHtml();
      if (init.isNotEmpty) {
        if (p.consentMode || !requireConsent) {
          buf.write(init);
        } else {
          buf.write('flenx._pending.push(function(){$init});');
        }
      }
    }

    // Sem banner → consentimento implícito; roda tudo já.
    if (!requireConsent) buf.write('flenx.consent=true;');
    // Se já havia aceite salvo, roda os inits adiados e esvazia a fila.
    buf.write('if(flenx.consent){flenx._runPending();flenx._flush()}');

    final comps = <Component>[
      Component.element(tag: 'script', children: [RawText(buf.toString())]),
    ];
    if (gtagId != null) {
      comps.add(script(src: 'https://www.googletagmanager.com/gtag/js?id=$gtagId', async: true));
    }
    for (final p in providers) {
      final ns = p.noscriptHtml();
      if (ns.isNotEmpty) {
        comps.add(Component.element(tag: 'noscript', children: [RawText(ns)]));
      }
    }
    return comps;
  }
}
