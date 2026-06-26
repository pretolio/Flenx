import 'dart:convert';

import 'package:http/http.dart' as http;

/// Cliente do endpoint de posts do blog (a forma "salva no banco"). Envia o
/// post montado no editor para `/api/blog/posts`, que insere via [DbExecutor].
class PostApiClient {
  const PostApiClient({this.baseUrl = ''});

  /// Base da API (vazio = mesma origem do site, ideal para a ilha no admin).
  final String baseUrl;

  /// Cria um post no banco. Retorna o id gerado; lança em caso de erro.
  Future<int> create(Map<String, Object?> post) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/blog/posts'),
      headers: const {'content-type': 'application/json'},
      body: jsonEncode(post),
    );
    final body = jsonDecode(res.body);
    if (res.statusCode >= 400 || (body is Map && body['success'] == false)) {
      final msg = body is Map ? (body['error'] ?? 'Falha ao salvar') : 'Erro';
      throw Exception('$msg');
    }
    final data = (body as Map)['data'];
    return data is Map ? (int.tryParse('${data['id']}') ?? 0) : 0;
  }
}
