import 'package:flext/flext.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Seção de captura de leads: benefícios à esquerda, formulário à direita.
/// Montada com o kit Dart (sem HTML/CSS na mão).
class LeadSection extends StatelessComponent {
  const LeadSection({required this.action, this.submitted = false, super.key});

  final String action;
  final bool submitted;

  static const _benefits = [
    'Setup pronto: SSR + SEO + blog',
    'Suporte da comunidade',
    'Open source, MIT',
  ];

  @override
  Component build(BuildContext context) {
    return FlextSection(
      id: 'contato',
      child: FlextRow(
        gap: 40,
        wrap: true,
        cross: FlextAlign.start,
        main: FlextAlign.spaceBetween,
        [
          FlextColumn(
            gap: 14,
            maxWidthPx: 460,
            [
              const FlextText('Fale com a gente',
                  color: FlextPalette.primary, weight: 700),
              const FlextHeading('Quer usar o Flext no seu projeto?'),
              const FlextText(
                  'Deixe seu contato e receba novidades, exemplos e ajuda '
                  'para começar. Sem spam.',
                  color: FlextPalette.muted,
                  lineHeight: 1.6),
              FlextColumn(
                gap: 8,
                [
                  for (final b in _benefits)
                    FlextRow(gap: 8, [const FlextText('✅'), FlextText(b)]),
                ],
              ),
            ],
          ),
          div(
            styles: Styles(raw: {'flex': '1 1 360px', 'max-width': '460px'}),
            [
              FlextCard(
                LeadForm(action: action, submitted: submitted),
                padding: 24,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
