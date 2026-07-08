/// Gerador de API PHP (arquivos para hospedagem compartilhada).
///
/// No servidor usa `dart:io` para escrever os arquivos; no navegador é um
/// stub que lança [UnsupportedError] (ferramenta de build/CLI).
library;

export 'php_api_generator_io.dart'
    if (dart.library.js_interop) 'php_api_generator_stub.dart';
