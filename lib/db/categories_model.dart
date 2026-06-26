import 'db_column.dart';
import 'db_model.dart';
import 'sql_type.dart';

/// Tabela de categorias do blog/portal (lista curada, editável pelo admin).
/// Inclua em `dbModels` e use em endpoints CRUD. O `slug` casa com as páginas
/// de arquivo do blog (`/blog/categoria/<slug>`); o `name` é exibido nos menus.
const categoriesModel = DbModel('categories', [
  DbColumn.id(),
  DbColumn('name', SqlType.varchar),
  DbColumn('slug', SqlType.varchar, unique: true),
  DbColumn('description', SqlType.text, nullable: true),
  DbColumn('created_at', SqlType.datetime),
]);
