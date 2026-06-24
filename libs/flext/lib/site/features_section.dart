import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'models/feature.dart';

/// Seção de recursos — grade de cards (ícone, título, descrição). Customizável
/// via a lista de [features].
class FeaturesSection extends StatelessComponent {
  const FeaturesSection({required this.features, super.key});

  final List<Feature> features;

  @override
  Component build(BuildContext context) {
    return section(classes: 'section', id: 'recursos', [
      div(classes: 'container', [
        p(classes: 'eyebrow center', [.text('Recursos')]),
        h2(classes: 'title center', [.text('Tudo que um site moderno precisa')]),
        p(classes: 'lead center', [
          .text('Pré-configurado e pronto para produção — e 100% personalizável.'),
        ]),
        div(classes: 'grid', styles: Styles(margin: Margin.only(top: 40.px)), [
          for (final f in features)
            div(classes: 'card', [
              div(classes: 'ico', [.text(f.icon)]),
              h3([.text(f.title)]),
              p([.text(f.description)]),
            ]),
        ]),
      ]),
    ]);
  }
}
