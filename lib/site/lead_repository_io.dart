import 'dart:convert';
import 'dart:io';

import 'models/lead.dart';

/// Persiste leads capturados pelo formulário. Implementação padrão grava em
/// um arquivo JSONL; o usuário pode trocar por banco/API/CRM facilmente.
abstract interface class ILeadStore {
  Future<void> add(Lead lead);
  Future<List<Lead>> all();
}

/// Armazenamento simples em arquivo (`content/leads.jsonl`), uma linha por lead.
class FileLeadStore implements ILeadStore {
  const FileLeadStore({this.path = 'content/leads.jsonl'});

  final String path;

  @override
  Future<void> add(Lead lead) async {
    final file = File(path);
    await file.parent.create(recursive: true);
    await file.writeAsString(
      '${lead.toJsonLine()}\n',
      mode: FileMode.append,
      flush: true,
    );
  }

  @override
  Future<List<Lead>> all() async {
    final file = File(path);
    if (!file.existsSync()) return const [];
    final lines = await file.readAsLines();
    return lines
        .where((l) => l.trim().isNotEmpty)
        .map((l) => Lead.fromJson(jsonDecode(l) as Map<String, dynamic>))
        .toList();
  }
}
