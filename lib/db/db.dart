/// Camada de banco do Flenx: models declarativos com colunas e relações,
/// geração de migration (MySQL) e config via `.env` (servidor).
library flenx.db;

export 'db_column.dart';
export 'db_config.dart';
export 'db_model.dart';
export 'db_relation.dart';
export 'sql_migration_generator.dart';
export 'sql_type.dart';

// Models e helpers prontos para o admin (usuários, categorias, configurações).
export 'users_model.dart';
export 'categories_model.dart';
export 'settings_model.dart';
export 'site_settings.dart';

// Backends de banco plugáveis (mesma interface DbExecutor): Supabase, Firebase
// (Firestore), API REST (PHP ou Dart) e JSONL/memória — escolha por DB_PROVIDER.
export 'executors/db_registry.dart';
export 'executors/supabase_db_executor.dart';
export 'executors/firestore_db_executor.dart';
export 'executors/rest_api_db_executor.dart';
