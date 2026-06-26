/// Mensagem de notificação enviada a um ou mais meios. Carrega os destinos
/// possíveis (e-mail, telefone, device token) — cada canal usa o que precisa.
class NotificationMessage {
  const NotificationMessage({
    required this.title,
    required this.body,
    this.email,
    this.phone,
    this.deviceToken,
    this.data = const {},
  });

  final String title;
  final String body;
  final String? email;
  final String? phone;
  final String? deviceToken;
  final Map<String, String> data;
}
