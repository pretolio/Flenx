/// Item do carrinho (guardado no navegador via localStorage).
class CartItem {
  CartItem({
    required this.slug,
    required this.name,
    required this.price,
    required this.emoji,
    this.qty = 1,
  });

  final String slug;
  final String name;
  final double price;
  final String emoji;
  int qty;

  double get subtotal => price * qty;

  Map<String, Object?> toJson() => {
        'slug': slug,
        'name': name,
        'price': price,
        'emoji': emoji,
        'qty': qty,
      };

  factory CartItem.fromJson(Map<String, Object?> j) => CartItem(
        slug: '${j['slug'] ?? ''}',
        name: '${j['name'] ?? ''}',
        price: (j['price'] is num)
            ? (j['price'] as num).toDouble()
            : double.tryParse('${j['price']}') ?? 0,
        emoji: '${j['emoji'] ?? '🛍️'}',
        qty: (j['qty'] is num)
            ? (j['qty'] as num).toInt()
            : int.tryParse('${j['qty']}') ?? 1,
      );
}
