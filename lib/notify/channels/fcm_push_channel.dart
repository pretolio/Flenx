import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../notification_channel.dart';
import '../notification_message.dart';

/// Canal de push via Firebase Cloud Messaging (FCM). Ativo quando há
/// `FCM_SERVER_KEY` no `.env`. Envia para o `deviceToken` da mensagem.
class FcmPushChannel implements NotificationChannel {
  const FcmPushChannel({required this.serverKey, this.client});

  final String serverKey;
  final http.Client? client;

  factory FcmPushChannel.fromEnv([Map<String, String>? env]) =>
      FcmPushChannel(serverKey: (env ?? Platform.environment)['FCM_SERVER_KEY'] ?? '');

  @override
  String get name => 'fcm';

  @override
  bool get enabled => serverKey.isNotEmpty;

  @override
  Future<void> send(NotificationMessage m) async {
    if (m.deviceToken == null || m.deviceToken!.isEmpty) return;
    final c = client ?? http.Client();
    try {
      final res = await c.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Authorization': 'key=$serverKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'to': m.deviceToken,
          'notification': {'title': m.title, 'body': m.body},
          if (m.data.isNotEmpty) 'data': m.data,
        }),
      );
      if (res.statusCode >= 400) {
        throw Exception('FCM ${res.statusCode}: ${res.body}');
      }
    } finally {
      if (client == null) c.close();
    }
  }
}
