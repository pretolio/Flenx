/// Regra de um grupo `User-agent` no robots.txt.
///
/// Modela a política para um bot específico (buscador tradicional ou crawler de
/// IA), permitindo allowlist/blocklist por agente.
class CrawlerRule {
  const CrawlerRule({
    required this.userAgent,
    this.allow = const ['/'],
    this.disallow = const [],
    this.crawlDelay,
  });

  /// Token do agente (ex.: `Googlebot`, `GPTBot`, `PerplexityBot`, `*`).
  final String userAgent;

  /// Caminhos permitidos.
  final List<String> allow;

  /// Caminhos bloqueados.
  final List<String> disallow;

  /// Crawl-delay em segundos (Bing/Yandex respeitam; Google ignora).
  final int? crawlDelay;

  /// Bloqueia todo o site para este agente (construtor const).
  const CrawlerRule.block(this.userAgent)
    : allow = const [],
      disallow = const ['/'],
      crawlDelay = null;
}
