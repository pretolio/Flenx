import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../models/menu_link.dart';

/// Lista de links do menu de topo. Cada item é um link simples (clicável) ou,
/// se tiver filhos, um item expansível (dropdown).
class NavLinks extends StatelessComponent {
  const NavLinks(this.links, {super.key});

  final List<MenuLink> links;

  @override
  Component build(BuildContext context) {
    return ul(classes: 'nav-list', [
      for (final link in links)
        li(classes: link.isDropdown ? 'nav-item has-dropdown' : 'nav-item', [
          if (link.isDropdown) ...[
            span(classes: 'nav-link nav-parent', [
              .text(link.label),
              span(classes: 'caret', [.text('▾')]),
            ]),
            ul(classes: 'dropdown', [
              for (final child in link.children) li([_anchor(child)]),
            ]),
          ] else
            _anchor(link, cls: 'nav-link'),
        ]),
    ]);
  }

  Component _anchor(MenuLink l, {String? cls}) => a(
    [.text(l.label)],
    href: l.href ?? '#',
    classes: cls,
    target: l.external ? Target.blank : null,
  );
}
