/// Utilidades de escape para emissão segura de XML (sitemap).
class XmlUtils {
  const XmlUtils._();

  /// Escapa os 5 caracteres reservados de XML.
  static String escape(String input) => input
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&apos;');

  /// Formata uma data no padrão W3C/ISO 8601 (aceito em `<lastmod>`).
  static String w3cDate(DateTime date) => date.toUtc().toIso8601String();
}
