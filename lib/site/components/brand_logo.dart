import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../models/site_brand.dart';

/// Logo da marca com link para a home. Usa a imagem se houver, senão o texto.
class BrandLogo extends StatelessComponent {
  const BrandLogo(this.brand, {super.key});

  final SiteBrand brand;

  static String _px(double v) =>
      v == v.roundToDouble() ? '${v.toInt()}px' : '${v}px';

  @override
  Component build(BuildContext context) {
    return a(
      [
        if (brand.logoSrc != null)
          img(
            src: brand.logoSrc!,
            alt: brand.label,
            classes: 'brand-img',
            attributes: brand.logoSrcset != null
                ? {'srcset': brand.logoSrcset!}
                : null,
            styles: brand.logoHeight != null
                ? Styles(raw: {'height': _px(brand.logoHeight!)})
                : null,
          )
        else
          span(classes: 'brand-text', [.text(brand.label)]),
      ],
      href: brand.homeHref,
      classes: 'brand',
    );
  }
}
