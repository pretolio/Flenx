import 'package:flext/blog/document/blocks/divider_block.dart';
import 'package:flext/blog/document/blocks/embed_block.dart';
import 'package:flext/blog/document/blocks/heading_block.dart';
import 'package:flext/blog/document/blocks/image_block.dart';
import 'package:flext/blog/document/blocks/list_block.dart';
import 'package:flext/blog/document/blocks/paragraph_block.dart';
import 'package:flext/blog/document/blocks/quote_block.dart';
import 'package:flext/blog/document/post_block.dart';

import 'block_type.dart';

/// Estado MUTÁVEL de um bloco enquanto é editado na tela. Cada instância tem um
/// [id] estável (para `ValueKey` ao reordenar) e converte para o [PostBlock]
/// imutável da lib na hora de salvar.
class EditableBlock {
  EditableBlock(this.id, this.type);

  final int id;
  BlockType type;

  // Campos genéricos reaproveitados conforme o tipo.
  String text = '';
  String secondary = ''; // crédito (imagem) / fonte (citação)
  String url = ''; // imagem
  int level = 2; // subtítulo
  bool ordered = false; // lista

  /// Itens da lista (um por linha, derivado de [text]).
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
}
