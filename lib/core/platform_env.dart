/// Variáveis de ambiente multiplataforma.
///
/// No servidor (VM) lê `Platform.environment`; no navegador (dart2js/wasm)
/// retorna um mapa vazio — permitindo que classes de configuração compilem
/// para Web sem depender de `dart:io`.
library;

export 'platform_env_io.dart'
    if (dart.library.js_interop) 'platform_env_stub.dart';
