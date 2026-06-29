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
    this.organizationName,
    this.sameAs = const [],
    this.searchUrlTemplate,
    this.themeColor,
    this.telephone,
    this.email,
    this.address,
    this.about,
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
