import 'pagination.dart';

/// Envelope de retorno **padrão** de toda chamada de API do Flenx.
/// Mesma forma em sucesso e erro, com `meta` de paginação quando aplicável.
///
/// JSON: `{ "success": bool, "data": ..., "error": str?, "meta": {...}? }`
class ApiResponse {
  const ApiResponse({
    required this.success,
    this.data,
    this.error,
    this.meta,
  });

  final bool success;
  final Object? data;
  final String? error;
  final PageMeta? meta;

  /// Sucesso simples (objeto/valor).
  factory ApiResponse.ok(Object? data) => ApiResponse(success: true, data: data);

  /// Sucesso de listagem paginada.
  factory ApiResponse.page(List<Object?> items, PageMeta meta) =>
      ApiResponse(success: true, data: items, meta: meta);

  /// Erro padronizado.
  factory ApiResponse.fail(String error) =>
      ApiResponse(success: false, error: error);

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data,
        'error': error,
        if (meta != null) 'meta': meta!.toJson(),
      };
}
