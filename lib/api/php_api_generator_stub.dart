import '../db/db_model.dart';
import 'api_endpoint.dart';

/// Stub Web de [PhpApiGenerator] — geração de arquivos só no servidor.
class PhpApiGenerator {
  const PhpApiGenerator();

  Never _unsupported() =>
      throw UnsupportedError('PhpApiGenerator só está disponível no servidor (dart:io).');

  Never generate(List<ApiEndpoint> endpoints) => _unsupported();

  Never writeTo(
    String dir,
    List<ApiEndpoint> endpoints, {
    List<DbModel> models = const [],
  }) => _unsupported();
}
