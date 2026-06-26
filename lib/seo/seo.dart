/// Camada de otimização automática do Flenx: SEO + GEO + AEO + LLMs.
///
/// Fonte única (RouteRegistry) → meta tags, JSON-LD, sitemap, robots, llms.txt.
library;

export 'models/breadcrumb.dart';
export 'models/change_freq.dart';
export 'models/crawler_rule.dart';
export 'models/faq_item.dart';
export 'models/page_kind.dart';
export 'models/route_meta.dart';
export 'models/seo_config.dart';
export 'sources/dynamic_route_source.dart';
export 'sources/i_route_source.dart';
export 'sources/route_registry.dart';
export 'sources/static_route_source.dart';
export 'generators/json_ld_generator.dart';
export 'generators/llms_full_generator.dart';
export 'generators/llms_txt_generator.dart';
export 'generators/robots_txt_generator.dart';
export 'generators/sitemap_index_generator.dart';
export 'generators/sitemap_xml_generator.dart';
export 'head/meta_tags_builder.dart';
export 'seo_endpoints.dart';
