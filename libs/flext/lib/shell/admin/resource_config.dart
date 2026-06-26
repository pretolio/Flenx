import 'resource_field.dart';

/// Configuração declarativa de um recurso administrável (CRUD). Você só lista
/// os endpoints e os campos; o [FlextResourcePage] cuida da tela inteira
/// (listar, criar, editar, excluir). Reaproveitável para qualquer entidade.
class ResourceConfig {
  const ResourceConfig({
    required this.title,
    required this.fields,
    required this.listPath,
    this.createPath,
    this.updatePath,
    this.deletePath,
    this.titleKey = 'title',
    this.subtitleKey,
    this.singular = 'registro',
    this.idKey = 'id',
  });

  final String title;
  final List<ResourceField> fields;

  /// Endpoints da API (envelope padrão do Flext).
  final String listPath;
  final String? createPath;
  final String? updatePath;
  final String? deletePath;

  /// Campo usado como título de cada linha; opcionalmente um subtítulo.
  final String titleKey;
  final String? subtitleKey;

  /// Nome no singular (ex.: "produto") para textos de botões/diálogos.
  final String singular;
  final String idKey;

  bool get canCreate => createPath != null;
  bool get canEdit => updatePath != null;
  bool get canDelete => deletePath != null;
}
