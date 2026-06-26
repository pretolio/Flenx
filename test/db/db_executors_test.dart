import 'dart:convert';

import 'package:flenx/db/db.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('SupabaseDbExecutor', () {
    test('insert envia para /rest/v1 e devolve o id', () async {
      late String capturedPath;
      final client = MockClient((r) async {
        capturedPath = r.url.path;
        return http.Response(jsonEncode([
          {'id': 5, 'name': 'Ana'}
        ]), 201);
      });
      final db = SupabaseDbExecutor(
          url: 'https://x.supabase.co', apiKey: 'k', client: client);
      final id = await db.insert('leads', {'name': 'Ana'});
      expect(id, 5);
      expect(capturedPath, '/rest/v1/leads');
    });

    test('count lê o total do header content-range', () async {
      final client = MockClient((r) async =>
          http.Response('[]', 200, headers: {'content-range': '0-0/42'}));
      final db =
          SupabaseDbExecutor(url: 'https://x.supabase.co', apiKey: 'k', client: client);
      expect(await db.count('leads'), 42);
    });
  });

  group('RestApiDbExecutor (PHP ou Dart)', () {
    test('insert lê data.id do envelope', () async {
      final client = MockClient((r) async =>
          http.Response(jsonEncode({'success': true, 'data': {'id': 7}}), 200));
      final db = RestApiDbExecutor(baseUrl: 'https://api.x/api', client: client);
      expect(await db.insert('leads', {'name': 'Ana'}), 7);
    });

    test('list lê data e count lê meta.total', () async {
      final client = MockClient((r) async => http.Response(
          jsonEncode({
            'success': true,
            'data': [
              {'id': 1},
              {'id': 2}
            ],
            'meta': {'total': 9}
          }),
          200));
      final db = RestApiDbExecutor(baseUrl: 'https://api.x/api', client: client);
      expect((await db.list('leads', limit: 10, offset: 0)).length, 2);
      expect(await db.count('leads'), 9);
    });

    test('update/delete olham o success', () async {
      final client = MockClient(
          (r) async => http.Response(jsonEncode({'success': true}), 200));
      final db = RestApiDbExecutor(baseUrl: 'https://api.x/api', client: client);
      expect(await db.updateById('leads', 1, {'name': 'X'}), isTrue);
      expect(await db.deleteById('leads', 1), isTrue);
    });
  });

  group('FirestoreDbExecutor', () {
    test('converte tipos e devolve linha com id na listagem', () async {
      final client = MockClient((r) async => http.Response(
          jsonEncode([
            {
              'document': {
                'name': 'projects/p/databases/(default)/documents/leads/abc',
                'fields': {
                  'name': {'stringValue': 'Ana'},
                  'idade': {'integerValue': '30'},
                }
              }
            }
          ]),
          200));
      final db =
          FirestoreDbExecutor(projectId: 'p', token: 't', client: client);
      final rows = await db.list('leads', limit: 10, offset: 0);
      expect(rows.single['id'], 'abc');
      expect(rows.single['name'], 'Ana');
      expect(rows.single['idade'], 30);
    });

    test('count lê a agregação', () async {
      final client = MockClient((r) async => http.Response(
          jsonEncode([
            {
              'result': {
                'aggregateFields': {
                  'count': {'integerValue': '42'}
                }
              }
            }
          ]),
          200));
      final db =
          FirestoreDbExecutor(projectId: 'p', token: 't', client: client);
      expect(await db.count('leads'), 42);
    });
  });

  group('DbRegistry.fromEnv', () {
    test('escolhe o backend por DB_PROVIDER', () {
      expect(
          DbRegistry.fromEnv({
            'DB_PROVIDER': 'supabase',
            'SUPABASE_URL': 'https://x',
            'SUPABASE_KEY': 'k'
          }),
          isA<SupabaseDbExecutor>());
      expect(DbRegistry.fromEnv({'DB_PROVIDER': 'rest'}),
          isA<RestApiDbExecutor>());
      expect(DbRegistry.fromEnv({'DB_PROVIDER': 'firebase'}),
          isA<FirestoreDbExecutor>());
    });

    test('provider inválido lança erro', () {
      expect(() => DbRegistry.fromEnv({'DB_PROVIDER': 'oracle'}),
          throwsArgumentError);
    });
  });
}
