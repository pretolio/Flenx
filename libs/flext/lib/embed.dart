/// Helpers para embutir uma ilha Flutter num app jaspr (web).
///
/// IMPORTANTE: a chamada de `FlutterEmbedView` precisa ficar no **app**, pois o
/// `jaspr_builder` (modo `flutter: embedded`) escaneia o app para gerar o
/// bootstrap do Flutter. Aqui ficam só os utilitários reutilizáveis (viewport e
/// resize); o app monta a view usando-os. Importe só no lado cliente/web.
library;

export 'embed/viewport.dart';
