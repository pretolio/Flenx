/// Tipo semântico de uma página. Mapeia para `og:type` (Open Graph) e para o
/// `@type` do schema.org (JSON-LD), permitindo gerar dados estruturados certos.
enum PageKind {
  website('website', 'WebPage'),
  article('article', 'Article'),
  blogPost('article', 'BlogPosting'),
  faq('website', 'FAQPage'),
  product('product', 'Product'),
  collection('website', 'CollectionPage'),
  profile('profile', 'ProfilePage');

  const PageKind(this.ogType, this.schemaType);

  /// Valor para a meta tag `og:type`.
  final String ogType;

  /// Valor para o `@type` do JSON-LD (schema.org).
  final String schemaType;
}
