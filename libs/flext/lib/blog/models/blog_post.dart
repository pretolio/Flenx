import 'category.dart';
import 'tag.dart';

/// Um post de blog carregado de um arquivo markdown (frontmatter + corpo).
class BlogPost {
  const BlogPost({
    required this.slug,
    required this.title,
    required this.description,
    required this.date,
    required this.bodyMarkdown,
    this.subtitle,
    this.author,
    this.image,
    this.category,
    this.tags = const [],
    this.draft = false,
    this.views = 0,
  });

  /// Identificador na URL (geralmente o nome do arquivo sem `.md`).
  final String slug;
  final String title;

  /// Linha-fina / subtítulo (estilo G1) exibida sob o título. Opcional.
  final String? subtitle;
  final String description;
  final DateTime date;

  /// Corpo do post em Markdown (renderizado para HTML na exibição).
  final String bodyMarkdown;

  final String? author;
  final String? image;

  /// Categoria principal (hierárquica). Nula se não classificado.
  final Category? category;

  /// Tags transversais.
  final List<Tag> tags;

  /// Se `true`, o post é rascunho e não é publicado/indexado.
  final bool draft;

  /// Número de acessos (frontmatter `views`) — usado em "Mais acessados".
  final int views;

  /// Caminho público do post (ex.: `/blog/meu-post`).
  String get path => '/blog/$slug';
}
