import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../models/blog_post.dart';
import '../utils/date_format.dart';

/// Renderiza um post completo (SSR): trilha, cabeçalho e o corpo markdown já
/// convertido em HTML ([htmlBody]). Conteúdo semântico, ótimo para SEO/AEO.
class BlogPostPage extends StatelessComponent {
  const BlogPostPage({required this.post, required this.htmlBody, super.key});

  final BlogPost post;

  /// Corpo do post em HTML (gerado pelo MarkdownRenderer no servidor).
  final String htmlBody;

  @override
  Component build(BuildContext context) {
    return article(classes: 'blog-post', [
      nav(classes: 'breadcrumb', [
        a(href: '/', [.text('Início')]),
        .text(' / '),
        a(href: '/blog', [.text('Blog')]),
        if (post.category != null) ...[
          .text(' / '),
          a(href: post.category!.path, [.text(post.category!.name)]),
        ],
      ]),
      header([
        h1([.text(post.title)]),
        if (post.subtitle != null && post.subtitle!.trim().isNotEmpty)
          p(classes: 'subtitle', [.text(post.subtitle!)]),
        div(classes: 'meta', [
          if (post.author != null) span([.text(post.author!)]),
          span([.text(DateFormatBr.short(post.date))]),
        ]),
      ]),
      if (post.image != null && post.image!.trim().isNotEmpty)
        figure(classes: 'cover', [
          img(src: post.image!, alt: post.title),
        ]),
      // Corpo markdown renderizado no servidor.
      div(classes: 'content', [RawText(htmlBody)]),
      if (post.tags.isNotEmpty)
        footer(classes: 'tags', [
          for (final t in post.tags)
            a(href: t.path, classes: 'tag', [.text('#${t.name}')]),
        ]),
    ]);
  }
}
