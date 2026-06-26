import 'frontmatter_parser.dart';
import 'models/blog_post.dart';
import 'models/category.dart';
import 'models/tag.dart';

/// Constrói um [BlogPost] a partir do conteúdo parseado de um arquivo `.md`.
/// Isola a leitura do frontmatter (testável sem acessar o disco).
class PostFactory {
  const PostFactory();

  BlogPost build(String slug, ParsedContent content) {
    final d = content.data;
    return BlogPost(
      slug: (d['slug'] as String?) ?? slug,
      title: (d['title'] as String?) ?? slug,
      subtitle: d['subtitle'] as String?,
      description: (d['description'] as String?) ?? '',
      date: _date(d['date']),
      bodyMarkdown: content.body,
      author: d['author'] as String?,
      image: d['image'] as String?,
      category: d['category'] != null
          ? Category.parse(d['category'].toString())
          : null,
      tags: _tags(d['tags']),
      draft: d['draft'] == true,
      views: _int(d['views']),
    );
  }

  int _int(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  DateTime _date(dynamic value) {
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value) ?? DateTime(1970);
    return DateTime(1970);
  }

  List<Tag> _tags(dynamic value) {
    if (value is List) {
      return value.map((e) => Tag(e.toString())).toList(growable: false);
    }
    if (value is String && value.isNotEmpty) {
      return value.split(',').map((e) => Tag(e.trim())).toList();
    }
    return const [];
  }
}
