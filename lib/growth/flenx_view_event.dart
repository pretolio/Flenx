import 'package:jaspr/dom.dart' show RawText;
import 'package:jaspr/jaspr.dart';

import 'flenx_events.dart';

/// Dispara um evento de `flenx.track` no carregamento da página — drop-in para
/// páginas de serviço/conteúdo (ex.: `ViewContent`). Configurável: [event] e
/// [params]. Sem rastreamento configurado é no-op (o runtime `flenx` enfileira
/// e respeita o consentimento).
///
/// ```dart
/// FlenxViewEvent(params: {'content_name': 'Logística Hospitalar'})
/// ```
class FlenxViewEvent extends StatelessComponent {
  const FlenxViewEvent({
    this.event = FlenxEvent.viewContent,
    this.params = const {},
    super.key,
  });

  final String event;
  final Map<String, String> params;

  @override
  Component build(BuildContext context) {
    final p = params.entries.map((e) => "'${e.key}':'${e.value}'").join(',');
    return Component.element(tag: 'script', children: [
      RawText("if(window.flenx)flenx.track('$event',{$p});"),
    ]);
  }
}
