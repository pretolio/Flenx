import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../flenx_palette.dart';

/// Página de redirecionamento (client-side) — leva o visitante a [to] na hora
/// (meta refresh + `location.replace`), com um link de fallback. Ideal para
/// links curtos/de campanha (ex.: `/wpp` → WhatsApp). Só-Dart.
class FlenxRedirect extends StatelessComponent {
  const FlenxRedirect(
    this.to, {
    this.message = 'Redirecionando…',
    this.linkLabel = 'Clique aqui se não for redirecionado',
    this.accent = FlenxPalette.primary,
    super.key,
  });

  final String to;
  final String message;
  final String linkLabel;
  final String accent;

  String get _jsTo => "'${to.replaceAll(r'\', r'\\').replaceAll("'", r"\'")}'";

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      Component.element(tag: 'meta', attributes: {'http-equiv': 'refresh', 'content': '0; url=$to'}, children: const []),
      Component.element(tag: 'script', children: [RawText('location.replace($_jsTo);')]),
      div(
        styles: Styles(raw: {
          'min-height': '60vh',
          'display': 'flex',
          'flex-direction': 'column',
          'align-items': 'center',
          'justify-content': 'center',
          'gap': '14px',
          'padding': '40px 24px',
          'font-family': "system-ui,-apple-system,'Segoe UI',sans-serif",
          'color': FlenxPalette.ink,
          'text-align': 'center',
        }),
        [
          p(styles: Styles(raw: {'margin': '0', 'font-size': '1.05rem', 'font-weight': '600'}), [Component.text(message)]),
          Component.element(
            tag: 'a',
            attributes: {'href': to, 'rel': 'noopener'},
            styles: Styles(raw: {'color': FlenxPalette.contrastOnLight(accent), 'font-weight': '700', 'text-decoration': 'none'}),
            children: [Component.text(linkLabel)],
          ),
        ],
      ),
    ]);
  }
}
