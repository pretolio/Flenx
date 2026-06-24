/// Estratégia de renderização de uma rota/widget, espelhando Next.js/Astro.
enum RenderMode {
  /// Gerado em build-time (HTML estático). Equivale ao SSG do Next.
  static_,

  /// Renderizado por requisição no servidor. Equivale ao SSR do Next.
  server,

  /// Estático + revalidação em background (stale-while-revalidate). ISR.
  incremental,

  /// Somente cliente (SPA). Sem HTML no servidor.
  client,
}
