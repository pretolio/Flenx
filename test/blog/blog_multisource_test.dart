import 'package:flutter_test/flutter_test.dart';
import 'package:flenx/api/db_executor.dart';
import 'package:flenx/blog/blog.dart';
import 'package:flenx/blog/document/blocks/heading_block.dart';
import 'package:flenx/blog/document/blocks/paragraph_block.dart';
import 'package:flenx/blog/document/post_document.dart';
import 'package:flenx/blog/mappers/blog_post_mapper.dart';
import 'package:flenx/blog/models/blog_post.dart';
import 'package:flenx/blog/sources/database_blog_source.dart';

void main() {
  test('post criado no banco (editor G1) aparece no blog e gera rota SEO',
      () async {
    // Simula o que o editor envia: blocos → markdown + linha no banco.
    final doc = const PostDocument([
      HeadingBlock('O fato', level: 2),
      ParagraphBlock('Texto da notícia.'),
    ]);
    final db = InMemoryDbExecutor();
    await db.insert(
      'blog_posts',
      const BlogPostMapper().toRow(BlogPost(
        slug: 'noticia-do-banco',
        title: 'Notícia do banco',
        subtitle: 'Linha-fina',
        description: 'resumo',
        date: DateTime(2026, 6, 25),
        bodyMarkdown: doc.toMarkdown(),
      )),
    );

    final blog = await Blog.fromSources([DatabaseBlogSource(db)]);

    // Aparece na listagem e na resolução de rota individual.
    expect(blog.posts.map((p) => p.slug), contains('noticia-do-banco'));
    expect(blog.handles('/blog/noticia-do-banco'), isTrue);
    expect(blog.pageFor('/blog/noticia-do-banco'), isNotNull);

    // Entra na camada SEO (sitemap/llms).
    final routes = await blog.routeSource.resolve();
    expect(routes.any((r) => r.path == '/blog/noticia-do-banco'), isTrue);
  });
}
