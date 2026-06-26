import 'blocks/divider_block.dart';
import 'blocks/embed_block.dart';
import 'blocks/heading_block.dart';
import 'blocks/image_block.dart';
import 'blocks/list_block.dart';
import 'blocks/paragraph_block.dart';
import 'blocks/quote_block.dart';
import 'post_block.dart';

/// Reconstrói um [PostBlock] a partir do seu JSON (`{"type": ...}`). Centraliza
/// o mapeamento tipo→classe; blocos desconhecidos viram parágrafo (fail-safe).
class PostBlockFactory {
  const PostBlockFactory();

  PostBlock fromJson(Map<String, Object?> json) {
    switch (json['type']) {
      case 'paragraph':
        return ParagraphBlock.fromJson(json);
      case 'heading':
        return HeadingBlock.fromJson(json);
      case 'image':
        return ImageBlock.fromJson(json);
      case 'quote':
        return QuoteBlock.fromJson(json);
      case 'list':
        return ListBlock.fromJson(json);
      case 'embed':
        return EmbedBlock.fromJson(json);
      case 'divider':
        return DividerBlock.fromJson(json);
      default:
        return ParagraphBlock((json['text'] as String?) ?? '');
    }
  }
}
