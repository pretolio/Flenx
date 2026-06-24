/// Situação de uma cobrança, normalizada entre provedores.
enum PaymentStatus { pending, paid, failed, canceled, refunded, unknown }

/// Resultado de uma criação de checkout.
class PaymentResult {
  const PaymentResult({
    required this.id,
    required this.checkoutUrl,
    this.status = PaymentStatus.pending,
    this.raw = const {},
  });

  /// Id da cobrança no provedor.
  final String id;

  /// URL para redirecionar o cliente e pagar.
  final String checkoutUrl;
  final PaymentStatus status;
  final Map<String, dynamic> raw;
}
