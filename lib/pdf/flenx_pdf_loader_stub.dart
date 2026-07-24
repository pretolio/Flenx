import 'dart:typed_data';

/// Navegador (dart2js): não há filesystem. Devolve `null` — as fontes/imagens
/// vêm injetadas pelo chamador (fontes embutidas / `preloadedImages`).
Future<Uint8List?> loadLocalFile(String path) async => null;
