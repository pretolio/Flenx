import 'render_mode.dart';

/// Declara uma rota navegável (file-based routing estilo Next/Astro).
///
/// Exemplo: `@FlextPage('/users/:id')` → o code-gen registra a rota no router
/// gerado, extraindo parâmetros dinâmicos (`:id`, `*` catch-all).
class FlextPage {
  /// Caminho da rota. Suporta `:param` (segmento) e `*` (catch-all).
  final String path;

  /// Estratégia de renderização da página. Padrão: [RenderMode.server].
  final RenderMode mode;

  const FlextPage(this.path, {this.mode = RenderMode.server});
}
