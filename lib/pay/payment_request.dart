/// Dados para criar uma cobrança/checkout, independente do provedor.
class PaymentRequest {
  const PaymentRequest({
    required this.amount,
    required this.description,
    required this.customerEmail,
    this.customerName,
    this.externalReference,
    this.successUrl,
    this.failureUrl,
  });

  /// Valor em reais (ex.: 49.90).
  final double amount;
  final String description;
  final String customerEmail;
  final String? customerName;

  /// Referência do seu pedido (volta no webhook).
  final String? externalReference;
  final String? successUrl;
  final String? failureUrl;
}
