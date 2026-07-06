import 'package:http/http.dart' as http;

import '../../api/db_executor.dart';
import '../../api/jsonl_db_executor.dart';
import 'firestore_db_executor.dart';
import 'rest_api_db_executor.dart';
import 'supabase_db_executor.dart';

/// Cria um [DbExecutor] a partir do ambiente (`.env`) + client HTTP opcional.
typedef DbExecutorFactory =
    DbExecutor Function(Map<String, String> env, http.Client? client);

/// Registro do backend de banco. Você escolhe por `DB_PROVIDER` (`supabase`,
/// `firebase`, `rest`, `jsonl`...) e adiciona as credenciais — mesma ideia do
/// pagamento. Provedores novos entram com `DbRegistry.register('x', ...)`.
class DbRegistry {
  DbRegistry._();

  static final Map<String, DbExecutorFactory> _factories = {
    'supabase': (e, c) => SupabaseDbExecutor.fromEnv(e, client: c),
    'firebase': (e, c) => FirestoreDbExecutor.fromEnv(e, client: c),
    'firestore': (e, c) => FirestoreDbExecutor.fromEnv(e, client: c),
    'rest': (e, c) => RestApiDbExecutor.fromEnv(e, client: c),
    'api': (e, c) => RestApiDbExecutor.fromEnv(e, client: c),
    'jsonl': (e, c) => JsonlDbExecutor(directory: e['DB_DIR'] ?? 'content/db'),
    'memory': (e, c) => InMemoryDbExecutor(),
  };

  /// Registra (ou substitui) um backend pelo nome usado em `DB_PROVIDER`.
  static void register(String name, DbExecutorFactory factory) =>
      _factories[name.toLowerCase()] = factory;

  static List<String> get available => _factories.keys.toList();

  static DbExecutor resolve(
    String provider,
    Map<String, String> env, {
    http.Client? client,
  }) {
    final factory = _factories[provider.toLowerCase()];
    if (factory == null) {
      throw ArgumentError(
        'DB_PROVIDER inválido: "$provider" (use ${available.join(", ")})',
      );
    }
    return factory(env, client);
  }

  /// Escolhe o backend pelo `DB_PROVIDER` do ambiente (padrão: `jsonl`).
  static DbExecutor fromEnv(Map<String, String> env, {http.Client? client}) =>
      resolve(env['DB_PROVIDER'] ?? 'jsonl', env, client: client);
}
