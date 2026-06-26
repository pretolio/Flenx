import '../post_block.dart';

/// Conteúdo incorporado (vídeo do YouTube, tweet, iframe). O [html] é inserido
/// como bloco — use para players e widgets que um post de portal costuma ter.
class EmbedBlock extends PostBlock {
  const EmbedBlock(this.html);

  final String html;

  @override
  String get type => 'embed';

  @override
  String toMarkdown() => '<div class="embed">\n${html.trim()}\n</div>';

  @override
  Map<String, Object?> data() => {'html': html};

  factory EmbedBlock.fromJson(Map<String, Object?> j) =>
      EmbedBlock((j['html'] as String?) ?? '');
}
