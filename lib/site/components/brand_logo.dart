import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../models/site_brand.dart';

/// Logo da marca com link para a home. Usa a imagem se houver, senão o texto.
class BrandLogo extends StatelessComponent {
  const BrandLogo(this.brand, {super.key});

  final SiteBrand brand;

  @override
  Component build(BuildContext context) {
    return a(
      [
        if (brand.logoSrc != null)
          img(src: brand.logoSrc!, alt: brand.label, classes: 'brand-img')
        else
          span(classes: 'brand-text', [.text(brand.label)]),
      ],
      href: brand.homeHref,
      classes: 'brand',
    );
  }
}
