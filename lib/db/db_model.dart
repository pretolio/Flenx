import 'db_column.dart';
import 'db_relation.dart';

/// Definição declarativa de uma tabela: colunas (com notação de banco) e
/// relações. É a fonte para gerar migration, queries e código Dart/PHP.
class DbModel {
  const DbModel(this.table, this.columns, {this.relations = const []});

  final String table;
  final List<DbColumn> columns;
  final List<DbRelation> relations;

  /// Coluna chave primária (ou `null`).
  DbColumn? get primaryKey {
    for (final c in columns) {
      if (c.primaryKey) return c;
    }
    return null;
  }

  /// Colunas que são chave estrangeira.
  List<DbColumn> get foreignKeys =>
      columns.where((c) => c.isForeignKey).toList(growable: false);

  /// Nomes de coluna (para INSERT/SELECT).
  List<String> get columnNames =>
      columns.map((c) => c.name).toList(growable: false);
}
