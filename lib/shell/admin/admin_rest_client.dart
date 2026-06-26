import 'dart:convert';

import 'package:http/http.dart' as http;

/// Cliente HTTP genérico do admin: fala com os endpoints declarativos do Flenx
/// (envelope `{success, data, error, meta}`) para qualquer recurso — posts,
/// produtos, pedidos, usuários, configurações. É a ponte entre as telas Flutter
/// do admin (ilha) e a API do servidor.
class AdminRestClient {
  const AdminRestClient({this.baseUrl = ''});

  /// Base da API (vazio = mesma origem — ideal para a ilha rodando no /admin).
  final String baseUrl;

  /// GET que devolve uma lista (`data` é um array). Usado por `*/list`.
  Future<List<Map<String, Object?>>> list(String path) async {
    final res = await http.get(Uri.parse('$baseUrl$path'));
    final data = _unwrap(res.body, res.statusCode);
    if (data is! List) return const [];
    return data
        .whereType<Map>()
        .map((e) => e.cast<String, Object?>())
        .toList(growable: false);
  }

  /// GET de um único registro (`data` é um objeto). Usado por `*/get?id=`.
  Future<Map<String, Object?>?> getOne(String path) async {
    final res = await http.get(Uri.parse('$baseUrl$path'));
    final data = _unwrap(res.body, res.statusCode);
    return data is Map ? data.cast<String, Object?>() : null;
  }

  /// POST com corpo JSON. Retorna o `data` (ex.: `{id: N}`).
  Future<Map<String, Object?>> post(
      String path, Map<String, Object?> body) async {
    final res = await http.post(
      Uri.parse('$baseUrl$path'),
      headers: const {'content-type': 'application/json'},
      body: jsonEncode(body),
    );
    final data = _unwrap(res.body, res.statusCode);
    return data is Map ? data.cast<String, Object?>() : const {};
  }

  /// Valida o envelope e devolve `data`; lança [Exception] em erro.
  Object? _unwrap(String body, int status) {
    Object? decoded;
    try {
      decoded = jsonDecode(body);
    } catch (_) {
      throw Exception('Resposta inválida do servidor ($status).');
    }
    if (decoded is Map && decoded['success'] == false) {
      throw Exception('${decoded['error'] ?? 'Falha na requisição'}');
    }
    if (status >= 400) throw Exception('Erro $status do servidor.');
    return decoded is Map ? decoded['data'] : decoded;
  }
}
