import 'db_model.dart';

/// Gera o SQL de criação das tabelas (MySQL) a partir dos [DbModel],
/// incluindo chaves primárias e **estrangeiras** (relações). Roda uma vez.
class SqlMigrationGenerator {
  const SqlMigrationGenerator();

  String generate(List<DbModel> models) {
    final buffer = StringBuffer('-- Gerado pelo Flenx — não edite à mão\n');
    for (final model in models) {
      buffer
        ..writeln(_createTable(model))
        ..writeln();
    }
    return buffer.toString();
  }

  String _createTable(DbModel model) {
    final lines = <String>[];
    for (final c in model.columns) {
      final parts = <String>['  `${c.name}`', c.type.sql];
      if (!c.nullable) parts.add('NOT NULL');
      if (c.autoIncrement) parts.add('AUTO_INCREMENT');
      if (c.unique) parts.add('UNIQUE');
      if (c.defaultValue != null) parts.add('DEFAULT ${c.defaultValue}');
      lines.add(parts.join(' '));
    }
    final pk = model.primaryKey;
    if (pk != null) lines.add('  PRIMARY KEY (`${pk.name}`)');
    for (final fk in model.foreignKeys) {
      final ref = fk.references!.split('.');
      lines.add(
        '  FOREIGN KEY (`${fk.name}`) '
        'REFERENCES `${ref[0]}` (`${ref[1]}`)',
      );
    }
    return 'CREATE TABLE IF NOT EXISTS `${model.table}` (\n'
        '${lines.join(',\n')}\n'
        ') ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;';
  }
}
