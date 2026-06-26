import '../../api/db_executor.dart';
import '../mappers/blog_post_mapper.dart';
import '../models/blog_post.dart';
import 'blog_source.dart';

/// Fonte de posts no **banco de dados**: lê de uma tabela (padrão `blog_posts`)
/// via [DbExecutor]. Permite criar/editar posts pela API/admin sem tocar em
/// arquivos. Funciona com qualquer executor (em memória, JSONL, MySQL).
class DatabaseBlogSource implements BlogSource {
  const DatabaseBlogSource(
    this.db, {
    this.table = 'blog_posts',
    this.mapper = const BlogPostMapper(),
    this.max = 1000,
  });

  final DbExecutor db;

  /// Tabela onde os posts ficam.
  final String table;
  final BlogPostMapper mapper;

  /// Teto de posts carregados (evita varrer tabelas gigantes de uma vez).
  final int max;

  @override
  Future<List<BlogPost>> loadAll() async {
    final rows = await db.list(table, limit: max, offset: 0, orderBy: 'id');
    return rows.map(mapper.fromRow).toList(growable: false);
  }
}
