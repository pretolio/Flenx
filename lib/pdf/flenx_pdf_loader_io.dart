import 'dart:io';
import 'dart:typed_data';

/// Lê um arquivo do filesystem (servidor/tool). Devolve `null` se não existir.
Future<Uint8List?> loadLocalFile(String path) async {
  final f = File(path);
  if (!await f.exists()) return null;
  return f.readAsBytes();
}
