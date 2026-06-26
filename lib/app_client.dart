/// Entrada do **cliente** (hidratação no navegador). É boilerplate padrão do
/// jaspr movido para a lib: o `main.client.dart` do app só chama [runFlenxClient].
/// Importe `package:flenx/app_client.dart` (lado cliente/web).
library;

import 'package:jaspr/client.dart';

/// Inicializa o ambiente do cliente e renderiza os componentes `@client`.
void runFlenxClient(ClientOptions options) {
  Jaspr.initializeApp(options: options);
  runApp(const ClientApp());
}
