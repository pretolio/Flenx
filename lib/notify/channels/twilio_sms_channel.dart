import '../../core/platform_env.dart';

import '../notification_channel.dart';
import '../notification_message.dart';
import 'twilio_client.dart';

/// Canal de SMS via Twilio. Ativo quando há credenciais no `.env`
/// (`TWILIO_SID`, `TWILIO_TOKEN`, `TWILIO_FROM`).
class TwilioSmsChannel implements NotificationChannel {
  const TwilioSmsChannel({
    required this.accountSid,
    required this.authToken,
    required this.from,
  });

  final String accountSid;
  final String authToken;
  final String from;

  factory TwilioSmsChannel.fromEnv([Map<String, String>? env]) {
    final e = env ?? platformEnv;
    return TwilioSmsChannel(
      accountSid: e['TWILIO_SID'] ?? '',
      authToken: e['TWILIO_TOKEN'] ?? '',
      from: e['TWILIO_FROM'] ?? '',
    );
  }

  @override
  String get name => 'twilio-sms';

  @override
  bool get enabled =>
      accountSid.isNotEmpty && authToken.isNotEmpty && from.isNotEmpty;

  @override
  Future<void> send(NotificationMessage m) async {
    if (m.phone == null || m.phone!.isEmpty) return;
    await sendTwilioMessage(
      accountSid: accountSid,
      authToken: authToken,
      from: from,
      to: m.phone!,
      body: '${m.title}\n${m.body}',
    );
  }
}
