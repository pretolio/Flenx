import 'package:flutter_test/flutter_test.dart';
import 'package:flenx/notify/notify.dart';

class FakeChannel implements NotificationChannel {
  FakeChannel(this.name, this.enabled, {this.fail = false});
  @override
  final String name;
  @override
  final bool enabled;
  final bool fail;
  int sent = 0;

  @override
  Future<void> send(NotificationMessage message) async {
    if (fail) throw Exception('falha simulada');
    sent++;
  }
}

void main() {
  group('NotificationCenter', () {
    test('dispara para todos os canais ATIVOS e pula os inativos', () async {
      final ativo = FakeChannel('a', true);
      final inativo = FakeChannel('b', false);
      final center = NotificationCenter([ativo, inativo]);

      final res = await center.notifyAll(
        const NotificationMessage(title: 'Oi', body: 'teste'),
      );

      expect(ativo.sent, 1);
      expect(inativo.sent, 0); // inativo não dispara
      expect(center.active.length, 1);
      expect(res.single.channel, 'a');
      expect(res.single.ok, isTrue);
    });

    test('isola erro de um canal sem afetar os outros', () async {
      final ok = FakeChannel('ok', true);
      final ruim = FakeChannel('ruim', true, fail: true);
      final center = NotificationCenter([ruim, ok]);

      final res = await center.notifyAll(
        const NotificationMessage(title: 't', body: 'b'),
      );

      expect(ok.sent, 1); // o outro canal ainda envia
      final ruimRes = res.firstWhere((r) => r.channel == 'ruim');
      expect(ruimRes.ok, isFalse);
      expect(ruimRes.error, contains('falha'));
    });
  });
}
