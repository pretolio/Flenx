/// Helpers de viewport (tamanho da janela + evento de resize), com
/// implementação por plataforma via import condicional. Servem para
/// dimensionar uma ilha Flutter para 100% da tela e reagir ao resize.
///
/// No servidor retorna um placeholder; no navegador lê `window.innerWidth/Height`.
library;

export 'viewport_size_io.dart'
    if (dart.library.js_interop) 'viewport_size_web.dart';
