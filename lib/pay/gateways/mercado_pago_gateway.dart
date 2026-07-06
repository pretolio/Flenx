import 'dart:convert';

import 'package:http/http.dart' as http;

import '../payment_gateway.dart';
import '../payment_request.dart';
import '../payment_result.dart';

/// Gateway do **Mercado Pago** (Checkout Pro via Preferences).
///
/// Credencial: `MP_ACCESS_TOKEN` (Bearer).
class MercadoPagoGateway implements PaymentGateway {
  MercadoPagoGateway({required this.accessToken, http.Client? client})
    : _client = client ?? http.Client();

  /// Lê a credencial do ambiente (lado servidor, via `.env`).
  factory MercadoPagoGateway.fromEnv(
    Map<String, String> env, {
    http.Client? client,
  }) => MercadoPagoGateway(
    accessToken: env['MP_ACCESS_TOKEN'] ?? '',
    client: client,
  );

  final String accessToken;
  final http.Client _client;

  static const _base = 'https://api.mercadopago.com';

  @override
  String get name => 'mercadopago';

  @override
  bool get enabled => accessToken.isNotEmpty;

  @override
  Future<PaymentResult> createCheckout(PaymentRequest req) async {
    final body = {
      'items': [
        {
          'title': req.description,
          'quantity': 1,
          'unit_price': req.amount,
          'currency_id': 'BRL',
        },
      ],
      'payer': {'email': req.customerEmail},
      if (req.externalReference != null)
        'external_reference': req.externalReference,
      if (req.successUrl != null || req.failureUrl != null)
        'back_urls': {
          if (req.successUrl != null) 'success': req.successUrl,
          if (req.failureUrl != null) 'failure': req.failureUrl,
        },
    };
    final res = await _client.post(
      Uri.parse('$_base/checkout/preferences'),
      headers: {
        'authorization': 'Bearer $accessToken',
        'content-type': 'application/json',
      },
      body: jsonEncode(body),
    );
    if (res.statusCode >= 400) {
      throw Exception('Mercado Pago ${res.statusCode}: ${res.body}');
    }
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    return PaymentResult(
      id: '${json['id']}',
      checkoutUrl: '${json['init_point'] ?? json['sandbox_init_point'] ?? ''}',
      raw: json,
    );
  }

  @override
  PaymentStatus statusFromWebhook(Map<String, dynamic> payload) {
    // MP envia status em data.status quando disponível; senão exige consulta.
    final status =
        '${payload['status'] ?? (payload['data'] is Map ? (payload['data'] as Map)['status'] : '')}';
    return switch (status) {
      'approved' => PaymentStatus.paid,
      'rejected' || 'cancelled' => PaymentStatus.failed,
      'refunded' || 'charged_back' => PaymentStatus.refunded,
      'pending' || 'in_process' => PaymentStatus.pending,
      _ => PaymentStatus.unknown,
    };
  }
}
