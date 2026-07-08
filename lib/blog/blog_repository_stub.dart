import 'frontmatter_parser.dart';
import 'post_factory.dart';

/// Stub Web de [BlogRepository] — leitura de `.md` só existe no servidor.
class BlogRepository {
  const BlogRepository({
    this.parser = const FrontmatterParser(),
    this.factory = const PostFactory(),
  });

  final FrontmatterParser parser;
  final PostFactory factory;

  Never loadAll(String directory) =>
      throw UnsupportedError('BlogRepository só está disponível no servidor (dart:io).');
}
