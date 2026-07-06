import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../api/db_executor.dart';

/// [DbExecutor] que persiste no **Firebase Firestore** (via REST). Mesma
/// interface dos demais. Como o Firestore é NoSQL, há um pequeno mapeamento:
/// cada documento vira um `Map` com a chave `id` (o id do documento) somada aos
/// campos. `insert` devolve o id como int quando numérico (senão 0 — use o `id`
/// retornado nas listagens).
///
/// Credenciais: `FIREBASE_PROJECT_ID` e `FIREBASE_TOKEN` (OAuth/access token).
class FirestoreDbExecutor implements DbExecutor {
  FirestoreDbExecutor({
    required this.projectId,
    required this.token,
    http.Client? client,
  }) : _client = client ?? http.Client();

  factory FirestoreDbExecutor.fromEnv(
    Map<String, String> env, {
    http.Client? client,
  }) => FirestoreDbExecutor(
    projectId: env['FIREBASE_PROJECT_ID'] ?? '',
    token: env['FIREBASE_TOKEN'] ?? '',
    client: client,
  );

  final String projectId;
  final String token;
  final http.Client _client;

  String get _docs =>
      'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents';
  Map<String, String> get _headers => {
    'authorization': 'Bearer $token',
    'content-type': 'application/json',
  };

  // ---- conversão de tipos Dart <-> Firestore ----
  static Map<String, dynamic> _toValue(Object? v) => switch (v) {
    null => {'nullValue': null},
    bool b => {'booleanValue': b},
    int i => {'integerValue': '$i'},
    double d => {'doubleValue': d},
    _ => {'stringValue': '$v'},
  };

  static Object? _fromValue(Map v) {
    if (v.containsKey('integerValue')) {
      return int.tryParse('${v['integerValue']}');
    }
    if (v.containsKey('doubleValue')) {
      return (v['doubleValue'] as num).toDouble();
    }
    if (v.containsKey('booleanValue')) return v['booleanValue'];
    if (v.containsKey('nullValue')) return null;
    return v['stringValue'] ?? v.values.first;
  }

  Map<String, dynamic> _fields(Map<String, Object?> values) => {
    for (final e in values.entries) e.key: _toValue(e.value),
  };

  Map<String, Object?> _row(Map doc) {
    final fields = (doc['fields'] as Map?) ?? const {};
    final id = '${doc['name']}'.split('/').last;
    return {
      'id': id,
      for (final e in fields.entries) '${e.key}': _fromValue(e.value as Map),
    };
  }

  @override
  Future<int> insert(String table, Map<String, Object?> values) async {
    final r = await _client.post(
      Uri.parse('$_docs/$table'),
      headers: _headers,
      body: jsonEncode({'fields': _fields(values)}),
    );
    if (r.statusCode >= 400) {
      throw Exception('Firestore insert ${r.statusCode}: ${r.body}');
    }
    final id = '${(jsonDecode(r.body) as Map)['name']}'.split('/').last;
    return int.tryParse(id) ?? 0;
  }

  @override
  Future<List<Map<String, Object?>>> list(
    String table, {
    required int limit,
    required int offset,
    String orderBy = 'id',
    bool desc = true,
  }) async {
    final query = {
      'structuredQuery': {
        'from': [
          {'collectionId': table},
        ],
        if (orderBy != 'id')
          'orderBy': [
            {
              'field': {'fieldPath': orderBy},
              'direction': desc ? 'DESCENDING' : 'ASCENDING',
            },
          ],
        'offset': offset,
        'limit': limit,
      },
    };
    final r = await _client.post(
      Uri.parse('$_docs:runQuery'),
      headers: _headers,
      body: jsonEncode(query),
    );
    if (r.statusCode >= 400) {
      throw Exception('Firestore list ${r.statusCode}: ${r.body}');
    }
    final rows = <Map<String, Object?>>[];
    for (final entry in jsonDecode(r.body) as List) {
      final doc = (entry as Map)['document'];
      if (doc is Map) rows.add(_row(doc));
    }
    return rows;
  }

  @override
  Future<int> count(String table) async {
    final query = {
      'structuredAggregationQuery': {
        'structuredQuery': {
          'from': [
            {'collectionId': table},
          ],
        },
        'aggregations': [
          {'alias': 'count', 'count': <String, dynamic>{}},
        ],
      },
    };
    final r = await _client.post(
      Uri.parse('$_docs:runAggregationQuery'),
      headers: _headers,
      body: jsonEncode(query),
    );
    if (r.statusCode >= 400) return 0;
    final res = (jsonDecode(r.body) as List).first as Map;
    final agg =
        ((res['result'] as Map)['aggregateFields'] as Map)['count'] as Map;
    return int.tryParse('${agg['integerValue']}') ?? 0;
  }

  @override
  Future<Map<String, Object?>?> findById(String table, Object id) async {
    final r = await _client.get(
      Uri.parse('$_docs/$table/$id'),
      headers: _headers,
    );
    if (r.statusCode >= 400) return null;
    return _row(jsonDecode(r.body) as Map);
  }

  @override
  Future<bool> updateById(
    String table,
    Object id,
    Map<String, Object?> values,
  ) async {
    final mask = values.keys.map((k) => 'updateMask.fieldPaths=$k').join('&');
    final r = await _client.patch(
      Uri.parse('$_docs/$table/$id?$mask'),
      headers: _headers,
      body: jsonEncode({'fields': _fields(values)}),
    );
    return r.statusCode < 400;
  }

  @override
  Future<bool> deleteById(String table, Object id) async {
    final r = await _client.delete(
      Uri.parse('$_docs/$table/$id'),
      headers: _headers,
    );
    return r.statusCode < 400;
  }
}
