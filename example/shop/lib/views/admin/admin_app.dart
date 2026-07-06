import 'package:flenx/shell.dart';
import 'package:flutter/material.dart';

/// Admin da loja — preenche o [FlenxAdminApp] da lib com as telas prontas
/// (CRUD genérico de produtos/pedidos/usuários, editor da home e dashboard).
/// O menu é filtrado pelas permissões do papel ([role]).
class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  static const _user = AppUser(
    name: 'Gabriel Potenza',
    role: 'Administrador',
    email: 'admin@flenxstore.com',
  );

  static const _navItems = [
    NavItem(label: 'Dashboard', icon: Icons.dashboard_outlined, route: '/'),
    NavItem(
      label: 'Produtos',
      icon: Icons.inventory_2_outlined,
      route: '/products',
      permission: AdminPermissions.manageProducts,
    ),
    NavItem(
      label: 'Pedidos',
      icon: Icons.receipt_long_outlined,
      route: '/orders',
      permission: AdminPermissions.manageOrders,
    ),
    NavItem(
      label: 'Usuários',
      icon: Icons.people_outline,
      route: '/users',
      permission: AdminPermissions.manageUsers,
    ),
    NavItem(
      label: 'Tela inicial',
      icon: Icons.home_outlined,
      route: '/home',
      permission: AdminPermissions.editHome,
    ),
    NavItem(
      label: 'Configurações',
      icon: Icons.settings_outlined,
      route: '/settings',
      permission: AdminPermissions.settings,
    ),
  ];

  static const _stats = [
    DashboardStat(
      icon: Icons.inventory_2_outlined,
      label: 'Produtos',
      value: '6',
      trend: 'catálogo',
    ),
    DashboardStat(
      icon: Icons.receipt_long_outlined,
      label: 'Pedidos',
      value: '—',
      trend: 'hoje',
    ),
    DashboardStat(
      icon: Icons.attach_money,
      label: 'Faturamento',
      value: 'R\$ —',
      trend: 'mês',
    ),
    DashboardStat(
      icon: Icons.people_outline,
      label: 'Usuários',
      value: '2',
      trend: '',
    ),
  ];

  static const _activity = [
    ActivityItem(
      icon: Icons.shopping_cart_outlined,
      title: 'Carrinho finalizado',
      subtitle: 'veja em Pedidos',
    ),
    ActivityItem(
      icon: Icons.inventory_2_outlined,
      title: 'Catálogo no banco',
      subtitle: 'edite em Produtos',
    ),
  ];

  ResourceConfig get _products => const ResourceConfig(
    title: 'Produtos',
    singular: 'produto',
    titleKey: 'name',
    subtitleKey: 'summary',
    listPath: '/api/products/list',
    createPath: '/api/products',
    updatePath: '/api/products/update',
    deletePath: '/api/products/delete',
    fields: [
      ResourceField('name', 'Nome', required: true, inTable: true),
      ResourceField('slug', 'Slug (URL)', required: true),
      ResourceField(
        'price',
        'Preço (ex.: 199.90)',
        kind: FieldKind.number,
        required: true,
      ),
      ResourceField('emoji', 'Emoji/ícone'),
      ResourceField('tag', 'Selo (ex.: Novo)'),
      ResourceField('summary', 'Resumo'),
      ResourceField('description', 'Descrição', kind: FieldKind.multiline),
      ResourceField('image', 'URL da imagem'),
      ResourceField('active', 'Ativo', kind: FieldKind.boolean),
    ],
  );

  ResourceConfig get _orders => const ResourceConfig(
    title: 'Pedidos',
    singular: 'pedido',
    titleKey: 'customer_name',
    subtitleKey: 'status',
    listPath: '/api/orders/list',
    updatePath: '/api/orders/update',
    deletePath: '/api/orders/delete',
    fields: [
      ResourceField('customer_name', 'Cliente'),
      ResourceField('customer_email', 'E-mail'),
      ResourceField('total', 'Total'),
      ResourceField(
        'status',
        'Status',
        kind: FieldKind.select,
        options: ['Novo', 'Pago', 'Enviado', 'Concluído', 'Cancelado'],
      ),
      ResourceField('items', 'Itens (JSON)', kind: FieldKind.multiline),
    ],
  );

  ResourceConfig get _users => const ResourceConfig(
    title: 'Usuários',
    singular: 'usuário',
    titleKey: 'name',
    subtitleKey: 'email',
    listPath: '/api/users/list',
    createPath: '/api/users',
    updatePath: '/api/users/update',
    deletePath: '/api/users/delete',
    fields: [
      ResourceField('name', 'Nome', required: true, inTable: true),
      ResourceField('email', 'E-mail', required: true),
      ResourceField(
        'role',
        'Papel',
        kind: FieldKind.select,
        options: AdminPermissions.roleNames,
      ),
      ResourceField('active', 'Ativo', kind: FieldKind.boolean),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return FlenxAdminApp(
      title: 'Flenx Store — Admin',
      user: _user,
      role: AdminPermissions.admin,
      navItems: _navItems,
      pages: {
        '/': (c) => const FlenxDashboard(
          stats: _stats,
          activity: _activity,
          greeting: 'Olá, Gabriel 👋',
          subtitle: 'Resumo da sua loja.',
        ),
        '/products': (c) => FlenxResourcePage(config: _products),
        '/orders': (c) => FlenxResourcePage(config: _orders),
        '/users': (c) => FlenxResourcePage(config: _users),
        '/home': (c) => const FlenxSettingsPage(
          title: 'Tela inicial',
          fields: [
            SettingField('hero_title', 'Título de destaque'),
            SettingField('hero_subtitle', 'Subtítulo', multiline: true),
            SettingField('hero_cta', 'Texto do botão (CTA)'),
          ],
        ),
        '/settings': (c) =>
            const SectionPlaceholder('Configurações', Icons.settings_outlined),
      },
    );
  }
}
