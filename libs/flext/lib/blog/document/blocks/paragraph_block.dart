import '../post_block.dart';

/// Parágrafo de texto. O conteúdo aceita Markdown inline (negrito, links...).
class ParagraphBlock extends PostBlock {
  const ParagraphBlock(this.text);

  final String text;

  @override
  String get type => 'paragraph';

  @override
  String toMarkdown() => text.trim();

  @override
  Map<String, Object?> data() => {'text': text};

  factory ParagraphBlock.fromJson(Map<String, Object?> j) =>
      ParagraphBlock((j['text'] as String?) ?? '');
}
