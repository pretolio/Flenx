import 'dart:convert';

import 'package:http/http.dart' as http;

/// Envia uma mensagem via API do Twilio (SMS/WhatsApp). Usado pelos canais
/// Twilio. Lança em erro HTTP (>=400).
Future<void> sendTwilioMessage({
  required String accountSid,
  required String authToken,
  required String from,
  required String to,
  required String body,
  http.Client? client,
}) async {
  final c = client ?? http.Client();
  try {
    final auth = base64Encode(utf8.encode('$accountSid:$authToken'));
    final res = await c.post(
      Uri.parse(
          'https://api.twilio.com/2010-04-01/Accounts/$accountSid/Messages.json'),
      headers: {'Authorization': 'Basic $auth'},
      body: {'From': from, 'To': to, 'Body': body},
    );
    if (res.statusCode >= 400) {
      throw Exception('Twilio ${res.statusCode}: ${res.body}');
    }
  } finally {
    if (client == null) c.close();
  }
}
