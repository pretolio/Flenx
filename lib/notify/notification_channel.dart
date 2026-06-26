import 'notification_message.dart';

/// Um meio de notificação (push, SMS, WhatsApp, e-mail...). Implemente para
/// adicionar canais. [enabled] indica se está configurado/ativo.
abstract interface class NotificationChannel {
  /// Nome do canal (ex.: 'twilio-sms', 'fcm').
  String get name;

  /// Ativo? (ex.: credenciais presentes no `.env`). Só os ativos disparam.
  bool get enabled;

  Future<void> send(NotificationMessage message);
}

/// Resultado do envio por um canal.
class ChannelResult {
  const ChannelResult(this.channel, this.ok, [this.error]);
  final String channel;
  final bool ok;
  final String? error;
}
