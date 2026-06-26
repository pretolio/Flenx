/// Tipos de coluna suportados, mapeados para SQL (dialeto MySQL — comum em
/// hospedagem PHP e no alvo Dart).
enum SqlType {
  id('BIGINT'),
  integer('INT'),
  bigint('BIGINT'),
  boolean('TINYINT(1)'),
  decimal('DECIMAL(10,2)'),
  text('TEXT'),
  varchar('VARCHAR(255)'),
  datetime('DATETIME'),
  json('JSON');

  const SqlType(this.sql);

  /// Tipo SQL correspondente (MySQL).
  final String sql;
}
