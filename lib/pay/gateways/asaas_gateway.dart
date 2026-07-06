import 'dart:convert';

import 'package:http/http.dart' as http;

import '../payment_gateway.dart';
import '../payment_request.dart';
import '../payment_result.dart';

/// Gateway do **Asaas** (link de pagamento — Pix/cartão/boleto).
///
/// Credenciais: `ASAAS_API_KEY` e `ASAAS_ENV` (`sandbox` ou `production`).
class AsaasGateway implements PaymentGateway {
  AsaasGateway({required this.apiKey, this.sandbox = true, http.Client? client})
    : _client = client ?? http.Client();

  factory AsaasGateway.fromEnv(
    Map<String, String> env, {
    http.Client? client,
  }) => AsaasGateway(
    apiKey: env['ASAAS_API_KEY'] ?? '',
    sandbox: (env['ASAAS_ENV'] ?? 'sandbox') != 'production',
    client: client,
  );

  final String apiKey;
  final bool sandbox;
  final http.Client _client;

  String get _base =>
      sandbox ? 'https://sandbox.asaas.com/api/v3' : 'https://api.asaas.com/v3';

  @override
  String get name => 'asaas';

  @override
  bool get enabled => apiKey.isNotEmpty;

  @override
  Future<PaymentResult> createCheckout(PaymentRequest req) async {
    final body = {
      'name': req.description,
      'billingType': 'UNDEFINED', // cliente escolhe Pix/cartão/boleto
      'chargeType': 'DETACHED',
      'value': req.amount,
      if (req.externalReference != null)
        'externalReference': req.externalReference,
    };
    final res = await _client.post(
      Uri.parse('$_base/paymentLinks'),
      headers: {'access_token': apiKey, 'content-type': 'application/json'},
      body: jsonEncode(body),
    );
    if (res.statusCode >= 400) {
      throw Exception('Asaas ${res.statusCode}: ${res.body}');
    }
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    return PaymentResult(
      id: '${json['id']}',
      checkoutUrl: '${json['url'] ?? ''}',
      raw: json,
    );
  }

  @override
  PaymentStatus statusFromWebhook(Map<String, dynamic> payload) {
    final event = '${payload['event'] ?? ''}';
    return switch (event) {
      'PAYMENT_CONFIRMED' || 'PAYMENT_RECEIVED' => PaymentStatus.paid,
      'PAYMENT_REFUNDED' => PaymentStatus.refunded,
      'PAYMENT_DELETED' || 'PAYMENT_OVERDUE' => PaymentStatus.canceled,
      'PAYMENT_CREATED' ||
      'PAYMENT_AWAITING_RISK_ANALYSIS' => PaymentStatus.pending,
      _ => PaymentStatus.unknown,
    };
  }
}
