/// Flext — framework Flutter/Dart estilo Next.js.
///
/// SSR (jaspr), blog em markdown, SEO/GEO/AEO automáticos, shell de navegação
/// e blocos de site institucional. Importe `package:flext/flext.dart` e monte
/// seu site fornecendo o conteúdo.
library flext;

// Paleta central de cores (site + admin)
export 'flext_palette.dart';

// API (envelope de retorno padrão + paginação) e banco (models + migration)
export 'api/api.dart';
export 'db/db.dart';

// Autenticação (JWT/token) e notificações (push/SMS/WhatsApp, dispara p/ todos)
export 'auth/auth.dart';
export 'notify/notify.dart';

// Pagamento (escolha Asaas ou Mercado Pago e adicione as credenciais)
export 'pay/pay.dart';

// SEO/GEO/AEO + sitemap + robots + llms
export 'seo/seo.dart';

// Blog em markdown (engine + páginas + paginação + scaffold de post)
export 'blog/blog.dart';
export 'blog/blog_scaffold.dart';
export 'blog/blog_repository.dart';
export 'blog/blog_route_source.dart';
export 'blog/markdown_renderer.dart';
export 'blog/taxonomy_builder.dart';
export 'blog/models/blog_post.dart';
export 'blog/models/category.dart';
export 'blog/models/tag.dart';
export 'blog/models/taxonomy.dart';

// Shell de navegação (app Flutter): exposto em `package:flext/shell.dart`
// separadamente, pois depende de Flutter e só deve ser importado no lado web
// (via @Import.onWeb), nunca no servidor.

// Site institucional (header, layout, seções, formulário, whatsapp)
export 'site/site.dart';
export 'site/site_layout.dart';
export 'site/features_section.dart';
export 'site/lead_repository.dart';
export 'site/site_styles.dart';
export 'site/blog_styles.dart';
export 'site/components/flext_blog_layout.dart';
export 'site/components/flext_not_found.dart';
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
