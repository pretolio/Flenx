import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../api/db_executor.dart';

/// [DbExecutor] que persiste no **Supabase** (via PostgREST). Mesma interface
/// dos demais — basta escolher e adicionar as credenciais.
///
/// Credenciais: `SUPABASE_URL` e `SUPABASE_KEY` (service role no servidor).
class SupabaseDbExecutor implements DbExecutor {
  SupabaseDbExecutor({
    required this.url,
    required this.apiKey,
    http.Client? client,
  }) : _client = client ?? http.Client();

  factory SupabaseDbExecutor.fromEnv(
    Map<String, String> env, {
    http.Client? client,
  }) => SupabaseDbExecutor(
    url: env['SUPABASE_URL'] ?? '',
    apiKey: env['SUPABASE_KEY'] ?? '',
    client: client,
  );

  final String url;
  final String apiKey;
  final http.Client _client;

  String get _base => '$url/rest/v1';
  Map<String, String> get _headers => {
    'apikey': apiKey,
    'authorization': 'Bearer $apiKey',
    'content-type': 'application/json',
  };

  @override
  Future<int> insert(String table, Map<String, Object?> values) async {
    final r = await _client.post(
      Uri.parse('$_base/$table'),
      headers: {..._headers, 'prefer': 'return=representation'},
      body: jsonEncode(values),
    );
    if (r.statusCode >= 400) {
      throw Exception('Supabase insert ${r.statusCode}: ${r.body}');
    }
    final rows = jsonDecode(r.body) as List;
    return ((rows.first as Map)['id'] as num?)?.toInt() ?? 0;
  }

  @override
  Future<List<Map<String, Object?>>> list(
    String table, {
    required int limit,
    required int offset,
    String orderBy = 'id',
    bool desc = true,
  }) async {
    final uri = Uri.parse(
      '$_base/$table'
      '?order=$orderBy.${desc ? 'desc' : 'asc'}&limit=$limit&offset=$offset',
    );
    final r = await _client.get(uri, headers: _headers);
    if (r.statusCode >= 400) {
      throw Exception('Supabase list ${r.statusCode}: ${r.body}');
    }
    return (jsonDecode(r.body) as List)
        .map((e) => (e as Map).cast<String, Object?>())
        .toList();
  }

  @override
  Future<int> count(String table) async {
    final r = await _client.get(
      Uri.parse('$_base/$table?select=id'),
      headers: {..._headers, 'prefer': 'count=exact', 'range': '0-0'},
    );
    final cr = r.headers['content-range']; // "0-0/123"
    if (cr != null && cr.contains('/')) {
      return int.tryParse(cr.split('/').last) ?? 0;
    }
    return (jsonDecode(r.body) as List).length;
  }

  @override
  Future<Map<String, Object?>?> findById(String table, Object id) async {
    final r = await _client.get(
      Uri.parse('$_base/$table?id=eq.$id&limit=1'),
      headers: _headers,
    );
    final rows = jsonDecode(r.body) as List;
    return rows.isEmpty ? null : (rows.first as Map).cast<String, Object?>();
  }

  @override
  Future<bool> updateById(
    String table,
    Object id,
    Map<String, Object?> values,
  ) async {
    final r = await _client.patch(
      Uri.parse('$_base/$table?id=eq.$id'),
      headers: {..._headers, 'prefer': 'return=representation'},
      body: jsonEncode(values),
    );
    if (r.statusCode >= 400) return false;
    return (jsonDecode(r.body) as List).isNotEmpty;
  }

  @override
  Future<bool> deleteById(String table, Object id) async {
    final r = await _client.delete(
      Uri.parse('$_base/$table?id=eq.$id'),
      headers: {..._headers, 'prefer': 'return=representation'},
    );
    if (r.statusCode >= 400) return false;
    return (jsonDecode(r.body) as List).isNotEmpty;
  }
}
