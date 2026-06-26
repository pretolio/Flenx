/// Camada de banco do Flext: models declarativos com colunas e relações,
/// geração de migration (MySQL) e config via `.env` (servidor).
library flext.db;

export 'db_column.dart';
export 'db_config.dart';
export 'db_model.dart';
export 'db_relation.dart';
export 'sql_migration_generator.dart';
export 'sql_type.dart';

// Backends de banco plugáveis (mesma interface DbExecutor): Supabase, Firebase
// (Firestore), API REST (PHP ou Dart) e JSONL/memória — escolha por DB_PROVIDER.
export 'executors/db_registry.dart';
export 'executors/supabase_db_executor.dart';
export 'executors/firestore_db_executor.dart';
export 'executors/rest_api_db_executor.dart';
