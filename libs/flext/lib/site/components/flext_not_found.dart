import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../models/login_option.dart';
import '../models/menu_link.dart';
import '../models/site_brand.dart';
import '../models/site_config.dart';
import '../site_layout.dart';

/// Página 404 pronta — usa o [SiteLayout] do site. Genérica e editável: textos
/// ([code], [title], [message]) e botões ([actions]) são personalizáveis.
/// O primeiro botão sai destacado; os demais, suaves.
class FlextNotFound extends StatelessComponent {
  const FlextNotFound({
    required this.brand,
    this.links = const [],
    this.loginOptions = const [],
    this.footer,
    this.config = const SiteConfig(),
    this.code = '404',
    this.title = 'Página não encontrada',
    this.message = 'O link que você acessou não existe ou foi movido. '
        'Confira o endereço ou volte para o início.',
    this.actions = const [MenuLink(label: 'Voltar ao início', href: '/')],
    super.key,
  });

  final SiteBrand brand;
  final List<MenuLink> links;
  final List<LoginOption> loginOptions;
  final Component? footer;
  final SiteConfig config;
  final String code;
  final String title;
  final String message;
  final List<MenuLink> actions;

  @override
  Component build(BuildContext context) {
    return SiteLayout(
      brand: brand,
      links: links,
      loginOptions: loginOptions,
      footer: footer,
      config: config,
      child: section(classes: 'section', [
        div(classes: 'container', [
          div(classes: 'notfound', [
            div(classes: 'nf-code', [.text(code)]),
            h1([.text(title)]),
            p([.text(message)]),
            div(classes: 'nf-actions', [
              for (var i = 0; i < actions.length; i++)
                a([.text(actions[i].label)],
                    href: actions[i].href ?? '/',
                    classes: i == 0 ? 'btn btn-primary' : 'btn btn-soft'),
            ]),
          ]),
        ]),
      ]),
    );
  }
}
