import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../models/login_option.dart';

/// Botão de login estilo botão. Se [options] estiver vazio é um link simples
/// (clicável); senão vira um botão expansível com as opções de login (dropdown).
class LoginButton extends StatelessComponent {
  const LoginButton({
    required this.label,
    this.href,
    this.options = const [],
    super.key,
  });

  final String label;
  final String? href;
  final List<LoginOption> options;

  @override
  Component build(BuildContext context) {
    if (options.isEmpty) {
      return a([.text(label)], href: href ?? '/login', classes: 'login-btn');
    }
    return div(classes: 'login-menu has-dropdown', [
      span(classes: 'login-btn', [
        .text(label),
        span(classes: 'caret', [.text('▾')]),
      ]),
      ul(classes: 'dropdown dropdown-right', [
        for (final o in options) li([a([.text(o.label)], href: o.href)]),
      ]),
    ]);
  }
}
