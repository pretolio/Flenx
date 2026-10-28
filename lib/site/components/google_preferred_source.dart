import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../growth/flenx_events.dart';

/// Botão "Adicione o <veículo> como fonte preferencial no Google". Abre o
/// popup do Google para o leitor marcar o site como fonte preferida nas buscas.
/// Identifique o veículo por [publicationId] (Google News Publisher Center) ou
/// por [domain] (ex.: `tribunademinas.com.br`); se vier os dois, vale o ID.
///
/// ```dart
/// GooglePreferredSource(name: 'Tribuna de Minas', domain: 'tribunademinas.com.br')
/// GooglePreferredSource(name: 'Tribuna de Minas', publicationId: 'CAowxxxx')
/// ```
class GooglePreferredSource extends StatelessComponent {
  const GooglePreferredSource({
    required this.name,
    this.publicationId,
    this.domain,
    this.lang = 'pt-BR',
    this.trackEvent,
    super.key,
  }) : assert(
         publicationId != null || domain != null,
         'Informe publicationId ou domain.',
       );

  /// Nome exibido no botão.
  final String name;

  /// ID da publicação no Google News (`publication_id`).
  final String? publicationId;

  /// Domínio do site, sem `https://` (ex.: `meusite.com.br`).
  final String? domain;

  final String lang;

  /// Evento de `flenx.track` no clique. Nulo = não rastreia.
  final String? trackEvent;

  /// URL final do popup.
  String get url {
    final id = publicationId?.trim();
    if (id != null && id.isNotEmpty) {
      return 'https://news.google.com/swg/ui/v1/addpreferredsource'
          '?publication_id=${Uri.encodeComponent(id)}'
          '&hl=${Uri.encodeComponent(lang)}';
    }
    final host = domain!
        .trim()
        .replaceFirst(RegExp(r'^https?://'), '')
        .replaceFirst(RegExp(r'/.*$'), '');
    return 'https://www.google.com/preferences/source'
        '?q=${Uri.encodeComponent(host)}&hl=${Uri.encodeComponent(lang)}';
  }

  static const _googleG =
      '<svg width="22" height="22" viewBox="0 0 24 24" aria-hidden="true">'
      '<path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>'
      '<path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>'
      '<path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.06H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.94l2.85-2.22.81-.63z"/>'
      '<path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.06l3.66 2.84c.87-2.6 3.3-4.52 6.16-4.52z"/>'
      '</svg>';

  @override
  Component build(BuildContext context) {
    final href = url;
    return a(
      [
        span(
          styles: Styles(raw: {'display': 'inline-flex', 'flex': 'none'}),
          [RawText(_googleG)],
        ),
        span(
          styles: Styles(
            raw: {'font-size': '13px', 'font-weight': '500', 'line-height': '1.25'},
          ),
          [
            .text('Adicione o '),
            strong([.text(name)]),
            .text(' como fonte preferencial no Google'),
          ],
        ),
      ],
      href: href,
      target: Target.blank,
      attributes: {
        'rel': 'noopener noreferrer',
        'aria-label': 'Adicione $name como fonte preferencial no Google',
        'onclick':
            "${trackEvent != null ? flenxTrackJs(trackEvent!) : ''}"
            "window.open(this.href,'AddPreferredSource','width=500,height=640');"
            'return false;',
      },
      styles: Styles(
        raw: {
          'display': 'inline-flex',
          'align-items': 'center',
          'gap': '10px',
          'max-width': '260px',
          'border': '1px solid #dadce0',
          'border-radius': '16px',
          'padding': '8px 14px',
          'text-decoration': 'none',
          'color': '#3c4043',
          'background': '#fff',
          'box-shadow': '0 1px 3px rgba(0,0,0,.08)',
        },
      ),
    );
  }
}
