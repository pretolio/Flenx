import 'dart:io';

import '../notification_channel.dart';
import '../notification_message.dart';
import 'twilio_client.dart';

/// Canal de WhatsApp via Twilio (prefixo `whatsapp:`). Ativo quando há
/// credenciais no `.env` (`TWILIO_SID`, `TWILIO_TOKEN`, `TWILIO_WHATSAPP_FROM`).
class TwilioWhatsappChannel implements NotificationChannel {
  const TwilioWhatsappChannel({
    required this.accountSid,
    required this.authToken,
    required this.from,
  });

  final String accountSid;
  final String authToken;
  final String from;

  factory TwilioWhatsappChannel.fromEnv([Map<String, String>? env]) {
    final e = env ?? Platform.environment;
    return TwilioWhatsappChannel(
      accountSid: e['TWILIO_SID'] ?? '',
      authToken: e['TWILIO_TOKEN'] ?? '',
      from: e['TWILIO_WHATSAPP_FROM'] ?? '',
    );
  }

  @override
  String get name => 'twilio-whatsapp';

  @override
  bool get enabled =>
      accountSid.isNotEmpty && authToken.isNotEmpty && from.isNotEmpty;

  @override
  Future<void> send(NotificationMessage m) async {
    if (m.phone == null || m.phone!.isEmpty) return;
    await sendTwilioMessage(
      accountSid: accountSid,
      authToken: authToken,
      from: 'whatsapp:$from',
      to: 'whatsapp:${m.phone}',
      body: '${m.title}\n${m.body}',
    );
  }
}
