import 'notification_channel.dart';
import 'notification_message.dart';

/// Central de notificações: ao notificar, **dispara para todos os canais
/// ativos** automaticamente. Erros de um canal não afetam os outros.
class NotificationCenter {
  const NotificationCenter(this.channels);

  final List<NotificationChannel> channels;

  /// Canais atualmente ativos (configurados).
  List<NotificationChannel> get active =>
      channels.where((c) => c.enabled).toList(growable: false);

  /// Envia [message] por **todos os canais ativos**; retorna o resultado de cada um.
  Future<List<ChannelResult>> notifyAll(NotificationMessage message) async {
    final results = <ChannelResult>[];
    for (final c in active) {
      try {
        await c.send(message);
        results.add(ChannelResult(c.name, true));
      } catch (e) {
        results.add(ChannelResult(c.name, false, '$e'));
      }
    }
    return results;
  }
}
