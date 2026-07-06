import 'dart:convert';

import 'post_block.dart';
import 'post_block_factory.dart';

/// Documento de um post rico: uma sequência ordenada de [PostBlock] (estilo
/// G1). É a representação que o editor manipula. Serializa para:
///  - **JSON** → persistência estruturada (coluna `blocks` ou frontmatter);
///  - **Markdown** → corpo do post, renderizado pelo pipeline existente.
class PostDocument {
  const PostDocument(this.blocks);

  final List<PostBlock> blocks;

  static const _factory = PostBlockFactory();

  /// Junta os blocos em um Markdown único (separados por linha em branco).
  String toMarkdown() =>
      blocks.map((b) => b.toMarkdown()).where((s) => s.isNotEmpty).join('\n\n');

  List<Map<String, Object?>> toJson() =>
      blocks.map((b) => b.toJson()).toList(growable: false);

  String toJsonString() => jsonEncode(toJson());

  factory PostDocument.fromJson(List<dynamic> json) => PostDocument(
    json
        .whereType<Map>()
        .map((m) => _factory.fromJson(m.cast<String, Object?>()))
        .toList(growable: false),
  );

  /// Aceita uma String JSON (lista de blocos). Vazio/ inválido → documento vazio.
  factory PostDocument.parse(String? raw) {
    if (raw == null || raw.trim().isEmpty) return const PostDocument([]);
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) return PostDocument.fromJson(decoded);
    } catch (_) {
      /* não é JSON de blocos */
    }
    return const PostDocument([]);
  }
}
