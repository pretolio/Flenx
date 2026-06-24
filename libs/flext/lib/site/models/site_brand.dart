/// Identidade da marca no header: logo (imagem ou texto) com link para a home.
class SiteBrand {
  const SiteBrand({
    required this.label,
    this.homeHref = '/',
    this.logoSrc,
  });

  /// Texto exibido (e usado como alt do logo).
  final String label;

  /// Destino do clique no logo — por padrão a home.
  final String homeHref;

  /// Caminho da imagem do logo. Se nulo, mostra o [label] como texto.
  final String? logoSrc;
}
