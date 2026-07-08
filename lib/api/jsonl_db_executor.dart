/// Banco simples em arquivos JSONL (um por tabela).
///
/// No servidor usa `dart:io`; no navegador é um stub que lança
/// [UnsupportedError] — use um `DbExecutor` de API/HTTP no cliente.
library;

export 'jsonl_db_executor_io.dart'
    if (dart.library.js_interop) 'jsonl_db_executor_stub.dart';
