/// Stack de servidor (shelf) re-exportada pela flenx, para o app não precisar
/// declarar shelf/shelf_router diretamente. Importe `package:flenx/server.dart`
/// no `main.server.dart`.
library;

export 'package:shelf/shelf.dart';
export 'package:shelf/shelf_io.dart';
export 'package:shelf_router/shelf_router.dart';
