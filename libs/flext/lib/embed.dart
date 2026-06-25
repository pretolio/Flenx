/// Embute uma ilha Flutter num app jaspr (web).
///
/// `FlutterIsland` cuida da plumbing (viewport, resize, FlutterEmbedView). A
/// chamada de `@Import.onWeb` (apontando para o seu app Flutter deferido) fica
/// no app, pois o jaspr_builder escaneia o pacote raiz. Importe só no cliente.
library;

export 'embed/flutter_island.dart';
export 'embed/viewport.dart';
