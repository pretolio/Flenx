import 'db_executor.dart';

/// Stub Web de [JsonlDbExecutor] — armazenamento em arquivo só no servidor.
class JsonlDbExecutor implements DbExecutor {
  const JsonlDbExecutor({this.directory = 'content/db'});

  final String directory;

  Never _unsupported() =>
      throw UnsupportedError('JsonlDbExecutor só está disponível no servidor (dart:io).');

  @override
  Future<int> insert(String table, Map<String, Object?> values) async => _unsupported();

  @override
  Future<int> count(String table) async => _unsupported();

  @override
  Future<List<Map<String, Object?>>> list(
    String table, {
    required int limit,
    required int offset,
    String orderBy = 'id',
    bool desc = true,
  }) async => _unsupported();

  @override
  Future<Map<String, Object?>?> findById(String table, Object id) async => _unsupported();

  @override
  Future<bool> updateById(String table, Object id, Map<String, Object?> values) async => _unsupported();

  @override
  Future<bool> deleteById(String table, Object id) async => _unsupported();
}
