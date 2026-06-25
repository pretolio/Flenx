import 'package:flext/flext.dart';
import 'package:jaspr/jaspr.dart';

import 'sections/site_footer.dart';
import 'site_nav.dart';

/// Página 404 do demo: usa o genérico [FlextNotFound] da lib, passando a marca,
/// os menus, o rodapé e dois botões (início + blog).
class NotFoundPage extends StatelessComponent {
  const NotFoundPage({super.key});

  @override
  Component build(BuildContext context) {
    return FlextNotFound(
      brand: siteBrand,
      links: siteNavLinks,
      loginOptions: siteLoginOptions,
      footer: const SiteFooter(),
      actions: const [
        MenuLink(label: 'Voltar ao início', href: '/'),
        MenuLink(label: 'Ver o blog', href: '/blog'),
      ],
    );
  }
}
