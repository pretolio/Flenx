import 'payment_request.dart';
import 'payment_result.dart';

/// Contrato comum de gateway de pagamento. Cada provedor (Asaas, Mercado Pago)
/// implementa esta interface; o usuário só escolhe qual e passa as credenciais.
abstract interface class PaymentGateway {
  /// Nome do provedor (ex.: 'asaas', 'mercadopago').
  String get name;

  /// `true` quando as credenciais foram configuradas.
  bool get enabled;

  /// Cria a cobrança/checkout e devolve a URL de pagamento.
  Future<PaymentResult> createCheckout(PaymentRequest request);

  /// Normaliza o status a partir do corpo do webhook do provedor.
  PaymentStatus statusFromWebhook(Map<String, dynamic> payload);
}
