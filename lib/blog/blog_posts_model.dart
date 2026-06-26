import '../db/db_column.dart';
import '../db/db_model.dart';
import '../db/sql_type.dart';

/// Schema da tabela de posts do blog (fonte de banco). Inclua em `dbModels`
/// para gerar a migration e use em endpoints CRUD (InsertInto/UpdateById/...).
/// O corpo fica em `body` (Markdown) e, opcionalmente, os blocos estruturados
/// do editor em `blocks` (JSON) — ver [PostDocument].
const blogPostsModel = DbModel('blog_posts', [
  DbColumn.id(),
  DbColumn('slug', SqlType.varchar, unique: true),
  DbColumn('title', SqlType.varchar),
  DbColumn('subtitle', SqlType.varchar, nullable: true),
  DbColumn('description', SqlType.text, nullable: true),
  DbColumn('body', SqlType.text, nullable: true),
  DbColumn('blocks', SqlType.json, nullable: true),
  DbColumn('author', SqlType.varchar, nullable: true),
  DbColumn('image', SqlType.varchar, nullable: true),
  DbColumn('category', SqlType.varchar, nullable: true),
  DbColumn('tags', SqlType.varchar, nullable: true),
  DbColumn('draft', SqlType.boolean, defaultValue: '0'),
  DbColumn('views', SqlType.integer, defaultValue: '0'),
  DbColumn('date', SqlType.datetime),
  DbColumn('created_at', SqlType.datetime),
]);
