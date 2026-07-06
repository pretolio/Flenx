import 'package:flutter/material.dart';

import 'admin_rest_client.dart';
import 'resource_config.dart';
import 'resource_form_dialog.dart';

/// Tela CRUD genérica do admin: lista os registros de um recurso e permite
/// criar/editar/excluir — tudo a partir de um [ResourceConfig]. Usada para
/// produtos, pedidos, usuários, etc., sem reescrever a UI.
class FlenxResourcePage extends StatefulWidget {
  const FlenxResourcePage({
    required this.config,
    this.client = const AdminRestClient(),
    super.key,
  });

  final ResourceConfig config;
  final AdminRestClient client;

  @override
  State<FlenxResourcePage> createState() => _FlenxResourcePageState();
}

class _FlenxResourcePageState extends State<FlenxResourcePage> {
  List<Map<String, Object?>>? _rows;
  String? _error;

  ResourceConfig get _c => widget.config;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _rows = null;
      _error = null;
    });
    try {
      final rows = await widget.client.list(_c.listPath);
      if (mounted) setState(() => _rows = rows);
    } catch (e) {
      if (mounted) setState(() => _error = '$e');
    }
  }

  Future<void> _openForm({Map<String, Object?>? row}) async {
    final result = await showDialog<Map<String, Object?>>(
      context: context,
      builder: (_) => ResourceFormDialog(config: _c, initial: row),
    );
    if (result == null) return;
    try {
      final isEdit = row != null && _c.canEdit;
      await widget.client.post(
        isEdit ? _c.updatePath! : _c.createPath!,
        result,
      );
      _snack('${_c.singular} ${isEdit ? 'atualizado' : 'criado'}.');
      await _load();
    } catch (e) {
      _snack('Erro: $e');
    }
  }

  Future<void> _delete(Map<String, Object?> row) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Excluir ${_c.singular}?'),
        content: Text('"${row[_c.titleKey]}" será removido.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await widget.client.post(_c.deletePath!, {_c.idKey: row[_c.idKey]});
      _snack('${_c.singular} excluído.');
      await _load();
    } catch (e) {
      _snack('Erro: $e');
    }
  }

  void _snack(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _c.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconButton(
                onPressed: _load,
                tooltip: 'Recarregar',
                icon: const Icon(Icons.refresh),
              ),
              if (_c.canCreate)
                FilledButton.icon(
                  onPressed: () => _openForm(),
                  icon: const Icon(Icons.add),
                  label: Text('Novo ${_c.singular}'),
                ),
            ],
          ),
        ),
        Expanded(child: _body(scheme)),
      ],
    );
  }

  Widget _body(ColorScheme scheme) {
    if (_error != null) {
      return Center(
        child: Text(_error!, style: TextStyle(color: scheme.error)),
      );
    }
    if (_rows == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_rows!.isEmpty) {
      return Center(
        child: Text(
          'Nenhum ${_c.singular} ainda.',
          style: TextStyle(color: scheme.onSurfaceVariant),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      itemCount: _rows!.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, i) {
        final row = _rows![i];
        return ListTile(
          title: Text(
            '${row[_c.titleKey] ?? '(sem título)'}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: _c.subtitleKey != null
              ? Text('${row[_c.subtitleKey] ?? ''}')
              : null,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_c.canEdit)
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => _openForm(row: row),
                ),
              if (_c.canDelete)
                IconButton(
                  icon: Icon(Icons.delete_outline, color: scheme.error),
                  onPressed: () => _delete(row),
                ),
            ],
          ),
        );
      },
    );
  }
}
