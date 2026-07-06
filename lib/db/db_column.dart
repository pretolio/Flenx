import 'sql_type.dart';

/// Coluna de uma tabela. A "notação do banco" do model: tipo, nulo, único,
/// chave primária e **chave estrangeira** ([references], no formato
/// `'tabela.coluna'`) para relacionar tabelas.
class DbColumn {
  const DbColumn(
    this.name,
    this.type, {
    this.nullable = false,
    this.unique = false,
    this.primaryKey = false,
    this.autoIncrement = false,
    this.references,
    this.defaultValue,
  });

  final String name;
  final SqlType type;
  final bool nullable;
  final bool unique;
  final bool primaryKey;
  final bool autoIncrement;

  /// FK no formato `'tabela.coluna'` (ex.: `'customers.id'`).
  final String? references;
  final String? defaultValue;

  /// Coluna `id` padrão: BIGINT, PK, auto-incremento.
  const DbColumn.id([this.name = 'id'])
    : type = SqlType.bigint,
      nullable = false,
      unique = false,
      primaryKey = true,
      autoIncrement = true,
      references = null,
      defaultValue = null;

  /// Chave estrangeira para `references` (ex.: `'customers.id'`).
  const DbColumn.foreign(this.name, this.references, {this.nullable = false})
    : type = SqlType.bigint,
      unique = false,
      primaryKey = false,
      autoIncrement = false,
      defaultValue = null;

  bool get isForeignKey => references != null;
}
