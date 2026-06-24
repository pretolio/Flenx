import 'package:flext/flext.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'sections/site_footer.dart';
import 'site_nav.dart';

/// Página de erro 404 padrão — usa o [SiteLayout] (header/rodapé/WhatsApp do site).
class NotFoundPage extends StatelessComponent {
  const NotFoundPage({this.config = const SiteConfig(), super.key});

  final SiteConfig config;

  @override
  Component build(BuildContext context) {
    return SiteLayout(
      brand: siteBrand,
      links: siteNavLinks,
      loginOptions: siteLoginOptions,
      footer: const SiteFooter(),
      config: config,
      child: section(classes: 'section', [
        div(classes: 'container', [
          div(classes: 'notfound', [
            div(classes: 'nf-code', [.text('404')]),
            h1([.text('Página não encontrada')]),
            p([
              .text('O link que você acessou não existe ou foi movido. '
                  'Confira o endereço ou volte para o início.'),
            ]),
            div(classes: 'nf-actions', [
              a([.text('Voltar ao início')], href: '/', classes: 'btn btn-primary'),
              a([.text('Ver o blog')], href: '/blog', classes: 'btn btn-soft'),
            ]),
          ]),
        ]),
      ]),
    );
  }
}
