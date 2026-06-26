import 'package:http/http.dart' as http;

import 'payment_gateway.dart';
import 'payment_registry.dart';
import 'payment_request.dart';
import 'payment_result.dart';

/// Fachada de pagamento: o usuário só escolhe o provedor em `PAYMENT_PROVIDER`
/// (`asaas` | `mercadopago`) e adiciona a credencial correspondente no `.env`.
class PaymentService {
  const PaymentService(this.gateway);

  final PaymentGateway gateway;

  /// Seleciona o gateway pelo ambiente (lado servidor) via [PaymentRegistry].
  /// Provedores novos entram com `PaymentRegistry.register(...)`.
  factory PaymentService.fromEnv(Map<String, String> env, {http.Client? client}) {
    final provider = env['PAYMENT_PROVIDER'] ?? '';
    return PaymentService(
        PaymentRegistry.resolve(provider, env, client: client));
  }

  String get provider => gateway.name;
  bool get configured => gateway.enabled;

  Future<PaymentResult> checkout(PaymentRequest request) {
    if (!gateway.enabled) {
      throw StateError('Credenciais de "${gateway.name}" não configuradas');
    }
    return gateway.createCheckout(request);
  }

  PaymentStatus webhookStatus(Map<String, dynamic> payload) =>
      gateway.statusFromWebhook(payload);
}
