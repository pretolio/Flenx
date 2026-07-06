import '../post_block.dart';

/// Citação / destaque. [cite] é a fonte opcional (autor, veículo).
class QuoteBlock extends PostBlock {
  const QuoteBlock(this.text, {this.cite});

  final String text;
  final String? cite;

  @override
  String get type => 'quote';

  @override
  String toMarkdown() {
    final lines = text.trim().split('\n').map((l) => '> $l').join('\n');
    final source = (cite != null && cite!.trim().isNotEmpty)
        ? '\n>\n> — ${cite!.trim()}'
        : '';
    return '$lines$source';
  }

  @override
  Map<String, Object?> data() => {'text': text, 'cite': cite};

  factory QuoteBlock.fromJson(Map<String, Object?> j) =>
      QuoteBlock((j['text'] as String?) ?? '', cite: j['cite'] as String?);
}
