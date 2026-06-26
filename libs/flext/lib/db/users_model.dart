import 'db_column.dart';
import 'db_model.dart';
import 'sql_type.dart';

/// Tabela de usuários do admin (com papel/permissões). Inclua em `dbModels`
/// para gerar a migration e use em endpoints CRUD. O campo `role` casa com os
/// papéis de `AppRole`/`AdminPermissions` ('Administrador', 'Editor', ...).
const usersModel = DbModel('users', [
  DbColumn.id(),
  DbColumn('name', SqlType.varchar),
  DbColumn('email', SqlType.varchar, unique: true),
  DbColumn('role', SqlType.varchar, defaultValue: 'Visualizador'),
  DbColumn('active', SqlType.boolean, defaultValue: '1'),
  DbColumn('created_at', SqlType.datetime),
]);
