import 'package:flenx/flenx.dart';

import '../data/product.dart';

/// Dados de apresentação da loja (categorias, marcas, benefícios, rodapé) e o
/// mapeamento de [Product] para o card do kit de e-commerce. Mantém a home
/// enxuta e só com componentes Dart.

const storeCategories = [
  MenuLink(label: 'Feminino', href: '/produtos'),
  MenuLink(label: 'Masculino', href: '/produtos'),
  MenuLink(label: 'Infantil', href: '/produtos'),
  MenuLink(label: 'Marcas', href: '/produtos'),
  MenuLink(label: 'Beleza', href: '/produtos'),
  MenuLink(label: 'Esporte', href: '/produtos'),
  MenuLink(label: 'Ofertas', href: '/produtos'),
];

const storePricePills = [
  FlenxPricePill(value: r'R$ 19,90', href: '/produtos'),
  FlenxPricePill(value: r'R$ 49,90', href: '/produtos'),
  FlenxPricePill(value: r'R$ 99,90', href: '/produtos'),
  FlenxPricePill(value: r'R$ 199,90', href: '/produtos'),
];

const storeBrands = [
  FlenxBrandItem(icon: '🎧', label: 'Áudio', href: '/produtos'),
  FlenxBrandItem(icon: '⌨️', label: 'Teclados', href: '/produtos'),
  FlenxBrandItem(icon: '🖥️', label: 'Monitores', href: '/produtos'),
  FlenxBrandItem(icon: '🪑', label: 'Cadeiras', href: '/produtos'),
  FlenxBrandItem(icon: '🖱️', label: 'Mouses', href: '/produtos'),
  FlenxBrandItem(icon: '📷', label: 'Webcams', href: '/produtos'),
];

const storeBenefits = [
  FlenxBenefit(icon: '🚚', title: 'Entrega expressa', subtitle: 'a partir de 1 dia útil'),
  FlenxBenefit(icon: '💳', title: 'Parcele em até 10x', subtitle: 'sem juros no cartão'),
  FlenxBenefit(icon: '🔁', title: 'Troca fácil', subtitle: 'até 30 dias'),
  FlenxBenefit(icon: '🔒', title: 'Compra segura', subtitle: 'site protegido'),
];

const storeFooterColumns = [
  FlenxFooterColumn('Institucional', [
    MenuLink(label: 'Sobre a Flenx Store', href: '/produtos'),
    MenuLink(label: 'Trabalhe conosco', href: '/produtos'),
    MenuLink(label: 'Marcas', href: '/produtos'),
    MenuLink(label: 'Blog', href: '/produtos'),
  ]),
  FlenxFooterColumn('Atendimento', [
    MenuLink(label: 'Trocas e devoluções', href: '/produtos'),
    MenuLink(label: 'Entregas', href: '/produtos'),
    MenuLink(label: 'Minha conta', href: '/admin'),
    MenuLink(label: 'Meus pedidos', href: '/admin'),
  ]),
  FlenxFooterColumn('Políticas', [
    MenuLink(label: 'Privacidade', href: '/produtos'),
    MenuLink(label: 'Termos de uso', href: '/produtos'),
    MenuLink(label: 'Segurança', href: '/produtos'),
  ]),
];

const _brands = {
  'fone-bluetooth': 'SoundPro',
  'teclado-mecanico': 'KeyForge',
  'mouse-sem-fio': 'ErgoTech',
  'monitor-27': 'VisionX',
  'webcam-full-hd': 'ClearCam',
  'cadeira-gamer': 'SitMax',
};

String _money(double v) => 'R\$ ${v.toStringAsFixed(2).replaceAll('.', ',')}';

/// Converte um [Product] no card do kit de e-commerce (com desconto/parcelas
/// derivados para o exemplo).
FlenxProductCard productCard(Product p) {
  final old = p.price * 1.28;
  final disc = (((old - p.price) / old) * 100).round();
  final inst = p.price / 10;
  return FlenxProductCard(
    name: p.name,
    emoji: p.emoji,
    brand: _brands[p.slug] ?? 'FLENX',
    price: _money(p.price),
    oldPrice: _money(old),
    installment: '10x de ${_money(inst)} sem juros',
    badge: '-$disc% OFF',
    href: '/produto/${p.slug}',
    buyHref: '/carrinho?add=${p.slug}',
  );
}

/// Detalhe completo do produto (página `/produto/<slug>`).
FlenxProductDetail productDetail(Product p) {
  final old = p.price * 1.28;
  final disc = (((old - p.price) / old) * 100).round();
  final inst = p.price / 10;
  final wa = 'https://wa.me/5511999999999?text=Quero%20o%20${p.name}';
  return FlenxProductDetail(
    name: p.name,
    brand: _brands[p.slug] ?? 'FLENX',
    emoji: p.emoji,
    price: _money(p.price),
    oldPrice: _money(old),
    installment: '10x de ${_money(inst)} sem juros',
    badge: '-$disc% OFF',
    description: p.description,
    buyHref: '/carrinho?add=${p.slug}',
    secondaryHref: wa,
    secondaryLabel: 'Comprar no WhatsApp',
    breadcrumb: const [
      MenuLink(label: 'Início', href: '/'),
      MenuLink(label: 'Produtos', href: '/produtos'),
    ],
  );
}
