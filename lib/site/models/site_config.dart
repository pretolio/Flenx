import 'login_option.dart';
import 'menu_link.dart';
import 'site_brand.dart';

/// Configuração central do site institucional: marca, nav, contato e WhatsApp.
class SiteConfig {
  const SiteConfig({
    this.brand = const SiteBrand(label: 'Site', homeHref: '/'),
    this.links = const [],
    this.loginLabel = 'Entrar',
    this.loginOptions = const [],
    this.whatsappNumber = '5511999999999',
    this.whatsappMessage = 'Olá! Vim pelo site e quero saber mais.',
    this.leadAction = '/api/leads',
    this.contactEmail = 'contato@flenx.dev',
  });

  final SiteBrand brand;
  final List<MenuLink> links;
  final String loginLabel;
  final List<LoginOption> loginOptions;

  /// Número no formato internacional, só dígitos (ex.: 55 + DDD + número).
  final String whatsappNumber;

  /// Mensagem pré-preenchida ao abrir o WhatsApp.
  final String whatsappMessage;

  /// Endpoint que recebe o POST do formulário de leads.
  final String leadAction;

  final String contactEmail;

  /// URL pronta do WhatsApp (wa.me) com a mensagem codificada.
  String get whatsappUrl =>
      'https://wa.me/$whatsappNumber?text=${Uri.encodeComponent(whatsappMessage)}';
}
