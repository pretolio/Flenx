/// Camada de banco do Flext: models declarativos com colunas e relações,
/// geração de migration (MySQL) e config via `.env` (servidor).
library flext.db;

export 'db_column.dart';
export 'db_config.dart';
export 'db_model.dart';
export 'db_relation.dart';
export 'sql_migration_generator.dart';
export 'sql_type.dart';
