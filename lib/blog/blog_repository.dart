/// Carregador de posts do blog a partir do filesystem.
///
/// No servidor usa `dart:io` (implementação real); no navegador é substituído
/// por um stub que lança [UnsupportedError] — mantendo o pacote compatível
/// com a plataforma Web.
library;

export 'blog_repository_io.dart'
    if (dart.library.js_interop) 'blog_repository_stub.dart';
