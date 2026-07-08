import 'models/lead.dart';

/// Persiste leads capturados pelo formulário (contrato multiplataforma).
abstract interface class ILeadStore {
  Future<void> add(Lead lead);
  Future<List<Lead>> all();
}

/// Stub Web de [FileLeadStore] — gravação em arquivo só no servidor.
class FileLeadStore implements ILeadStore {
  const FileLeadStore({this.path = 'content/leads.jsonl'});

  final String path;

  Never _unsupported() =>
      throw UnsupportedError('FileLeadStore só está disponível no servidor (dart:io).');

  @override
  Future<void> add(Lead lead) async => _unsupported();

  @override
  Future<List<Lead>> all() async => _unsupported();
}
