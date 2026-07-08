/// Scaffold de posts do blog (cria arquivos `.md`).
///
/// No servidor usa `dart:io`; no navegador é um stub que lança
/// [UnsupportedError] (o scaffold é uma ferramenta de CLI/servidor).
library;

export 'blog_scaffold_io.dart'
    if (dart.library.js_interop) 'blog_scaffold_stub.dart';
