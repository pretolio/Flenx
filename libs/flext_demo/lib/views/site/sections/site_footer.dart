import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Rodapé do site institucional.
class SiteFooter extends StatelessComponent {
  const SiteFooter({this.email = 'contato@flext.dev', super.key});

  final String email;

  @override
  Component build(BuildContext context) {
    return Component.element(tag: 'footer', classes: 'foot', children: [
      div(classes: 'container', [
        div(classes: 'foot-grid', [
          div([
            div(classes: 'brand', [.text('Flext')]),
            p([.text('Framework Flutter estilo Next.js, em Dart.')]),
          ]),
          div([
            h4([.text('Produto')]),
            a([.text('Recursos')], href: '#recursos'),
            a([.text('Blog')], href: '/blog'),
            a([.text('Admin')], href: '/admin'),
          ]),
          div([
            h4([.text('Empresa')]),
            a([.text('Sobre')], href: '/about'),
            a([.text('Contato')], href: '#contato'),
          ]),
          div([
            h4([.text('Recursos')]),
            a([.text('GitHub')], href: 'https://github.com/flext', target: Target.blank),
            a([.text(email)], href: 'mailto:$email'),
          ]),
        ]),
        div(classes: 'foot-bottom', [
          .text('© 2026 Flext. Feito com Dart, jaspr e Flutter.'),
        ]),
      ]),
    ]);
  }
}
