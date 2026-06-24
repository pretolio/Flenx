/// Tamanho de viewport no servidor (sem janela): valor padrão de placeholder.
({double width, double height}) viewportSize() => (width: 1280, height: 800);

/// No servidor não há resize — retorna um cancelador no-op.
void Function() onViewportResize(void Function() callback) => () {};
