/// Entrada do **cliente** (hidratação no navegador). É boilerplate padrão do
/// jaspr movido para a lib: o `main.client.dart` do app só chama [runFlextClient].
/// Importe `package:flext/app_client.dart` (lado cliente/web).
library;

import 'package:jaspr/client.dart';

/// Inicializa o ambiente do cliente e renderiza os componentes `@client`.
void runFlextClient(ClientOptions options) {
  Jaspr.initializeApp(options: options);
  runApp(const ClientApp());
}
