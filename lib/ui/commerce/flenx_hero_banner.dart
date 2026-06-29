import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Banner principal (hero) da loja — eyebrow, título, subtítulo, preço de
/// chamada e botão. Setas e indicadores são decorativos.
class FlenxHeroBanner extends StatelessComponent {
  const FlenxHeroBanner({
    required this.title,
    required this.ctaHref,
    this.eyebrow,
    this.subtitle,
    this.priceFrom,
    this.priceValue,
    this.ctaLabel = 'aproveite',
    super.key,
  });

  final String title;
  final String ctaHref;
  final String? eyebrow;
  final String? subtitle;

  /// Texto pequeno acima do preço (ex.: `a partir de`).
  final String? priceFrom;

  /// Valor de destaque (ex.: `R$ 189,90`).
  final String? priceValue;
  final String ctaLabel;

  @override
  Component build(BuildContext context) {
    return div(classes: 'fxz-hero', [
      div(classes: 'fxz-hero-in', [
        div([
          if (eyebrow != null) span(classes: 'eyebrow', [Component.text(eyebrow!)]),
          h2([Component.text(title)]),
          if (subtitle != null) p([Component.text(subtitle!)]),
          a([Component.text(ctaLabel)], href: ctaHref, classes: 'cta'),
        ]),
        if (priceValue != null)
          div(classes: 'price', [
            if (priceFrom != null) span([Component.text(priceFrom!)]),
            span(classes: 'big', [Component.text(priceValue!)]),
          ]),
      ]),
      a([Component.text('‹')], href: ctaHref, classes: 'fxz-arrow l'),
      a([Component.text('›')], href: ctaHref, classes: 'fxz-arrow r'),
      div(classes: 'fxz-dots', [
        span(classes: 'on', []),
        span([]),
        span([]),
      ]),
    ]);
  }
}
