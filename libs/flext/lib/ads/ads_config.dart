/// Posição sugerida de um anúncio numa página.
enum AdPosition { top, inContent, sidebar, bottom }

/// Uma regra de anúncio: qual unidade (slot) e ONDE ela aparece (por caminho
/// e/ou por categoria). Listas vazias = sem restrição naquele eixo.
///
/// Ex.: `AdPlacement(slot: '123', categories: ['Tecnologia'])` → só nas páginas
/// da categoria Tecnologia. `AdPlacement(slot: '999', paths: ['/'])` → só na home.
class AdPlacement {
  const AdPlacement({
    required this.slot,
    this.position = AdPosition.inContent,
    this.paths = const [],
    this.categories = const [],
    this.format = 'auto',
    this.html,
  });

  /// Anúncio custom (HTML/embed) em vez de uma unidade do AdSense.
  const AdPlacement.custom(
    this.html, {
    this.position = AdPosition.inContent,
    this.paths = const [],
    this.categories = const [],
  })  : slot = '',
        format = 'auto';

  final String slot;
  final AdPosition position;

  /// Caminhos onde aparece (ex.: `['/', '/blog']`). Vazio = qualquer caminho.
  final List<String> paths;

  /// Categorias onde aparece (ex.: `['Tecnologia']`). Vazio = qualquer categoria.
  final List<String> categories;

  /// Formato do AdSense (`auto`, `fluid`, `rectangle`...).
  final String format;

  /// HTML do anúncio custom (nulo = usa AdSense com [slot]).
  final String? html;

  bool matches({String? path, String? category}) {
    final pathOk = paths.isEmpty || (path != null && paths.contains(path));
    final catOk =
        categories.isEmpty || (category != null && categories.contains(category));
    return pathOk && catOk;
  }
}

/// Configuração central de anúncios. [clientId] é o `ca-pub-...` do Google
/// AdSense. Defina uma vez e passe ao `FlextApp.run(ads: ...)` — o loader vai no
/// `<head>`. Onde mostrar é controlado pelas [placements] (por página/categoria).
class AdsConfig {
  const AdsConfig({
    required this.clientId,
    this.placements = const [],
    this.enabled = true,
  });

  final String clientId;
  final List<AdPlacement> placements;
  final bool enabled;

  /// URL do script de carregamento do AdSense (vai no `<head>`).
  String get loaderUrl =>
      'https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=$clientId';

  /// Placements que se aplicam ao contexto dado (página/categoria/posição).
  List<AdPlacement> placementsFor({
    String? path,
    String? category,
    AdPosition? position,
  }) {
    if (!enabled) return const [];
    return placements
        .where((p) =>
            p.matches(path: path, category: category) &&
            (position == null || p.position == position))
        .toList();
  }
}
