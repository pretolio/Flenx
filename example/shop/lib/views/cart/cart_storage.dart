import 'dart:convert';

import 'package:web/web.dart' as web;

import 'cart_item.dart';

/// Persistência do carrinho no navegador (localStorage) — sem backend até o
/// checkout. Também lê o parâmetro `?add=<slug>` usado pelos botões "Adicionar
/// ao carrinho" da vitrine e limpa a URL depois.
class CartStorage {
  static const _key = 'flenx_cart';

  static List<CartItem> load() {
    final raw = web.window.localStorage.getItem(_key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded
            .whereType<Map>()
            .map((m) => CartItem.fromJson(m.cast<String, Object?>()))
            .toList();
      }
    } catch (_) {
      /* carrinho inválido → vazio */
    }
    return [];
  }

  static void save(List<CartItem> items) {
    web.window.localStorage.setItem(
      _key,
      jsonEncode(items.map((e) => e.toJson()).toList()),
    );
  }

  static void clear() => web.window.localStorage.removeItem(_key);

  /// Navega o navegador para [path] (sai da ilha de volta ao site SSR).
  static void go(String path) => web.window.location.href = path;

  /// Lê o slug em `?add=...` (ou null) e limpa a query da URL.
  static String? takeAddParam() {
    final search = web.window.location.search;
    if (search.isEmpty) return null;
    final query = Uri.splitQueryString(
      search.startsWith('?') ? search.substring(1) : search,
    );
    final add = query['add'];
    if (add != null && add.isNotEmpty) {
      web.window.history.replaceState(null, '', '/carrinho');
    }
    return (add != null && add.isNotEmpty) ? add : null;
  }
}
