/// Uma pílula de preço (ex.: "A PARTIR DE R$ 99,90").
class FlenxPricePill {
  const FlenxPricePill({required this.value, required this.href, this.label = 'A PARTIR DE'});
  final String label;
  final String value;
  final String href;
}

/// Um item da tira de marcas/departamentos.
class FlenxBrandItem {
  const FlenxBrandItem({required this.icon, required this.label, required this.href});
  final String icon;
  final String label;
  final String href;
}

/// Um benefício exibido na faixa acima do rodapé.
class FlenxBenefit {
  const FlenxBenefit({required this.icon, required this.title, required this.subtitle});
  final String icon;
  final String title;
  final String subtitle;
}
