import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'commerce_models.dart';

/// Faixa de pílulas de preço ("A PARTIR DE R$ ...").
class FlenxPricePills extends StatelessComponent {
  const FlenxPricePills({required this.items, super.key});
  final List<FlenxPricePill> items;

  @override
  Component build(BuildContext context) {
    return div(classes: 'fxz-wrap', [
      div(classes: 'fxz-pills', [
        for (final p in items)
          a([
            Component.text(p.label),
            b([Component.text(p.value)]),
          ], href: p.href, classes: 'fxz-pill'),
      ]),
    ]);
  }
}

/// Tira de marcas/departamentos com botão "Confira".
class FlenxBrandStrip extends StatelessComponent {
  const FlenxBrandStrip({required this.items, this.action = 'Confira', super.key});
  final List<FlenxBrandItem> items;
  final String action;

  @override
  Component build(BuildContext context) {
    return div(classes: 'fxz-wrap', [
      div(classes: 'fxz-brands', [
        for (final it in items)
          a([
            div(classes: 'pic', [Component.text(it.icon)]),
            span(classes: 'cf', [Component.text(action)]),
          ], href: it.href),
      ]),
    ]);
  }
}

/// Faixa de benefícios (frete, parcelamento, troca...) acima do rodapé.
class FlenxBenefitsBar extends StatelessComponent {
  const FlenxBenefitsBar({required this.items, super.key});
  final List<FlenxBenefit> items;

  @override
  Component build(BuildContext context) {
    return div(classes: 'fxz-benes', [
      for (final b in items)
        div(classes: 'fxz-bene', [
          span(classes: 'ic', [Component.text(b.icon)]),
          div([
            Component.element(tag: 'b', children: [Component.text(b.title)]),
            span([Component.text(b.subtitle)]),
          ]),
        ]),
    ]);
  }
}
