/// Persistência de leads do formulário do site.
///
/// No servidor usa `dart:io` (arquivo JSONL); no navegador é um stub que
/// lança [UnsupportedError] — envie os leads por API no cliente.
library;

export 'lead_repository_io.dart'
    if (dart.library.js_interop) 'lead_repository_stub.dart';
