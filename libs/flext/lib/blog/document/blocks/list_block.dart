import '../post_block.dart';

/// Lista de itens — ordenada (números) ou não (marcadores).
class ListBlock extends PostBlock {
  const ListBlock(this.items, {this.ordered = false});

  final List<String> items;
  final bool ordered;

  @override
  String get type => 'list';

  @override
  String toMarkdown() {
    final buffer = <String>[];
    for (var i = 0; i < items.length; i++) {
      final marker = ordered ? '${i + 1}.' : '-';
      buffer.add('$marker ${items[i].trim()}');
    }
    return buffer.join('\n');
  }

  @override
  Map<String, Object?> data() => {'items': items, 'ordered': ordered};

  factory ListBlock.fromJson(Map<String, Object?> j) => ListBlock(
        ((j['items'] as List?) ?? const [])
            .map((e) => e.toString())
            .toList(growable: false),
        ordered: j['ordered'] == true,
      );
}
