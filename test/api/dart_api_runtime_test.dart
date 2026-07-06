import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:flenx/api/api.dart';
import 'package:flenx/db/db.dart';

const _leads = DbModel('leads', [
  DbColumn('id', SqlType.bigint, primaryKey: true, autoIncrement: true),
  DbColumn('name', SqlType.varchar),
  DbColumn('email', SqlType.varchar),
  DbColumn('message', SqlType.text, nullable: true),
  DbColumn('created_at', SqlType.datetime),
]);

Handler _router() {
  final api = FlenxApi(const [
    ApiEndpoint(
      path: '/api/leads',
      method: HttpMethod.post,
      fields: [Field('name', required: true), Field('email', email: true)],
      actions: [InsertInto(_leads)],
    ),
    ApiEndpoint(
      path: '/api/leads/list',
      method: HttpMethod.get,
      actions: [ListPaginated(_leads)],
    ),
  ], InMemoryDbExecutor());
  final r = Router();
  api.mountOn(r);
  return r.call;
}

Future<Map<String, dynamic>> _post(Handler h, String path, String body) async {
  final res = await h(
    Request(
      'POST',
      Uri.parse('http://x$path'),
      body: body,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    ),
  );
  return {
    'status': res.statusCode,
    'json': jsonDecode(await res.readAsString()),
  };
}

void main() {
  group('FlenxApi (runtime Dart)', () {
    test('insere e responde no envelope padrão', () async {
      final h = _router();
      final r = await _post(
        h,
        '/api/leads',
        'name=Ana&email=ana@x.com&message=oi',
      );
      expect(r['status'], 200);
      expect(r['json']['success'], isTrue);
      expect(r['json']['data']['id'], 1);
    });

    test('validação devolve 400 padronizado', () async {
      final h = _router();
      final r = await _post(h, '/api/leads', 'name=&email=invalido');
      expect(r['status'], 400);
      expect(r['json']['success'], isFalse);
      expect(r['json']['error'], contains('obrigatório'));
    });

    test('listagem é paginada com meta', () async {
      final h = _router();
      for (var i = 0; i < 25; i++) {
        await _post(h, '/api/leads', 'name=U$i&email=u$i@x.com');
      }
      final res = await h(
        Request('GET', Uri.parse('http://x/api/leads/list?page=2&perPage=10')),
      );
      final json = jsonDecode(await res.readAsString());
      expect(json['success'], isTrue);
      expect((json['data'] as List).length, 10);
      expect(json['meta']['total'], 25);
      expect(json['meta']['totalPages'], 3);
      expect(json['meta']['page'], 2);
    });
  });
}
