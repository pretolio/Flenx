import 'package:flutter_test/flutter_test.dart';
import 'package:flenx/api/api.dart';
import 'package:flenx/db/db.dart';

const _leads = DbModel('leads', [
  DbColumn('id', SqlType.bigint, primaryKey: true, autoIncrement: true),
  DbColumn('name', SqlType.varchar),
  DbColumn('email', SqlType.varchar),
  DbColumn('created_at', SqlType.datetime),
]);

void main() {
  group('PhpApiGenerator', () {
    final files = const PhpApiGenerator().generate(const [
      ApiEndpoint(
        path: '/api/leads',
        fields: [Field('name', required: true), Field('email', email: true)],
        actions: [InsertInto(_leads), Redirect('/?ok=1')],
      ),
      ApiEndpoint(
        path: '/api/posts',
        method: HttpMethod.get,
        actions: [ListPaginated(_leads)],
      ),
    ]);

    test('gera o bootstrap _flenx.php (PDO, envelope, .env)', () {
      final boot = files['_flenx.php']!;
      expect(boot, contains('function flenx_db()'));
      expect(boot, contains('new PDO('));
      expect(boot, contains("flenx_env('DB_PASSWORD'"));
      expect(boot, contains('function flenx_respond('));
      expect(boot, contains('function flenx_page('));
    });

    test('gera leads.php com validação, INSERT preparado e redirect', () {
      final php = files['leads.php']!;
      expect(php, contains("require __DIR__ . '/_flenx.php'"));
      expect(php, contains('é obrigatório')); // validação do name
      expect(php, contains('FILTER_VALIDATE_EMAIL')); // validação do email
      expect(php, contains('INSERT INTO `leads`'));
      expect(php, contains('->prepare(')); // prepared statement
      expect(php, contains("header('Location: /?ok=1'"));
    });

    test('gera posts.php paginado (LIMIT/OFFSET + count + meta)', () {
      final php = files['posts.php']!;
      expect(php, contains('flenx_page()'));
      expect(php, contains('LIMIT ? OFFSET ?'));
      expect(php, contains('SELECT COUNT(*)'));
      expect(php, contains('flenx_meta('));
    });
  });
}
