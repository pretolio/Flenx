/// Uma pílula de preço (ex.: "A PARTIR DE R$ 99,90").
class FlenxPricePill {
  const FlenxPricePill({
    required this.value,
    required this.href,
    this.label = 'A PARTIR DE',
  });
  final String label;
  final String value;
  final String href;
}

/// Um item da tira de marcas/departamentos.
class FlenxBrandItem {
  const FlenxBrandItem({
    required this.icon,
    required this.label,
    required this.href,
  });
  final String icon;
  final String label;
  final String href;
}

/// Um slide do hero/carrossel da loja.
class FlenxHeroSlide {
  const FlenxHeroSlide({
    required this.title,
    required this.ctaHref,
    this.eyebrow,
    this.subtitle,
    this.priceFrom,
    this.priceValue,
    this.ctaLabel = 'aproveite',
    this.backgroundImage,
  });

  final String title;
  final String ctaHref;
  final String? eyebrow;
  final String? subtitle;
  final String? priceFrom;
  final String? priceValue;
  final String ctaLabel;

  /// URL da imagem de fundo do slide (com overlay escuro para legibilidade).
  final String? backgroundImage;
}

/// Um benefício exibido na faixa acima do rodapé.
class FlenxBenefit {
  const FlenxBenefit({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final String icon;
  final String title;
  final String subtitle;
}
