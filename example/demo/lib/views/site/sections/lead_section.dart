import 'package:flenx/flenx.dart';

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
    return FlenxSection(
      id: 'contato',
      child: FlenxGrid(
        minItemWidth: 360,
        gap: 40,
        [
          FlenxColumn(
            gap: 14,
            [
              const FlenxText('Fale com a gente', color: FlenxPalette.primary, weight: 700),
              const FlenxHeading('Quer usar o Flenx no seu projeto?'),
              const FlenxText(
                'Deixe seu contato e receba novidades, exemplos e ajuda '
                'para começar. Sem spam.',
                color: FlenxPalette.muted,
                lineHeight: 1.6,
              ),
              FlenxColumn(
                gap: 8,
                [
                  for (final b in _benefits) FlenxRow(gap: 8, [const FlenxText('✅'), FlenxText(b)]),
                ],
              ),
            ],
          ),
          FlenxCard(
            LeadForm(action: action, submitted: submitted),
            padding: 24,
          ),
        ],
      ),
    );
  }
}
