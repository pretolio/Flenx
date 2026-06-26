/// Configuração personalizável do site institucional (contato, WhatsApp, leads).
/// Tudo tem default pronto; o usuário troca o que quiser.
class SiteConfig {
  const SiteConfig({
    this.whatsappNumber = '5511999999999',
    this.whatsappMessage = 'Olá! Vim pelo site do Flenx e quero saber mais.',
    this.leadAction = '/api/leads',
    this.contactEmail = 'contato@flenx.dev',
  });

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
