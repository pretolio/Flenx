import 'dart:convert';

import '../api/db_executor.dart';

/// Acesso (servidor) às configurações do site guardadas em `site_settings`
/// (registro único, coluna `data` em JSON). As páginas públicas leem daqui o
/// que o admin editou (ex.: textos da home). Ver `settingsModel`.
class SiteSettings {
  const SiteSettings(this.values);

  /// Mapa chave→valor já decodificado do JSON.
  final Map<String, Object?> values;

  String get(String key, [String fallback = '']) {
    final v = values[key];
    return (v == null || '$v'.isEmpty) ? fallback : '$v';
  }

  /// Carrega o registro [id]; devolve configurações vazias se não existir.
  static Future<SiteSettings> load(DbExecutor db,
      {String table = 'site_settings', Object id = 1}) async {
    final row = await db.findById(table, id);
    return SiteSettings(_decode(row?['data']));
  }

  /// Garante que o registro exista (semeia [defaults] na primeira vez).
  static Future<void> ensure(
    DbExecutor db,
    Map<String, Object?> defaults, {
    String table = 'site_settings',
    Object id = 1,
  }) async {
    final existing = await db.findById(table, id);
    if (existing != null) return;
    await db.insert(table, {
      'id': id,
      'data': jsonEncode(defaults),
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  static Map<String, Object?> _decode(Object? raw) {
    if (raw is Map) return raw.cast<String, Object?>();
    if (raw is String && raw.trim().isNotEmpty) {
      try {
        final d = jsonDecode(raw);
        if (d is Map) return d.cast<String, Object?>();
      } catch (_) {/* ignora JSON inválido */}
    }
    return {};
  }
}
