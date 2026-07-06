import '../models/page_kind.dart';
import '../models/route_meta.dart';
import '../models/seo_config.dart';
import '../utils/xml_utils.dart';

/// Constrói os objetos schema.org (JSON-LD) de uma página: Organization e
/// WebSite (site-wide) + o tipo da página (Article/FAQPage/...) + BreadcrumbList.
///
/// Retorna mapas prontos para serialização — base dos rich results e da
/// extração por motores de IA (AEO/GEO).
class JsonLdGenerator {
  const JsonLdGenerator(this.config);

  final SeoConfig config;

  List<Map<String, dynamic>> build(RouteMeta route) {
    return [
      _organization(),
      _website(),
      _page(route),
      if (route.faqs.isNotEmpty) _faq(route),
      if (route.breadcrumbs.isNotEmpty) _breadcrumbs(route),
    ];
  }

  Map<String, dynamic> _organization() {
    final addr = config.address;
    return {
      '@context': 'https://schema.org',
      '@type': addr != null ? 'LocalBusiness' : 'Organization',
      'name': config.organizationName ?? config.siteName,
      'url': config.baseUrl,
      if (config.logoUrl != null) 'logo': config.url(config.logoUrl!),
      if (config.telephone != null) 'telephone': config.telephone,
      if (config.email != null) 'email': config.email,
      if (config.sameAs.isNotEmpty) 'sameAs': config.sameAs,
      if (addr != null) 'address': addr.toJsonLd(),
      if (addr != null && addr.hasGeo)
        'geo': {
          '@type': 'GeoCoordinates',
          'latitude': addr.latitude,
          'longitude': addr.longitude,
        },
    };
  }

  Map<String, dynamic> _website() => {
    '@context': 'https://schema.org',
    '@type': 'WebSite',
    'name': config.siteName,
    'url': config.baseUrl,
    if (config.searchUrlTemplate != null)
      'potentialAction': {
        '@type': 'SearchAction',
        'target': {
          '@type': 'EntryPoint',
          'urlTemplate': config.url(config.searchUrlTemplate!),
        },
        'query-input': 'required name=search_term_string',
      },
  };

  Map<String, dynamic> _page(RouteMeta r) {
    final isArticle = r.kind == PageKind.article || r.kind == PageKind.blogPost;
    return {
      '@context': 'https://schema.org',
      '@type': r.kind.schemaType,
      isArticle ? 'headline' : 'name': r.title,
      'description': r.description,
      'url': config.url(r.path),
      if (r.image != null) 'image': config.url(r.image!),
      if (r.datePublished != null)
        'datePublished': XmlUtils.w3cDate(r.datePublished!),
      if (r.lastmod != null) 'dateModified': XmlUtils.w3cDate(r.lastmod!),
      if (isArticle && r.author != null)
        'author': {'@type': 'Person', 'name': r.author},
      if (isArticle)
        'publisher': {
          '@type': 'Organization',
          'name': config.organizationName ?? config.siteName,
          if (config.logoUrl != null)
            'logo': {
              '@type': 'ImageObject',
              'url': config.url(config.logoUrl!),
            },
        },
    };
  }

  Map<String, dynamic> _faq(RouteMeta r) => {
    '@context': 'https://schema.org',
    '@type': 'FAQPage',
    'mainEntity': [
      for (final f in r.faqs)
        {
          '@type': 'Question',
          'name': f.question,
          'acceptedAnswer': {'@type': 'Answer', 'text': f.answer},
        },
    ],
  };

  Map<String, dynamic> _breadcrumbs(RouteMeta r) => {
    '@context': 'https://schema.org',
    '@type': 'BreadcrumbList',
    'itemListElement': [
      for (var i = 0; i < r.breadcrumbs.length; i++)
        {
          '@type': 'ListItem',
          'position': i + 1,
          'name': r.breadcrumbs[i].name,
          if (r.breadcrumbs[i].path != null)
            'item': config.url(r.breadcrumbs[i].path!),
        },
    ],
  };
}
