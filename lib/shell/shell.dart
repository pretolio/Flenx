/// Shell de navegação responsivo do Flenx: sidebar/drawer + top bar com
/// perfil e notificações. Reutilizável no app mobile e na web (ilha Flutter).
library;

export 'models/app_notification.dart';
export 'models/app_user.dart';
export 'models/nav_item.dart';
export 'models/dashboard_stat.dart';
export 'models/activity_item.dart';
export 'utils/shell_breakpoints.dart';
export 'flenx_admin_theme.dart';
export 'flenx_admin_app.dart';
export 'components/app_shell.dart';
export 'components/sidebar.dart';
export 'components/top_bar.dart';
export 'components/notification_button.dart';
export 'components/profile_menu.dart';
// Blocos de dashboard reutilizáveis
export 'components/flenx_dashboard.dart';
export 'components/stat_card.dart';
export 'components/card_panel.dart';
export 'components/icon_chip.dart';
export 'components/section_placeholder.dart';

// Kit de admin genérico: CRUD declarativo, permissões/papéis e editor de home.
export 'admin/admin_rest_client.dart';
export 'admin/app_permission.dart';
export 'admin/resource_field.dart';
export 'admin/resource_config.dart';
export 'admin/resource_form_dialog.dart';
export 'admin/flenx_resource_page.dart';
export 'admin/settings_field.dart';
export 'admin/flenx_settings_page.dart';

// Editor de posts/notícias estilo G1 (criar/editar/listar) reutilizável.
export 'blog_editor/block_type.dart';
export 'blog_editor/editable_block.dart';
export 'blog_editor/block_card.dart';
export 'blog_editor/post_meta_form.dart';
export 'blog_editor/post_editor_page.dart';
export 'blog_editor/blog_admin_page.dart';
