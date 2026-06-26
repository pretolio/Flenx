import 'dart:convert';

import 'package:flenx/pay/pay.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  const req = PaymentRequest(
    amount: 49.90,
    description: 'Plano Pro',
    customerEmail: 'cliente@ex.com',
    externalReference: 'pedido-1',
  );

  group('Seleção de provedor por .env', () {
    test('escolhe Mercado Pago e detecta credencial', () {
      final s = PaymentService.fromEnv({
        'PAYMENT_PROVIDER': 'mercadopago',
        'MP_ACCESS_TOKEN': 'TEST-123',
      });
      expect(s.provider, 'mercadopago');
      expect(s.configured, isTrue);
    });

    test('escolhe Asaas; sem chave fica não configurado', () {
      final s = PaymentService.fromEnv({'PAYMENT_PROVIDER': 'asaas'});
      expect(s.provider, 'asaas');
      expect(s.configured, isFalse);
    });

    test('provider inválido lança erro', () {
      expect(() => PaymentService.fromEnv({'PAYMENT_PROVIDER': 'paypal'}),
          throwsArgumentError);
    });

    test('provedor CUSTOM registrado pluga sem alterar a lib', () async {
      PaymentRegistry.register('fake', (env, client) => _FakeGateway());
      expect(PaymentRegistry.available, contains('fake'));

      final s = PaymentService.fromEnv({'PAYMENT_PROVIDER': 'fake'});
      expect(s.provider, 'fake');
      expect(s.configured, isTrue);
      final r = await s.checkout(req);
      expect(r.checkoutUrl, 'https://fake/pay');
    });
  });

  group('Mercado Pago', () {
    test('cria checkout: monta preference e lê init_point', () async {
      late http.Request captured;
      final client = MockClient((r) async {
        captured = r;
        return http.Response(
            jsonEncode({'id': 'pref_9', 'init_point': 'https://mp/checkout/9'}),
            201);
      });
      final s = PaymentService(
          MercadoPagoGateway(accessToken: 'TOK', client: client));

      final res = await s.checkout(req);

      expect(res.checkoutUrl, 'https://mp/checkout/9');
      expect(res.id, 'pref_9');
      expect(captured.headers['authorization'], 'Bearer TOK');
      final body = jsonDecode(captured.body) as Map<String, dynamic>;
      expect((body['items'] as List).first['unit_price'], 49.90);
      expect(body['external_reference'], 'pedido-1');
    });

    test('webhook approved -> paid', () {
      final g = MercadoPagoGateway(accessToken: 'x');
      expect(g.statusFromWebhook({'status': 'approved'}), PaymentStatus.paid);
    });
  });

  group('Asaas', () {
    test('cria checkout: usa paymentLinks e header access_token', () async {
      late http.Request captured;
      final client = MockClient((r) async {
        captured = r;
        return http.Response(
            jsonEncode({'id': 'pl_1', 'url': 'https://asaas/l/1'}), 200);
      });
      final s = PaymentService(AsaasGateway(apiKey: 'KEY', client: client));

      final res = await s.checkout(req);

      expect(res.checkoutUrl, 'https://asaas/l/1');
      expect(captured.headers['access_token'], 'KEY');
      expect(captured.url.toString(), contains('sandbox.asaas.com'));
    });

    test('webhook PAYMENT_RECEIVED -> paid', () {
      final g = AsaasGateway(apiKey: 'x');
      expect(g.statusFromWebhook({'event': 'PAYMENT_RECEIVED'}),
          PaymentStatus.paid);
    });
  });

  test('checkout sem credencial lança StateError', () {
    final s = PaymentService(AsaasGateway(apiKey: ''));
    expect(() => s.checkout(req), throwsStateError);
  });
}

/// Provedor de exemplo plugado de fora da lib.
class _FakeGateway implements PaymentGateway {
  @override
  String get name => 'fake';
  @override
  bool get enabled => true;
  @override
  Future<PaymentResult> createCheckout(PaymentRequest request) async =>
      const PaymentResult(id: 'fk_1', checkoutUrl: 'https://fake/pay');
  @override
  PaymentStatus statusFromWebhook(Map<String, dynamic> payload) =>
      PaymentStatus.paid;
}
