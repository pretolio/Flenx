import '../core/platform_env.dart';

/// Configuração de conexão ao banco — lida do ambiente (`.env`), **só no
/// servidor**. Nunca embuta credenciais no código nem no cliente.
class DbConfig {
  const DbConfig({
    required this.host,
    required this.port,
    required this.database,
    required this.user,
    required this.password,
  });

  final String host;
  final int port;
  final String database;
  final String user;
  final String password;

  /// Lê de variáveis de ambiente: `DB_HOST`, `DB_PORT`, `DB_NAME`,
  /// `DB_USER`, `DB_PASSWORD`.
  factory DbConfig.fromEnv([Map<String, String>? env]) {
    final e = env ?? platformEnv;
    return DbConfig(
      host: e['DB_HOST'] ?? 'localhost',
      port: int.tryParse(e['DB_PORT'] ?? '') ?? 3306,
      database: e['DB_NAME'] ?? '',
      user: e['DB_USER'] ?? 'root',
      password: e['DB_PASSWORD'] ?? '',
    );
  }
}
