/// Produto da loja. Agora persiste no banco (tabela `products`) e é editável
/// pelo admin. O `slug` vira a URL `/produto/<slug>`. [fromRow]/[toRow] fazem a
/// ponte com o banco (valores podem chegar como texto pela API).
class Product {
  const Product({
    required this.slug,
    required this.name,
    required this.price,
    required this.emoji,
    required this.summary,
    required this.description,
    this.id,
    this.tag,
    this.image,
    this.active = true,
  });

  final int? id;
  final String slug;
  final String name;
  final double price;
  final String emoji;
  final String summary;
  final String description;
  final String? tag;
  final String? image;
  final bool active;

  String get priceLabel =>
      'R\$ ${price.toStringAsFixed(2).replaceAll('.', ',')}';

  /// Banco → produto (robusto a valores em texto).
  factory Product.fromRow(Map<String, Object?> r) => Product(
    id: _int(r['id']),
    slug: '${r['slug'] ?? ''}',
    name: '${r['name'] ?? ''}',
    price: _double(r['price']),
    emoji: '${r['emoji'] ?? '🛍️'}',
    summary: '${r['summary'] ?? ''}',
    description: '${r['description'] ?? ''}',
    tag: _str(r['tag']),
    image: _str(r['image']),
    active: '${r['active']}' != '0' && r['active'] != false,
  );

  /// Produto → linha do banco (para semear/criar).
  Map<String, Object?> toRow() => {
    'slug': slug,
    'name': name,
    'price': price,
    'emoji': emoji,
    'summary': summary,
    'description': description,
    'tag': tag,
    'image': image,
    'active': active ? 1 : 0,
  };

  static int? _int(Object? v) => v is int ? v : int.tryParse('${v ?? ''}');
  static double _double(Object? v) {
    if (v is num) return v.toDouble();
    return double.tryParse('${v ?? ''}'.replaceAll(',', '.')) ?? 0;
  }

  static String? _str(Object? v) {
    final s = '${v ?? ''}'.trim();
    return s.isEmpty ? null : s;
  }
}
