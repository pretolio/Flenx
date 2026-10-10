import 'crawler_rule.dart';
import 'seo_address.dart';

/// Configuração global de SEO/GEO/AEO do site. Fonte única para baseUrl,
/// identidade da organização e política de crawlers.
class SeoConfig {
  const SeoConfig({
    required this.baseUrl,
    required this.siteName,
    required this.description,
    this.defaultLocale = 'pt_BR',
    this.twitterHandle,
    this.logoUrl,
    this.defaultImage,
    this.organizationName,
    this.sameAs = const [],
    this.searchUrlTemplate,
    this.themeColor,
    this.telephone,
    this.email,
    this.address,
    this.about,
    this.googleSiteVerification,
    this.bingSiteVerification,
    this.ratingValue,
    this.reviewCount,
    this.globalDisallow = const [],
    this.trailingSlash = false,
    List<CrawlerRule>? crawlerRules,
  }) : crawlerRules = crawlerRules ?? defaultCrawlerRules;

  /// URL base SEM barra final (ex.: `https://exemplo.com`).
  final String baseUrl;
  final String siteName;
  final String description;
  final String defaultLocale;
  final String? twitterHandle;
  final String? logoUrl;

  /// Imagem padrão de compartilhamento (og:image/twitter:image) usada quando a
  /// rota não define `RouteMeta.image`. Ideal ~1200x630. Cai para [logoUrl].
  final String? defaultImage;
  final String? organizationName;

  /// Perfis sociais/oficiais (JSON-LD `sameAs`).
  final List<String> sameAs;

  /// Template de busca p/ SearchAction (ex.: `/busca?q={search_term_string}`).
  final String? searchUrlTemplate;
  final String? themeColor;

  /// Telefone principal (ex.: `'+55 11 5108-0113'`).
  final String? telephone;

  /// E-mail de contato público.
  final String? email;

  /// Endereço físico — quando preenchido, o schema muda de Organization para
  /// LocalBusiness, habilitando rich results de endereço/geo no Google.
  final SeoAddress? address;

  /// Markdown com informações detalhadas da empresa: história, serviços,
  /// área de atuação, contatos, horários, diferenciais, etc.
  /// Injetado no topo de `/llms.txt` e `/llms-full.txt` para maximizar
  /// a extração por AI assistants (GEO/AEO).
  final String? about;

  /// Verificação do Search Console — emite `<meta google-site-verification>` e
  /// `<meta msvalidate.01>` (Bing). Só o token, sem a tag.
  final String? googleSiteVerification;
  final String? bingSiteVerification;

  /// Avaliação agregada da empresa → JSON-LD `AggregateRating` (estrelas nos
  /// resultados / credibilidade B2B). Informe os dois juntos.
  final double? ratingValue;
  final int? reviewCount;

  /// Páginas terminam em `/` nas URLs públicas (canonical, og:url, sitemap,
  /// JSON-LD, llms.txt). Ligue em hospedagem estática que serve cada página
  /// como `pasta/index.html` (Apache/LiteSpeed): o servidor redireciona
  /// `/pagina` → `/pagina/`, e sem isto o canonical e o sitemap apontavam para
  /// uma URL que redireciona (301). Arquivos (`/x.png`, `/sitemap.xml`) e a
  /// raiz não mudam.
  final bool trailingSlash;

  /// Caminhos bloqueados para todos os agentes.
  final List<String> globalDisallow;

  /// Regras por crawler no robots.txt.
  final List<CrawlerRule> crawlerRules;

  /// Monta uma URL absoluta a partir de um caminho.
  String url(String path) {
    if (path.startsWith('http')) return path;
    final p = path.startsWith('/') ? path : '/$path';
    return '$baseUrl${trailingSlash ? _comBarraFinal(p) : p}';
  }

  /// `/a/b` → `/a/b/`; mantém `?query`/`#âncora`, a raiz e arquivos (último
  /// trecho com ponto: `.png`, `.xml`, `.html`).
  static String _comBarraFinal(String p) {
    final corte = p.indexOf(RegExp(r'[?#]'));
    final caminho = corte < 0 ? p : p.substring(0, corte);
    final resto = corte < 0 ? '' : p.substring(corte);
    if (caminho == '/' || caminho.endsWith('/')) return p;
    if (caminho.split('/').last.contains('.')) return p;
    return '$caminho/$resto';
  }

  /// Política padrão: permite buscadores e crawlers de IA que geram
  /// citações/tráfego; bloqueia os abusivos de baixo valor.
  static const List<CrawlerRule> defaultCrawlerRules = [
    CrawlerRule(userAgent: 'Googlebot'),
    CrawlerRule(userAgent: 'Bingbot'),
    CrawlerRule(userAgent: 'Applebot'),
    // IA — assistentes de busca / fetch a pedido do usuário (citações)
    CrawlerRule(userAgent: 'OAI-SearchBot'),
    CrawlerRule(userAgent: 'ChatGPT-User'),
    CrawlerRule(userAgent: 'Claude-User'),
    CrawlerRule(userAgent: 'Claude-SearchBot'),
    CrawlerRule(userAgent: 'PerplexityBot'),
    CrawlerRule(userAgent: 'Perplexity-User'),
    CrawlerRule(userAgent: 'MistralAI-User'),
    CrawlerRule(userAgent: 'DuckAssistBot'),
    // IA — treinamento (permitido por padrão; decisão de negócio)
    CrawlerRule(userAgent: 'GPTBot'),
    CrawlerRule(userAgent: 'ClaudeBot'),
    CrawlerRule(userAgent: 'Google-Extended'),
    CrawlerRule(userAgent: 'Applebot-Extended'),
    CrawlerRule(userAgent: 'Amazonbot'),
    CrawlerRule(userAgent: 'Meta-ExternalAgent'),
    // Bloqueados — alto custo, baixo valor
    CrawlerRule.block('Bytespider'),
    CrawlerRule.block('CCBot'),
  ];
}
