import 'package:flenx/flenx.dart';

import '../data/product.dart';
import 'store_data.dart';

/// Página de um produto (`/produto/<slug>`) no layout de marketplace — só
/// componentes Dart do kit de e-commerce (FlenxStoreShell + FlenxProductDetail).
class ProductPage extends StatelessComponent {
  const ProductPage(this.product, {super.key});

  final Product product;

  @override
  Component build(BuildContext context) {
    return FlenxStoreShell(
      brand: 'flenx',
      cep: '01310-100, São Paulo',
      categories: storeCategories,
      accountHref: '/admin',
      footerColumns: storeFooterColumns,
      payments: const ['VISA', 'MASTER', 'ELO', 'PIX', 'BOLETO'],
      copyright: '© 2026 Flenx Store — feito com Flenx (SSR + SEO).',
      children: [
        productDetail(product),
        FlenxBenefitsBar(items: storeBenefits),
      ],
    );
  }
}
