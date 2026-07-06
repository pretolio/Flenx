import 'dart:convert';
import 'dart:io';

import 'db_executor.dart';

/// Executor que persiste cada tabela como um arquivo `<dir>/<tabela>.jsonl`
/// (uma linha JSON por registro). Útil para dev/demo sem instalar MySQL.
/// Em produção use um `MySqlExecutor`; o alvo PHP gera PDO/MySQL.
class JsonlDbExecutor implements DbExecutor {
  const JsonlDbExecutor({this.directory = 'content/db'});

  final String directory;

  File _file(String table) => File('$directory/$table.jsonl');

  Future<List<Map<String, Object?>>> _readAll(String table) async {
    final f = _file(table);
    if (!f.existsSync()) return [];
    final lines = await f.readAsLines();
    return [
      for (final l in lines)
        if (l.trim().isNotEmpty) (jsonDecode(l) as Map).cast<String, Object?>(),
    ];
  }

  Future<void> _writeAll(String table, List<Map<String, Object?>> rows) async {
    final f = _file(table);
    await f.parent.create(recursive: true);
    await f.writeAsString(
      rows.map(jsonEncode).join('\n') + (rows.isEmpty ? '' : '\n'),
    );
  }

  @override
  Future<int> insert(String table, Map<String, Object?> values) async {
    final rows = await _readAll(table);
    final id =
        rows.fold<int>(
          0,
          (m, r) => (r['id'] as int? ?? 0) > m ? r['id'] as int : m,
        ) +
        1;
    rows.add({'id': id, ...values});
    await _writeAll(table, rows);
    return id;
  }

  @override
  Future<int> count(String table) async => (await _readAll(table)).length;

  @override
  Future<List<Map<String, Object?>>> list(
    String table, {
    required int limit,
    required int offset,
    String orderBy = 'id',
    bool desc = true,
  }) async {
    final rows = await _readAll(table);
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
    for (final r in await _readAll(table)) {
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
    final rows = await _readAll(table);
    var changed = false;
    for (final r in rows) {
      if ('${r['id']}' == '$id') {
        r.addAll(values);
        changed = true;
      }
    }
    if (changed) await _writeAll(table, rows);
    return changed;
  }

  @override
  Future<bool> deleteById(String table, Object id) async {
    final rows = await _readAll(table);
    final before = rows.length;
    rows.removeWhere((r) => '${r['id']}' == '$id');
    if (rows.length != before) await _writeAll(table, rows);
    return rows.length != before;
  }
}
