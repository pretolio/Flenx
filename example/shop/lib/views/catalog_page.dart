import 'package:flenx/flenx.dart';

import '../data/product.dart';
import 'store_data.dart';

/// Catálogo: todos os produtos na grade do kit de e-commerce (só Dart).
class CatalogPage extends StatelessComponent {
  const CatalogPage({required this.products, super.key});

  final List<Product> products;

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
        FlenxProductGrid(
          title: 'Todos os produtos',
          products: [for (final p in products) productCard(p)],
        ),
        FlenxBenefitsBar(items: storeBenefits),
      ],
    );
  }
}
