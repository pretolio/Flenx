import '../models/blog_post.dart';
import '../models/category.dart';
import '../models/tag.dart';

/// Converte [BlogPost] de/para uma linha de banco (`Map`). É o equivalente do
/// frontmatter para a fonte de banco: define como o post é persistido nas
/// colunas e como volta a virar objeto. Robusto a valores em texto (o runtime
/// da API serializa tudo como String).
class BlogPostMapper {
  const BlogPostMapper();

  /// Colunas que representam um post no banco (ordem = schema/migrations).
  static const columns = <String>[
    'slug',
    'title',
    'subtitle',
    'description',
    'body',
    'author',
    'image',
    'category',
    'tags',
    'draft',
    'views',
    'date',
  ];

  /// Post → linha de banco (chaves = [columns]).
  Map<String, Object?> toRow(BlogPost p) => {
        'slug': p.slug,
        'title': p.title,
        'subtitle': p.subtitle,
        'description': p.description,
        'body': p.bodyMarkdown,
        'author': p.author,
        'image': p.image,
        'category': p.category?.segments.join('/'),
        'tags': p.tags.map((t) => t.name).join(', '),
        'draft': p.draft ? 1 : 0,
        'views': p.views,
        'date': _dateStr(p.date),
      };

  /// Linha de banco → post.
  BlogPost fromRow(Map<String, Object?> r) {
    final slug = '${r['slug'] ?? r['id'] ?? ''}';
    return BlogPost(
      slug: slug,
      title: (r['title'] as String?) ?? slug,
      subtitle: _str(r['subtitle']),
      description: (r['description'] as String?) ?? '',
      date: _date(r['date']),
      bodyMarkdown: (r['body'] as String?) ?? '',
      author: _str(r['author']),
      image: _str(r['image']),
      category: _str(r['category']) != null
          ? Category.parse(r['category'].toString())
          : null,
      tags: _tags(r['tags']),
      draft: _bool(r['draft']),
      views: _int(r['views']),
    );
  }

  static String? _str(Object? v) {
    if (v == null) return null;
    final s = v.toString().trim();
    return s.isEmpty ? null : s;
  }

  static String _dateStr(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  static DateTime _date(Object? v) {
    if (v is DateTime) return v;
    if (v is String) return DateTime.tryParse(v) ?? DateTime(1970);
    return DateTime(1970);
  }

  static int _int(Object? v) {
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  static bool _bool(Object? v) {
    if (v is bool) return v;
    if (v is int) return v != 0;
    final s = v?.toString().toLowerCase();
    return s == 'true' || s == '1';
  }

  static List<Tag> _tags(Object? v) {
    if (v is List) {
      return v.map((e) => Tag(e.toString())).toList(growable: false);
    }
    if (v is String && v.trim().isNotEmpty) {
      return v
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .map(Tag.new)
          .toList(growable: false);
    }
    return const [];
  }
}
