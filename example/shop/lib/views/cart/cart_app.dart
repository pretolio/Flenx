import 'dart:convert';

import 'package:flenx/shell.dart';
import 'package:flutter/material.dart';

import 'cart_item.dart';
import 'cart_storage.dart';

/// Carrinho de compras (ilha Flutter). Lê/grava no localStorage, soma o total e
/// finaliza o pedido criando um registro em `/api/orders`. Os botões "Adicionar
/// ao carrinho" da vitrine apontam para `/carrinho?add=<slug>`.
class CartApp extends StatefulWidget {
  const CartApp({this.client = const AdminRestClient(), super.key});

  final AdminRestClient client;

  @override
  State<CartApp> createState() => _CartAppState();
}

class _CartAppState extends State<CartApp> {
  final _items = <CartItem>[];
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();
  bool _loading = true;
  bool _sending = false;
  bool _done = false;

  static const _brand = Color(0xFF01589B);

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    _items.addAll(CartStorage.load());
    final add = CartStorage.takeAddParam();
    if (add != null) {
      try {
        final products = await widget.client.list('/api/products/list');
        final row = products.firstWhere((p) => '${p['slug']}' == add,
            orElse: () => const {});
        if (row.isNotEmpty) _addRow(row);
      } catch (_) {/* sem rede: ignora */}
    }
    if (mounted) setState(() => _loading = false);
  }

  void _addRow(Map<String, Object?> row) {
    final slug = '${row['slug']}';
    final existing = _items.where((i) => i.slug == slug).toList();
    if (existing.isNotEmpty) {
      existing.first.qty++;
    } else {
      _items.add(CartItem(
        slug: slug,
        name: '${row['name'] ?? ''}',
        price: double.tryParse('${row['price']}'.replaceAll(',', '.')) ?? 0,
        emoji: '${row['emoji'] ?? '🛍️'}',
      ));
    }
    CartStorage.save(_items);
  }

  void _qty(CartItem item, int delta) {
    setState(() {
      item.qty += delta;
      if (item.qty <= 0) _items.remove(item);
      CartStorage.save(_items);
    });
  }

  double get _total => _items.fold(0, (s, i) => s + i.subtotal);

  String _money(double v) => 'R\$ ${v.toStringAsFixed(2).replaceAll('.', ',')}';

  Future<void> _checkout() async {
    if (_name.text.trim().isEmpty || !_email.text.contains('@')) {
      _snack('Preencha nome e e-mail válidos.');
      return;
    }
    setState(() => _sending = true);
    try {
      await widget.client.post('/api/orders', {
        'customer_name': _name.text.trim(),
        'customer_email': _email.text.trim(),
        'items': jsonEncode(_items.map((e) => e.toJson()).toList()),
        'total': _total.toStringAsFixed(2),
        'status': 'Novo',
      });
      CartStorage.clear();
      setState(() => _done = true);
    } catch (e) {
      _snack('Erro ao finalizar: $e');
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  void _snack(String m) =>
      _messengerKey.currentState?.showSnackBar(SnackBar(content: Text(m)));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: _messengerKey,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: _brand,
        scaffoldBackgroundColor: const Color(0xFFF6F8FB),
      ),
      home: Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _done
                    ? _success()
                    : _content(),
          ),
        ),
      ),
    );
  }

  Widget _success() => Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 64),
            const SizedBox(height: 16),
            const Text('Pedido recebido!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            const Text('Você receberá a confirmação por e-mail.'),
            const SizedBox(height: 24),
            FilledButton(
                onPressed: () => CartStorage.go('/produtos'),
                child: const Text('Continuar comprando')),
          ],
        ),
      );

  Widget _content() {
    if (_items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.shopping_cart_outlined, size: 64),
          const SizedBox(height: 12),
          const Text('Seu carrinho está vazio.', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 20),
          FilledButton(
              onPressed: () => CartStorage.go('/produtos'),
              child: const Text('Ver produtos')),
        ]),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text('Seu carrinho',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
        const SizedBox(height: 16),
        for (final item in _items) _tile(item),
        const Divider(height: 32),
        Row(children: [
          const Expanded(
              child: Text('Total',
                  style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w700))),
          Text(_money(_total),
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w800, color: _brand)),
        ]),
        const SizedBox(height: 24),
        TextField(
            controller: _name,
            decoration: const InputDecoration(
                labelText: 'Seu nome', border: OutlineInputBorder())),
        const SizedBox(height: 12),
        TextField(
            controller: _email,
            decoration: const InputDecoration(
                labelText: 'Seu e-mail', border: OutlineInputBorder())),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: _sending ? null : _checkout,
          icon: _sending
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.payment),
          label: Text('Finalizar pedido • ${_money(_total)}'),
        ),
        const SizedBox(height: 8),
        TextButton(
            onPressed: () => CartStorage.go('/produtos'),
            child: const Text('Continuar comprando')),
      ],
    );
  }

  Widget _tile(CartItem item) => ListTile(
        leading: Text(item.emoji, style: const TextStyle(fontSize: 30)),
        title: Text(item.name,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(_money(item.price)),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () => _qty(item, -1)),
          Text('${item.qty}',
              style: const TextStyle(fontWeight: FontWeight.w700)),
          IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => _qty(item, 1)),
        ]),
      );
}
