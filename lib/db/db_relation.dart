/// Tipo de relacionamento entre tabelas.
enum RelationKind { belongsTo, hasMany, hasOne }

/// Relação entre dois models — usada para gerar joins/includes padronizados.
/// Ex.: um pedido `belongsTo` cliente; um cliente `hasMany` pedidos.
class DbRelation {
  const DbRelation({
    required this.kind,
    required this.name,
    required this.table,
    required this.foreignKey,
    this.localKey = 'id',
  });

  final RelationKind kind;

  /// Nome da relação exposto no resultado (ex.: `customer`, `items`).
  final String name;

  /// Tabela relacionada.
  final String table;

  /// Coluna que guarda a referência.
  final String foreignKey;

  /// Coluna referenciada (normalmente `id`).
  final String localKey;

  factory DbRelation.belongsTo(
    String name, {
    required String table,
    required String foreignKey,
  }) => DbRelation(
    kind: RelationKind.belongsTo,
    name: name,
    table: table,
    foreignKey: foreignKey,
  );

  factory DbRelation.hasMany(
    String name, {
    required String table,
    required String foreignKey,
  }) => DbRelation(
    kind: RelationKind.hasMany,
    name: name,
    table: table,
    foreignKey: foreignKey,
  );
}
