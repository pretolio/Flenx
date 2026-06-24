import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Seção "como funciona" — passos numerados.
class StepsSection extends StatelessComponent {
  const StepsSection({super.key});

  static const _steps = [
    ('Escreva uma vez', 'Seus widgets Flutter rodam no app e na web — mesmo código.'),
    ('Anote a rota', 'Com @FlextPage/@Ssr o build gera SSR, sitemap, robots e llms.txt.'),
    ('Publique', 'Conteúdo indexável por Google e por motores de IA, sem esforço.'),
  ];

  @override
  Component build(BuildContext context) {
    return section(classes: 'section', styles: Styles(backgroundColor: const Color('#f8fafc')), [
      div(classes: 'container', [
        p(classes: 'eyebrow center', [.text('Como funciona')]),
        h2(classes: 'title center', [.text('Do código ao SEO em 3 passos')]),
        div(classes: 'steps', styles: Styles(margin: Margin.only(top: 40.px)), [
          for (var i = 0; i < _steps.length; i++)
            div(classes: 'step', [
              div(classes: 'n', [.text('${i + 1}')]),
              h3([.text(_steps[i].$1)]),
              p(styles: Styles(color: const Color('#64748b'), margin: Margin.zero),
                  [.text(_steps[i].$2)]),
            ]),
        ]),
      ]),
    ]);
  }
}
