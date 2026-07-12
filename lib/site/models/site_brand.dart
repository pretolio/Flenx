/// Identidade da marca no header: logo (imagem ou texto) com link para a home.
class SiteBrand {
  const SiteBrand({
    required this.label,
    this.homeHref = '/',
    this.logoSrc,
    this.logoSrcset,
    this.logoHeight,
  });

  /// Texto exibido (e usado como alt do logo).
  final String label;

  /// Destino do clique no logo — por padrão a home.
  final String homeHref;

  /// Caminho da imagem do logo. Se nulo, mostra o [label] como texto.
  final String? logoSrc;

  /// `srcset` opcional para servir variantes por densidade (ex.:
  /// `'logo-1x.webp 1x, logo-2x.webp 2x'`). Telas 1x baixam a menor.
  final String? logoSrcset;

  /// Altura do logo no header, em px. Null = padrão (32px). Evita CSS no app.
  final double? logoHeight;
}
