import 'crawler_rule.dart';

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
    this.organizationName,
    this.sameAs = const [],
    this.searchUrlTemplate,
    this.themeColor,
    this.globalDisallow = const [],
    List<CrawlerRule>? crawlerRules,
  }) : crawlerRules = crawlerRules ?? defaultCrawlerRules;

  /// URL base SEM barra final (ex.: `https://exemplo.com`).
  final String baseUrl;
  final String siteName;
  final String description;
  final String defaultLocale;
  final String? twitterHandle;
  final String? logoUrl;
  final String? organizationName;

  /// Perfis sociais/oficiais (JSON-LD `sameAs`).
  final List<String> sameAs;

  /// Template de busca p/ SearchAction (ex.: `/busca?q={search_term_string}`).
  final String? searchUrlTemplate;
  final String? themeColor;

  /// Caminhos bloqueados para todos os agentes.
  final List<String> globalDisallow;

  /// Regras por crawler no robots.txt.
  final List<CrawlerRule> crawlerRules;

  /// Monta uma URL absoluta a partir de um caminho.
  String url(String path) {
    if (path.startsWith('http')) return path;
    final p = path.startsWith('/') ? path : '/$path';
    return '$baseUrl$p';
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
