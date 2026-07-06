/// Abstração de acesso ao banco usada pelo runtime Dart. Implementações:
/// [InMemoryDbExecutor] (testes/dev), `JsonlDbExecutor` (arquivo) e, em
/// produção, um `MySqlExecutor` (mysql_client). O alvo PHP gera PDO equivalente.
abstract interface class DbExecutor {
  /// Insere [values] em [table] e retorna o id gerado.
  Future<int> insert(String table, Map<String, Object?> values);

  /// Lista registros paginados.
  Future<List<Map<String, Object?>>> list(
    String table, {
    required int limit,
    required int offset,
    String orderBy = 'id',
    bool desc = true,
  });

  /// Conta registros de [table].
  Future<int> count(String table);

  /// Busca por id.
  Future<Map<String, Object?>?> findById(String table, Object id);

  /// Atualiza por id; retorna se afetou algo.
  Future<bool> updateById(String table, Object id, Map<String, Object?> values);

  /// Remove por id; retorna se afetou algo.
  Future<bool> deleteById(String table, Object id);
}

/// Implementação em memória — para testes e desenvolvimento.
class InMemoryDbExecutor implements DbExecutor {
  final Map<String, List<Map<String, Object?>>> _tables = {};
  final Map<String, int> _seq = {};

  List<Map<String, Object?>> _t(String t) => _tables.putIfAbsent(t, () => []);

  @override
  Future<int> insert(String table, Map<String, Object?> values) async {
    final id = (_seq[table] ?? 0) + 1;
    _seq[table] = id;
    _t(table).add({'id': id, ...values});
    return id;
  }

  @override
  Future<int> count(String table) async => _t(table).length;

  @override
  Future<List<Map<String, Object?>>> list(
    String table, {
    required int limit,
    required int offset,
    String orderBy = 'id',
    bool desc = true,
  }) async {
    final rows = [..._t(table)];
    rows.sort((a, b) {
      final cmp = Comparable.compare(
        (a[orderBy] ?? 0) as Comparable,
        (b[orderBy] ?? 0) as Comparable,
      );
      return desc ? -cmp : cmp;
    });
    return rows.skip(offset).take(limit).toList();
  }

  @override
  Future<Map<String, Object?>?> findById(String table, Object id) async {
    for (final r in _t(table)) {
      if ('${r['id']}' == '$id') return r;
    }
    return null;
  }

  @override
  Future<bool> updateById(
    String table,
    Object id,
    Map<String, Object?> values,
  ) async {
    for (final r in _t(table)) {
      if ('${r['id']}' == '$id') {
        r.addAll(values);
        return true;
      }
    }
    return false;
  }

  @override
  Future<bool> deleteById(String table, Object id) async {
    final t = _t(table);
    final before = t.length;
    t.removeWhere((r) => '${r['id']}' == '$id');
    return t.length != before;
  }
}
