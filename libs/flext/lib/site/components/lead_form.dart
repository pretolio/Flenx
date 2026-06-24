import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Formulário de captura de leads (nome, e-mail, mensagem). Envia via POST
/// (HTML puro, sem JS) para [action]. Mostra um agradecimento quando [submitted].
/// Campos e textos são personalizáveis.
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

  @override
  Component build(BuildContext context) {
    if (submitted) {
      return div(classes: 'lead-success', [
        div(classes: 'lead-check', [.text('✓')]),
        h3([.text('Recebemos seu contato!')]),
        p([.text('Em breve a equipe Flext retorna no seu e-mail.')]),
      ]);
    }
    return form(
      [
        div(classes: 'lead-row', [
          _field(id: 'lead-name', name: 'name', label: 'Nome', type: 'text', placeholder: 'Seu nome'),
          _field(id: 'lead-email', name: 'email', label: 'E-mail', type: 'email', placeholder: 'voce@email.com'),
        ]),
        label([.text('Mensagem')], htmlFor: 'lead-msg', classes: 'fld-label'),
        textarea([], attributes: {
          'id': 'lead-msg',
          'name': 'message',
          'rows': '4',
          'placeholder': 'Como podemos ajudar? (opcional)',
          'class': 'fld',
        }),
        button([.text(submitLabel)],
            classes: 'lead-submit', attributes: {'type': 'submit'}),
      ],
      action: action,
      attributes: const {'method': 'post'},
      classes: 'lead-form',
    );
  }

  Component _field({
    required String id,
    required String name,
    required String label,
    required String type,
    required String placeholder,
  }) {
    return div(classes: 'fld-group', [
      Component.element(tag: 'label', attributes: {'for': id, 'class': 'fld-label'}, children: [.text(label)]),
      Component.element(tag: 'input', attributes: {
        'id': id,
        'name': name,
        'type': type,
        'placeholder': placeholder,
        'required': 'required',
        'class': 'fld',
      }),
    ]);
  }
}
