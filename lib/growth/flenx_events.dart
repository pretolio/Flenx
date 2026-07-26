/// Nomes de evento padrão (compatíveis com Meta Pixel e GA4) e helper para
/// disparar `flenx.track` a partir de qualquer componente (onclick/onsubmit).
abstract final class FlenxEvent {
  static const pageView = 'PageView';
  static const lead = 'Lead';
  static const contact = 'Contact';
  static const viewContent = 'ViewContent';
  static const completeRegistration = 'CompleteRegistration';
  static const schedule = 'Schedule';
  static const search = 'Search';
}

/// Trecho JS para atributos `onclick`/`onsubmit`: dispara o evento em TODOS os
/// pixels de uma vez, sem quebrar a navegação. Ex.:
/// `attributes: {'onclick': flenxTrackJs(FlenxEvent.contact)}`.
String flenxTrackJs(String event, {Map<String, String> params = const {}}) {
  final p = params.entries.map((e) => "'${e.key}':'${e.value}'").join(',');
  return "if(window.flenx)flenx.track('$event',{$p});";
}
