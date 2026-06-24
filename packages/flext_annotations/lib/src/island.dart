/// Estratégias de hidratação de uma ilha interativa (islands architecture,
/// estilo Astro `client:*`).
enum HydrationStrategy {
  /// Hidrata imediatamente no load.
  load,

  /// Hidrata em `requestIdleCallback` (quando a thread principal está ociosa).
  idle,

  /// Hidrata ao entrar no viewport (IntersectionObserver). Melhor para perf.
  visible,

  /// Somente cliente, sem render no servidor.
  only,
}

/// Marca um widget Flutter como **ilha interativa**: o SSR emite um placeholder
/// e o engine Flutter assume aquele container no cliente (via jaspr_flutter_embed).
///
/// Use para UI que não transpila para HTML (CustomPaint, canvas, animações
/// complexas) ou que precisa do runtime Flutter completo.
class Island {
  /// Quando hidratar a ilha. Padrão: [HydrationStrategy.visible].
  final HydrationStrategy strategy;

  const Island({this.strategy = HydrationStrategy.visible});
}

/// Atalho conveniente: `@island`.
const island = Island();
