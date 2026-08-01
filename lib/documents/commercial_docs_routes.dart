import '../app.dart';

/// Gera as rotas da Central de Documentos Comerciais a partir de uma lista de
/// [CommercialDoc]. Basta espalhar o resultado nas rotas do site:
///
/// ```dart
/// routes: [
///   ...minhasRotas,
///   ...commercialDocsRoutes(title: 'Alstop Express', logoSrc: '/assets/logo.webp', docs: [...]),
/// ]
/// ```
///
/// Cria `GET {basePath}` (a central) e `GET {basePath}/{slug}` para cada
/// documento. Todas são `noindex` (material comercial, fora do índice de busca).
List<FlenxRoute> commercialDocsRoutes({
  required List<CommercialDoc> docs,
  required String title,
  String basePath = '/comercial',
  String eyebrow = 'Central Comercial',
  String subtitle = '',
  String? logoSrc,
  String accent = '#F36B16',
  String accentDark = '#D94E00',
  String accentLight = '#FF8A31',
  String ink = '#071C43',
  String ink2 = '#0F2F69',
  String barColor = '#071C43',
}) {
  final hub = FlenxRoute(
    RouteMeta(
      path: basePath,
      title: '$title — Documentos comerciais',
      description: subtitle.isEmpty ? 'Documentos comerciais' : subtitle,
      noindex: true,
    ),
    (ctx) => FlenxDocHub(
      docs: docs,
      basePath: basePath,
      title: title,
      eyebrow: eyebrow,
      subtitle: subtitle,
      logoSrc: logoSrc,
      accent: accent,
      accentDark: accentDark,
      accentLight: accentLight,
      ink: ink,
      ink2: ink2,
    ),
  );
  return [
    hub,
    for (final d in docs)
      FlenxRoute(
        RouteMeta(path: '$basePath/${d.slug}', title: d.title, description: d.description, noindex: true),
        (ctx) => FlenxDocPage(doc: d, backHref: basePath, accent: accent, barColor: barColor),
      ),
  ];
}
