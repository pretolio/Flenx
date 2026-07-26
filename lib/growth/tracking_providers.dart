import 'tracking_provider.dart';

/// Google Analytics 4. Respeita Consent Mode → init imediato.
class Ga4 extends TrackingProvider {
  const Ga4(this.measurementId);
  final String measurementId; // G-XXXXXXX
  @override
  String get id => 'ga4';
  @override
  bool get consentMode => true;
  @override
  String? get gtagLoaderId => measurementId;
  @override
  String headHtml() => "gtag('config','$measurementId');";
  @override
  String trackFn() => "function(ev,p){if(window.gtag)gtag('event',ev,p||{});}";
}

/// Google Ads. [conversions] mapeia evento → `AW-XXX/label` (dispara conversão).
class GoogleAds extends TrackingProvider {
  const GoogleAds(this.conversionId, {this.conversions = const {}});
  final String conversionId; // AW-XXXXXXXXX
  final Map<String, String> conversions;
  @override
  String get id => 'gads';
  @override
  bool get consentMode => true;
  @override
  String? get gtagLoaderId => conversionId;
  @override
  String headHtml() => "gtag('config','$conversionId');";
  @override
  String trackFn() {
    final m = conversions.entries.map((e) => "'${e.key}':'${e.value}'").join(',');
    return "function(ev,p){var m={$m};if(window.gtag&&m[ev])gtag('event','conversion',{send_to:m[ev]});}";
  }
}

/// Meta Pixel (Facebook/Instagram). Sem consent mode → init após o aceite.
class MetaPixel extends TrackingProvider {
  const MetaPixel(this.pixelId, {this.standardEvents = _std});
  static const _std = [
    'PageView', 'Lead', 'Contact', 'ViewContent', 'CompleteRegistration',
    'Purchase', 'Subscribe', 'Schedule', 'SubmitApplication'
  ];
  final String pixelId;
  final List<String> standardEvents;
  @override
  String get id => 'meta';
  @override
  String headHtml() =>
      "!function(f,b,e,v,n,t,s){if(f.fbq)return;n=f.fbq=function(){n.callMethod?n.callMethod.apply(n,arguments):n.queue.push(arguments)};if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';n.queue=[];t=b.createElement(e);t.async=!0;t.src=v;s=b.getElementsByTagName(e)[0];s.parentNode.insertBefore(t,s)}(window,document,'script','https://connect.facebook.net/en_US/fbevents.js');fbq('init','$pixelId');fbq('track','PageView');";
  @override
  String trackFn() {
    final std = standardEvents.map((e) => "'$e'").join(',');
    return "function(ev,p){if(!window.fbq)return;var s=[$std];fbq(s.indexOf(ev)>=0?'track':'trackCustom',ev,p||{});}";
  }
  @override
  String noscriptHtml() =>
      '<img height="1" width="1" style="display:none" alt="" src="https://www.facebook.com/tr?id=$pixelId&ev=PageView&noscript=1"/>';
}

/// Microsoft Advertising (Bing UET). Bom para decisores B2B (Edge/Outlook).
class BingUet extends TrackingProvider {
  const BingUet(this.tagId);
  final String tagId;
  @override
  String get id => 'bing';
  @override
  String headHtml() =>
      "(function(w,d,t,r,u){var f,n,i;w[u]=w[u]||[],f=function(){var o={ti:'$tagId',enableAutoSpaTracking:true};o.q=w[u],w[u]=new UET(o),w[u].push('pageLoad')},n=d.createElement(t),n.src=r,n.async=1,n.onload=n.onreadystatechange=function(){var s=this.readyState;s&&s!=='loaded'&&s!=='complete'||(f(),n.onload=n.onreadystatechange=null)},i=d.getElementsByTagName(t)[0],i.parentNode.insertBefore(n,i)})(window,document,'script','//bat.bing.com/bat.js','uetq');";
  @override
  String trackFn() =>
      "function(ev,p){if(window.uetq)window.uetq.push('event',ev,p||{});}";
}

/// LinkedIn Insight Tag. [conversions] mapeia evento → conversion id numérico.
class LinkedInInsight extends TrackingProvider {
  const LinkedInInsight(this.partnerId, {this.conversions = const {}});
  final String partnerId;
  final Map<String, String> conversions;
  @override
  String get id => 'linkedin';
  @override
  String headHtml() =>
      "window._linkedin_partner_id='$partnerId';window._linkedin_data_partner_ids=window._linkedin_data_partner_ids||[];window._linkedin_data_partner_ids.push('$partnerId');(function(l){if(!l){window.lintrk=function(a,b){window.lintrk.q.push([a,b])};window.lintrk.q=[]}var s=document.getElementsByTagName('script')[0];var b=document.createElement('script');b.type='text/javascript';b.async=true;b.src='https://snap.licdn.com/li.lms-analytics/insight.min.js';s.parentNode.insertBefore(b,s)})(window.lintrk);";
  @override
  String trackFn() {
    final m = conversions.entries.map((e) => "'${e.key}':'${e.value}'").join(',');
    return "function(ev,p){var m={$m};if(window.lintrk&&m[ev])lintrk('track',{conversion_id:m[ev]});}";
  }
  @override
  String noscriptHtml() =>
      '<img height="1" width="1" style="display:none" alt="" src="https://px.ads.linkedin.com/collect/?pid=$partnerId&fmt=gif"/>';
}

/// Push web via **Firebase Cloud Messaging (FCM)**. [config] é o objeto JS de
/// configuração do Firebase (ex.: `"{apiKey:'..',projectId:'..',appId:'..'}"`),
/// [vapidKey] é a chave Web Push do projeto e [tokenEndpoint] (opcional) recebe
/// o token via POST para o backend salvar. Requer o worker
/// `firebase-messaging-sw.js` na raiz pública do site (com a mesma config).
/// Sem consent mode → pede permissão e registra o token só após o aceite.
class FirebasePush extends TrackingProvider {
  const FirebasePush({
    required this.config,
    required this.vapidKey,
    this.tokenEndpoint,
    this.sdkVersion = '10.12.2',
  });
  final String config;
  final String vapidKey;
  final String? tokenEndpoint;
  final String sdkVersion;
  @override
  String get id => 'firebase';
  @override
  String headHtml() {
    final base = 'https://www.gstatic.com/firebasejs/$sdkVersion';
    final send = tokenEndpoint == null
        ? ''
        : "if(t)fetch('$tokenEndpoint',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({token:t})});";
    return "var fa=document.createElement('script');fa.src='$base/firebase-app-compat.js';fa.onload=function(){var fm=document.createElement('script');fm.src='$base/firebase-messaging-compat.js';fm.onload=function(){try{firebase.initializeApp($config);var m=firebase.messaging();if(!('serviceWorker'in navigator))return;navigator.serviceWorker.register('/firebase-messaging-sw.js').then(function(reg){Notification.requestPermission().then(function(perm){if(perm!=='granted')return;m.getToken({vapidKey:'$vapidKey',serviceWorkerRegistration:reg}).then(function(t){$send})})})}catch(e){}};document.head.appendChild(fm)};document.head.appendChild(fa);";
  }
  @override
  String trackFn() => 'function(ev,p){}';
}
