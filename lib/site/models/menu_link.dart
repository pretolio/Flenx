/// Item do menu de topo institucional. Pode ser um link simples (clicável) ou
/// um item expansível (dropdown) quando tem [children]. Menu 100% customizável.
class MenuLink {
  const MenuLink({
    required this.label,
    this.href,
    this.children = const [],
    this.external = false,
  });

  final String label;

  /// Destino do link. Nulo quando é só o "pai" de um dropdown.
  final String? href;

  /// Subitens — se não vazio, o item vira dropdown expansível.
  final List<MenuLink> children;

  /// Abre em nova aba (`target=_blank`) se externo.
  final bool external;

  bool get isDropdown => children.isNotEmpty;
}
