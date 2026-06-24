import 'package:flext/flext.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Seção de captura de leads: benefícios à esquerda, formulário à direita.
class LeadSection extends StatelessComponent {
  const LeadSection({required this.action, this.submitted = false, super.key});

  final String action;
  final bool submitted;

  @override
  Component build(BuildContext context) {
    return section(classes: 'section', id: 'contato', [
      div(classes: 'container', [
        div(classes: 'lead-grid', [
          div([
            p(classes: 'eyebrow', [.text('Fale com a gente')]),
            h2(classes: 'title', [.text('Quer usar o Flext no seu projeto?')]),
            p(classes: 'lead', [
              .text('Deixe seu contato e receba novidades, exemplos e ajuda '
                  'para começar. Sem spam.'),
            ]),
            ul(classes: 'lead-list', [
              li([.text('✅ '), span([.text('Setup pronto: SSR + SEO + blog')])]),
              li([.text('✅ '), span([.text('Suporte da comunidade')])]),
              li([.text('✅ '), span([.text('Open source, MIT')])]),
            ]),
          ]),
          div(classes: 'lead-card', [
            LeadForm(action: action, submitted: submitted),
          ]),
        ]),
      ]),
    ]);
  }
}
