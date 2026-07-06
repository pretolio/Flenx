import 'package:http/http.dart' as http;

import 'gateways/asaas_gateway.dart';
import 'gateways/mercado_pago_gateway.dart';
import 'payment_gateway.dart';

/// Cria um gateway a partir do ambiente (`.env`) + client HTTP opcional.
typedef GatewayFactory =
    PaymentGateway Function(Map<String, String> env, http.Client? client);

/// Registro de provedores de pagamento. Já vem com Asaas e Mercado Pago;
/// para um provedor novo basta `PaymentRegistry.register('stripe', ...)`
/// — nenhum arquivo da lib precisa ser alterado (Open/Closed).
class PaymentRegistry {
  PaymentRegistry._();

  static final Map<String, GatewayFactory> _factories = {
    'asaas': (env, client) => AsaasGateway.fromEnv(env, client: client),
    'mercadopago': (env, client) =>
        MercadoPagoGateway.fromEnv(env, client: client),
    'mercado_pago': (env, client) =>
        MercadoPagoGateway.fromEnv(env, client: client),
    'mp': (env, client) => MercadoPagoGateway.fromEnv(env, client: client),
  };

  /// Registra (ou substitui) um provedor pelo nome usado em `PAYMENT_PROVIDER`.
  static void register(String name, GatewayFactory factory) =>
      _factories[name.toLowerCase()] = factory;

  /// Nomes disponíveis (úteis para validação/UX).
  static List<String> get available => _factories.keys.toList();

  /// Resolve o gateway pelo nome do provedor.
  static PaymentGateway resolve(
    String provider,
    Map<String, String> env, {
    http.Client? client,
  }) {
    final factory = _factories[provider.toLowerCase()];
    if (factory == null) {
      throw ArgumentError(
        'PAYMENT_PROVIDER inválido: "$provider" (use ${available.join(", ")})',
      );
    }
    return factory(env, client);
  }
}
