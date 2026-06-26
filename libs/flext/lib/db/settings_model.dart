import 'db_column.dart';
import 'db_model.dart';
import 'sql_type.dart';

/// Configurações do site em um único registro (id=1) com a coluna `data` (JSON).
/// Usado para **editar a tela home** e opções gerais pelo admin sem código:
/// o admin grava o JSON, e as páginas públicas leem dele. Ver `FlextSettingsPage`
/// e `SiteSettings`.
const settingsModel = DbModel('site_settings', [
  DbColumn.id(),
  DbColumn('data', SqlType.json, nullable: true),
  DbColumn('created_at', SqlType.datetime),
]);
