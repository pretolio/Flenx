/// Papel de usuário no admin: um nome e o conjunto de permissões. `*` libera
/// tudo. Use [AdminPermissions] para os papéis e permissões padrão, ou crie os
/// seus. O [FlenxAdminApp] esconde itens de menu que o papel não pode acessar.
class AppRole {
  const AppRole(this.name, this.permissions);

  final String name;
  final Set<String> permissions;

  /// O papel pode acessar [permission]? (`*` = acesso total.)
  bool can(String? permission) {
    if (permission == null) return true; // item sem restrição
    return permissions.contains('*') || permissions.contains(permission);
  }

  static AppRole byName(String? name, {AppRole fallback = AdminPermissions.viewer}) {
    for (final r in AdminPermissions.all) {
      if (r.name.toLowerCase() == name?.toLowerCase()) return r;
    }
    return fallback;
  }
}

/// Permissões e papéis padrão do Flenx (sirva-se ou defina os seus).
abstract final class AdminPermissions {
  static const manageContent = 'content.manage'; // posts/notícias
  static const manageProducts = 'products.manage';
  static const manageOrders = 'orders.manage';
  static const manageUsers = 'users.manage';
  static const editHome = 'home.edit';
  static const settings = 'settings.manage';

  /// Acesso total.
  static const admin = AppRole('Administrador', {'*'});

  /// Conteúdo e home, sem usuários nem configurações sensíveis.
  static const editor = AppRole('Editor', {
    manageContent,
    manageProducts,
    manageOrders,
    editHome,
  });

  /// Só leitura (nenhuma permissão de gestão).
  static const viewer = AppRole('Visualizador', {});

  static const all = [admin, editor, viewer];

  /// Nomes dos papéis (para selects de formulário).
  static const roleNames = ['Administrador', 'Editor', 'Visualizador'];
}
