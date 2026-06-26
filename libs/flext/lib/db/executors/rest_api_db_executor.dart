import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../api/db_executor.dart';

/// [DbExecutor] que persiste chamando uma **API REST do Flext** (alvo Dart OU
/// PHP — é só apontar a URL). Usa o envelope padrão `{success, data, meta}` e o
/// contrato CRUD por tabela:
///
/// - `GET    <base>/<tabela>?limit&offset&orderBy&desc` → lista (data + meta.total)
/// - `GET    <base>/<tabela>/<id>`                       → um registro
/// - `POST   <base>/<tabela>`                            → cria (data.id)
/// - `PUT    <base>/<tabela>/<id>`                       → atualiza
/// - `DELETE <base>/<tabela>/<id>`                       → remove
///
/// Credenciais: `API_BASE_URL` e (opcional) `API_TOKEN` (Bearer).
class RestApiDbExecutor implements DbExecutor {
  RestApiDbExecutor({required this.baseUrl, this.token, http.Client? client})
      : _client = client ?? http.Client();

  factory RestApiDbExecutor.fromEnv(Map<String, String> env,
          {http.Client? client}) =>
      RestApiDbExecutor(
        baseUrl: env['API_BASE_URL'] ?? '',
        token: env['API_TOKEN'],
        client: client,
      );

  final String baseUrl;
  final String? token;
  final http.Client _client;

  Map<String, String> get _headers => {
        'content-type': 'application/json',
        if (token != null && token!.isNotEmpty) 'authorization': 'Bearer $token',
      };

  Uri _u(String path) => Uri.parse('$baseUrl/$path');

  Map<String, dynamic> _decode(http.Response r) {
    final body = jsonDecode(r.body);
    if (body is Map<String, dynamic>) return body;
    return {'success': r.statusCode < 400, 'data': body};
  }

  @override
  Future<int> insert(String table, Map<String, Object?> values) async {
    final r = await _client.post(_u(table),
        headers: _headers, body: jsonEncode(values));
    final data = _decode(r)['data'];
    if (data is Map && data['id'] != null) {
      return (data['id'] as num).toInt();
    }
    return 0;
  }

  @override
  Future<List<Map<String, Object?>>> list(
    String table, {
    required int limit,
    required int offset,
    String orderBy = 'id',
    bool desc = true,
  }) async {
    final page = (offset ~/ (limit == 0 ? 1 : limit)) + 1;
    final r = await _client.get(
      _u('$table?page=$page&perPage=$limit&orderBy=$orderBy&desc=$desc'),
      headers: _headers,
    );
    final data = _decode(r)['data'];
    if (data is List) {
      return data.map((e) => (e as Map).cast<String, Object?>()).toList();
    }
    return const [];
  }

  @override
  Future<int> count(String table) async {
    final r = await _client.get(_u('$table?page=1&perPage=1'), headers: _headers);
    final meta = _decode(r)['meta'];
    if (meta is Map && meta['total'] != null) {
      return (meta['total'] as num).toInt();
    }
    return 0;
  }

  @override
  Future<Map<String, Object?>?> findById(String table, Object id) async {
    final r = await _client.get(_u('$table/$id'), headers: _headers);
    if (r.statusCode >= 400) return null;
    final data = _decode(r)['data'];
    return data is Map ? data.cast<String, Object?>() : null;
  }

  @override
  Future<bool> updateById(
      String table, Object id, Map<String, Object?> values) async {
    final r = await _client.put(_u('$table/$id'),
        headers: _headers, body: jsonEncode(values));
    return r.statusCode < 400 && _decode(r)['success'] == true;
  }

  @override
  Future<bool> deleteById(String table, Object id) async {
    final r = await _client.delete(_u('$table/$id'), headers: _headers);
    return r.statusCode < 400 && _decode(r)['success'] == true;
  }
}
