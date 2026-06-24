import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../models/blog_post.dart';
import '../utils/date_format.dart';

/// Cartão de listagem de um post (reutilizado no índice e nos arquivos).
class PostCard extends StatelessComponent {
  const PostCard(this.post, {super.key});

  final BlogPost post;

  @override
  Component build(BuildContext context) {
    return article(classes: 'post-card', [
      a(href: post.path, [h2([.text(post.title)])]),
      p(classes: 'excerpt', [.text(post.description)]),
      div(classes: 'meta', [
        if (post.author != null) span([.text(post.author!)]),
        span([.text(DateFormatBr.short(post.date))]),
        if (post.category != null)
          a(href: post.category!.path, classes: 'cat', [
            .text(post.category!.name),
          ]),
      ]),
      if (post.tags.isNotEmpty)
        div(classes: 'tags', [
          for (final t in post.tags)
            a(href: t.path, classes: 'tag', [.text('#${t.name}')]),
        ]),
    ]);
  }
}
