import 'package:flenx/flenx.dart';

import 'sections/site_footer.dart';
import 'site_nav.dart';

/// Página 404 do demo: usa o genérico [FlenxNotFound] da lib, passando a marca,
/// os menus, o rodapé e dois botões (início + blog).
class NotFoundPage extends StatelessComponent {
  const NotFoundPage({super.key});

  @override
  Component build(BuildContext context) {
    return FlenxNotFound(
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
