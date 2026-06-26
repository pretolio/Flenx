import '../post_block.dart';

/// Divisor temático entre seções do post (linha horizontal).
class DividerBlock extends PostBlock {
  const DividerBlock();

  @override
  String get type => 'divider';

  @override
  String toMarkdown() => '---';

  @override
  Map<String, Object?> data() => const {};

  factory DividerBlock.fromJson(Map<String, Object?> j) => const DividerBlock();
}
