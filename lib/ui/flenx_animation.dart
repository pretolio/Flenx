/// Tipos de animação disponíveis no [FlenxAnimated].
enum FlenxAnimation {
  // ── Scroll-reveal (aparecem ao entrar na viewport) ──────────────────────
  /// Fade in: opacidade 0 → 1.
  fadeIn,

  /// Slide de baixo para cima.
  slideUp,

  /// Slide de cima para baixo.
  slideDown,

  /// Slide da direita para a esquerda.
  slideLeft,

  /// Slide da esquerda para a direita.
  slideRight,

  /// Zoom in: escala 0.9 → 1.
  zoomIn,

  // ── Contínuas (loop infinito) ────────────────────────────────────────────
  /// Pulso: aumenta e diminui levemente.
  pulse,

  /// Pulo: sobe e desce.
  bounce,

  /// Flutuação suave.
  float,

  /// Rotação contínua.
  spin,
}
