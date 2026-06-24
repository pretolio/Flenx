import 'dart:convert';

/// Utilidades para emissão de JSON-LD.
class JsonUtils {
  const JsonUtils._();

  /// Serializa um mapa schema.org em `<script type="application/ld+json">`.
  /// Escapa `<` como a sequência unicode `<` para não fechar o bloco
  /// `<script>` prematuramente (recomendação do Google para JSON-LD inline).
  static String ldScript(Map<String, dynamic> data) {
    return '<script type="application/ld+json">\n${encode(data)}\n</script>';
  }

  /// Apenas o JSON (sem a tag script), com `<` escapado — para usar como
  /// `content` de um elemento `script` do jaspr.
  static String encode(Map<String, dynamic> data) {
    final json = const JsonEncoder.withIndent('  ').convert(data);
    return json.replaceAll('<', '\\u003c');
  }
}
