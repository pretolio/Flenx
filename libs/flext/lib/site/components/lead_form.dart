import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../flext_palette.dart';

/// Formulário de captura de leads (nome, e-mail, mensagem). Envia via POST
/// (HTML puro, sem JS) para [action]. Estilizado inline (sem classes CSS);
/// campos e textos personalizáveis. Mostra agradecimento quando [submitted].
class LeadForm extends StatelessComponent {
  const LeadForm({
    required this.action,
    this.submitted = false,
    this.submitLabel = 'Quero saber mais',
    super.key,
  });

  final String action;
  final bool submitted;
  final String submitLabel;

  static const _fld = {
    'width': '100%',
    'box-sizing': 'border-box',
    'padding': '12px 14px',
    'border': '1px solid ${FlextPalette.border}',
    'border-radius': '10px',
    'font-size': '15px',
    'font-family': 'inherit',
  };

  Component _label(String text) => Component.element(
        tag: 'label',
        styles: Styles(raw: {
          'display': 'block',
          'font-weight': '600',
          'font-size': '14px',
          'margin-bottom': '6px',
          'color': FlextPalette.ink,
        }),
        children: [.text(text)],
      );

  Component _field(String name, String label, String type, String hint) => div(
        styles: Styles(raw: {'flex': '1 1 200px'}),
        [
          _label(label),
          Component.element(tag: 'input', attributes: {
            'name': name,
            'type': type,
            'placeholder': hint,
            'required': 'required',
          }, styles: Styles(raw: _fld)),
        ],
      );

  @override
  Component build(BuildContext context) {
    if (submitted) {
      return div(
        styles: Styles(raw: {'text-align': 'center', 'padding': '12px 0'}),
        [
          div(
              styles: Styles(raw: {
                'width': '52px',
                'height': '52px',
                'margin': '0 auto 12px',
                'border-radius': '50%',
                'background': FlextPalette.primary,
                'color': '#fff',
                'display': 'flex',
                'align-items': 'center',
                'justify-content': 'center',
                'font-size': '26px',
              }),
              [.text('✓')]),
          Component.element(
              tag: 'h3',
              styles: Styles(raw: {'margin': '0 0 4px'}),
              children: [.text('Recebemos seu contato!')]),
          p(
              styles: Styles(raw: {'margin': '0', 'color': FlextPalette.muted}),
              [.text('Em breve a equipe retorna no seu e-mail.')]),
        ],
      );
    }

    return form(
      [
        div(
          styles: Styles(raw: {
            'display': 'flex',
            'gap': '12px',
            'flex-wrap': 'wrap',
            'margin-bottom': '14px',
          }),
          [
            _field('name', 'Nome', 'text', 'Seu nome'),
            _field('email', 'E-mail', 'email', 'voce@email.com'),
          ],
        ),
        _label('Mensagem'),
        textarea(
          const [],
          attributes: {
            'name': 'message',
            'rows': '4',
            'placeholder': 'Como podemos ajudar? (opcional)',
          },
          styles: Styles(raw: {..._fld, 'margin-bottom': '14px', 'resize': 'vertical'}),
        ),
        button(
          [.text(submitLabel)],
          attributes: const {'type': 'submit'},
          styles: Styles(raw: {
            'width': '100%',
            'padding': '14px',
            'border': '0',
            'border-radius': '10px',
            'background': FlextPalette.primary,
            'color': '#fff',
            'font-weight': '700',
            'font-size': '15px',
            'cursor': 'pointer',
          }),
        ),
      ],
      action: action,
      attributes: const {'method': 'post'},
    );
  }
}
