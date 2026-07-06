import '../post_block.dart';

/// Subtítulo (intertítulo) dentro do corpo. [level] vai de 2 a 4 — o título
/// principal (H1) é o título do post, não um bloco.
class HeadingBlock extends PostBlock {
  const HeadingBlock(this.text, {this.level = 2});

  final String text;
  final int level;

  int get _safeLevel => level < 2 ? 2 : (level > 4 ? 4 : level);

  @override
  String get type => 'heading';

  @override
  String toMarkdown() => '${'#' * _safeLevel} ${text.trim()}';

  @override
  Map<String, Object?> data() => {'text': text, 'level': level};

  factory HeadingBlock.fromJson(Map<String, Object?> j) => HeadingBlock(
    (j['text'] as String?) ?? '',
    level: (j['level'] as num?)?.toInt() ?? 2,
  );
}
