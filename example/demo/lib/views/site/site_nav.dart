import 'package:flenx/flenx.dart';

/// Navegação compartilhada do site (usada pelo header em todas as páginas:
/// home, blog, sobre, 404). Fonte única — editar aqui reflete em tudo.
const siteBrand = SiteBrand(label: 'Flenx', homeHref: '/');

const siteNavLinks = [
  MenuLink(label: 'Início', href: '/'),
  MenuLink(label: 'Recursos', href: '/#recursos'),
  MenuLink(label: 'Blog', children: [
    MenuLink(label: 'Todos os posts', href: '/blog'),
    MenuLink(label: 'Categorias', href: '/blog/categoria'),
    MenuLink(label: 'Tags', href: '/blog/tag'),
  ]),
  MenuLink(label: 'Sobre', href: '/about'),
  MenuLink(label: 'Contato', href: '/#contato'),
];

const siteLoginOptions = [
  LoginOption(label: 'Entrar', href: '/admin'),
  LoginOption(label: 'Criar conta', href: '/signup'),
];
