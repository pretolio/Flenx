import 'package:flutter_test/flutter_test.dart';
import 'package:flext/blog/document/blocks/divider_block.dart';
import 'package:flext/blog/document/blocks/embed_block.dart';
import 'package:flext/blog/document/blocks/heading_block.dart';
import 'package:flext/blog/document/blocks/image_block.dart';
import 'package:flext/blog/document/blocks/list_block.dart';
import 'package:flext/blog/document/blocks/paragraph_block.dart';
import 'package:flext/blog/document/blocks/quote_block.dart';
import 'package:flext/blog/document/post_document.dart';
import 'package:flext/blog/markdown_renderer.dart';

void main() {
  group('PostDocument (post rico estilo G1)', () {
    final doc = PostDocument([
      const HeadingBlock('Entenda o caso', level: 2),
      const ParagraphBlock('Texto com **negrito** e [link](/x).'),
      const ImageBlock('/img/foto.jpg',
          caption: 'Multidão na avenida', credit: 'Foto: Agência'),
      const QuoteBlock('Foi histórico.', cite: 'Fulano'),
      const ListBlock(['Primeiro', 'Segundo'], ordered: true),
      const EmbedBlock('<iframe src="https://youtube.com/embed/x"></iframe>'),
      const DividerBlock(),
    ]);

    test('serializa para Markdown que o renderer converte em HTML rico', () {
      final md = doc.toMarkdown();
      expect(md, contains('## Entenda o caso'));
      expect(md, contains('<figure>'));
      expect(md, contains('<figcaption>Multidão na avenida — '));
      expect(md, contains('> Foi histórico.'));
      expect(md, contains('1. Primeiro'));

      final html = const MarkdownRenderer().toHtml(md);
      expect(html, contains('<h2'));
      expect(html, contains('<figure>'));
      expect(html, contains('<blockquote>'));
      expect(html, contains('<ol>'));
      expect(html, contains('<iframe'));
      expect(html, contains('<strong>negrito</strong>'));
    });

    test('round-trip JSON preserva os blocos', () {
      final restored = PostDocument.parse(doc.toJsonString());
      expect(restored.blocks, hasLength(doc.blocks.length));
      expect(restored.toMarkdown(), doc.toMarkdown());
    });

    test('parse de string vazia/ inválida → documento vazio', () {
      expect(PostDocument.parse(null).blocks, isEmpty);
      expect(PostDocument.parse('não é json').blocks, isEmpty);
    });
  });
}
