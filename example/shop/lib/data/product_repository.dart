import 'package:flenx/app.dart';

import 'product.dart';
import 'product_seeds.dart';

/// Acesso aos produtos no banco (servidor). Semeia o catálogo inicial na
/// primeira execução e carrega os produtos para montar a vitrine/rotas.
class ProductRepository {
  const ProductRepository(this.db, {this.table = 'products'});

  final DbExecutor db;
  final String table;

  /// Semeia [productSeeds] se a tabela estiver vazia.
  Future<void> seedIfEmpty() async {
    if (await db.count(table) > 0) return;
    for (final p in productSeeds) {
      await db.insert(table, {
        ...p.toRow(),
        'created_at': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Carrega todos os produtos ativos (mais novos primeiro).
  Future<List<Product>> loadAll({int max = 200}) async {
    final rows = await db.list(table, limit: max, offset: 0, orderBy: 'id');
    return rows
        .map(Product.fromRow)
        .where((p) => p.active && p.slug.isNotEmpty)
        .toList(growable: false);
  }
}
