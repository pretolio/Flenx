/// Flenx — framework Flutter/Dart estilo Next.js.
///
/// SSR (jaspr), blog em markdown, SEO/GEO/AEO automáticos, shell de navegação
/// e blocos de site institucional. Importe `package:flenx/flenx.dart` e monte
/// seu site fornecendo o conteúdo.
library flenx;

// Jaspr re-exportado — projetos que usam Flenx não precisam importar jaspr diretamente
export 'package:jaspr/jaspr.dart';

// Paleta central de cores (site + admin)
export 'flenx_palette.dart';

// Kit de UI em Dart estilo Flutter (sem precisar saber HTML/CSS)
export 'ui/ui.dart';

// API (envelope de retorno padrão + paginação) e banco (models + migration)
export 'api/api.dart';
export 'db/db.dart';

// Autenticação (JWT/token) e notificações (push/SMS/WhatsApp, dispara p/ todos)
export 'auth/auth.dart';
export 'notify/notify.dart';

// Pagamento (escolha Asaas ou Mercado Pago e adicione as credenciais)
export 'pay/pay.dart';

// Anúncios (AdSense/custom) configuráveis por página e categoria
export 'ads/ads_config.dart';
export 'ads/ad_slot.dart';

// SEO/GEO/AEO + sitemap + robots + llms
export 'seo/seo.dart';

// Blog (engine + páginas + paginação + scaffold de post)
// Fontes de posts: Markdown (.md) E/OU banco de dados — combináveis.
export 'blog/blog.dart';
export 'blog/blog_scaffold.dart';
export 'blog/blog_repository.dart';
export 'blog/blog_route_source.dart';
export 'blog/blog_posts_model.dart';
export 'blog/markdown_renderer.dart';
export 'blog/taxonomy_builder.dart';
export 'blog/models/blog_post.dart';
export 'blog/models/category.dart';
export 'blog/models/tag.dart';
export 'blog/models/taxonomy.dart';
export 'blog/mappers/blog_post_mapper.dart';
export 'blog/sources/blog_source.dart';
export 'blog/sources/markdown_blog_source.dart';
export 'blog/sources/database_blog_source.dart';
export 'blog/sources/composite_blog_source.dart';
// Post rico estilo G1 (blocos: título, imagem c/ legenda, citação, embed...)
export 'blog/document/post_document.dart';
export 'blog/document/post_block.dart';
export 'blog/document/post_block_factory.dart';
export 'blog/document/blocks/paragraph_block.dart';
export 'blog/document/blocks/heading_block.dart';
export 'blog/document/blocks/image_block.dart';
export 'blog/document/blocks/quote_block.dart';
export 'blog/document/blocks/list_block.dart';
export 'blog/document/blocks/embed_block.dart';
export 'blog/document/blocks/divider_block.dart';

// Shell de navegação (app Flutter): exposto em `package:flenx/shell.dart`
// separadamente, pois depende de Flutter e só deve ser importado no lado web
// (via @Import.onWeb), nunca no servidor.

// Site institucional (header, layout, seções, formulário, whatsapp)
export 'site/site.dart';
export 'site/site_layout.dart';
export 'site/features_section.dart';
export 'site/lead_repository.dart';
export 'site/site_styles.dart';
export 'site/blog_styles.dart';
export 'site/components/flenx_blog_layout.dart';
export 'site/components/flenx_not_found.dart';
export 'site/components/flenx_floating_button.dart';
export 'site/components/iframe_embed.dart';
export 'site/components/lead_form.dart';
export 'site/components/whatsapp_button.dart';
export 'site/models/feature.dart';
export 'site/models/lead.dart';
export 'site/models/login_option.dart';
export 'site/models/menu_link.dart';
export 'site/models/nav_align.dart';
export 'site/models/site_brand.dart';
export 'site/models/site_config.dart';
