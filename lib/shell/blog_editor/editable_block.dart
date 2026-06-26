import '../../blog/document/blocks/divider_block.dart';
import '../../blog/document/blocks/embed_block.dart';
import '../../blog/document/blocks/heading_block.dart';
import '../../blog/document/blocks/image_block.dart';
import '../../blog/document/blocks/list_block.dart';
import '../../blog/document/blocks/paragraph_block.dart';
import '../../blog/document/blocks/quote_block.dart';
import '../../blog/document/post_block.dart';
import 'block_type.dart';

/// Estado MUTÁVEL de um bloco enquanto é editado na tela. Cada instância tem um
/// [id] estável (para `ValueKey` ao reordenar) e converte para o [PostBlock]
/// imutável da lib na hora de salvar — e também reconstrói a partir de um
/// [PostBlock] (para editar um post existente).
class EditableBlock {
  EditableBlock(this.id, this.type);

  final int id;
  BlockType type;

  String text = '';
  String secondary = ''; // crédito (imagem) / fonte (citação)
  String url = ''; // imagem
  int level = 2; // subtítulo
  bool ordered = false; // lista

  List<String> get _items => text
      .split('\n')
      .map((l) => l.trim())
      .where((l) => l.isNotEmpty)
      .toList(growable: false);

  /// Converte para o bloco imutável correspondente da lib.
  PostBlock toPostBlock() {
    switch (type) {
      case BlockType.paragraph:
        return ParagraphBlock(text);
      case BlockType.heading:
        return HeadingBlock(text, level: level);
      case BlockType.image:
        return ImageBlock(url,
            caption: text.isEmpty ? null : text,
            credit: secondary.isEmpty ? null : secondary);
      case BlockType.quote:
        return QuoteBlock(text, cite: secondary.isEmpty ? null : secondary);
      case BlockType.list:
        return ListBlock(_items, ordered: ordered);
      case BlockType.embed:
        return EmbedBlock(text);
      case BlockType.divider:
        return const DividerBlock();
    }
  }

  /// Reconstrói um [EditableBlock] a partir de um [PostBlock] salvo.
  factory EditableBlock.fromPostBlock(int id, PostBlock block) {
    final e = EditableBlock(id, _typeOf(block));
    switch (block) {
      case ParagraphBlock(:final text):
        e.text = text;
      case HeadingBlock(:final text, :final level):
        e.text = text;
        e.level = level;
      case ImageBlock(:final url, :final caption, :final credit):
        e.url = url;
        e.text = caption ?? '';
        e.secondary = credit ?? '';
      case QuoteBlock(:final text, :final cite):
        e.text = text;
        e.secondary = cite ?? '';
      case ListBlock(:final items, :final ordered):
        e.text = items.join('\n');
        e.ordered = ordered;
      case EmbedBlock(:final html):
        e.text = html;
      case DividerBlock():
        break;
    }
    return e;
  }

  static BlockType _typeOf(PostBlock b) => switch (b) {
        HeadingBlock() => BlockType.heading,
        ImageBlock() => BlockType.image,
        QuoteBlock() => BlockType.quote,
        ListBlock() => BlockType.list,
        EmbedBlock() => BlockType.embed,
        DividerBlock() => BlockType.divider,
        _ => BlockType.paragraph,
      };
}
