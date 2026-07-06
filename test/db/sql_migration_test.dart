import 'package:flutter_test/flutter_test.dart';
import 'package:flenx/db/db.dart';

void main() {
  group('SqlMigrationGenerator', () {
    test('gera CREATE TABLE com PK, tipos e chave estrangeira', () {
      const customers = DbModel('customers', [
        DbColumn('id', SqlType.bigint, primaryKey: true, autoIncrement: true),
        DbColumn('name', SqlType.varchar),
        DbColumn('email', SqlType.varchar, unique: true),
      ]);
      final orders = DbModel('orders', [
        DbColumn.id(),
        DbColumn.foreign('customer_id', 'customers.id'),
        const DbColumn('total', SqlType.decimal),
      ]);

      final sql = const SqlMigrationGenerator().generate([customers, orders]);

      expect(sql, contains('CREATE TABLE IF NOT EXISTS `customers`'));
      expect(sql, contains('`email` VARCHAR(255) NOT NULL UNIQUE'));
      expect(sql, contains('PRIMARY KEY (`id`)'));
      expect(sql, contains('`id` BIGINT NOT NULL AUTO_INCREMENT'));
      // relação (FK)
      expect(
        sql,
        contains('FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`)'),
      );
    });
  });

  group('DbModel', () {
    test('expõe PK e FKs', () {
      final m = DbModel('orders', [
        DbColumn.id(),
        DbColumn.foreign('customer_id', 'customers.id'),
      ]);
      expect(m.primaryKey?.name, 'id');
      expect(m.foreignKeys.map((c) => c.name), ['customer_id']);
      expect(m.columnNames, ['id', 'customer_id']);
    });
  });
}
