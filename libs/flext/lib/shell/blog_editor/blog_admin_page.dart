import 'package:flutter/material.dart';

import '../admin/admin_rest_client.dart';
import 'post_editor_page.dart';

/// Gerência de posts/notícias no admin: lista os posts do banco e abre o
/// [PostEditorPage] para criar, editar ou excluir. Tela única reutilizável
/// (news, demo) — alterna entre a lista e o editor.
class BlogAdminPage extends StatefulWidget {
  const BlogAdminPage({
    this.client = const AdminRestClient(),
    this.listPath = '/api/blog/posts/list',
    this.createPath = '/api/blog/posts',
    this.updatePath = '/api/blog/posts/update',
    this.deletePath = '/api/blog/posts/delete',
    this.title = 'Notícias',
    super.key,
  });

  final AdminRestClient client;
  final String listPath;
  final String createPath;
  final String updatePath;
  final String deletePath;
  final String title;

  @override
  State<BlogAdminPage> createState() => _BlogAdminPageState();
}

class _BlogAdminPageState extends State<BlogAdminPage> {
  List<Map<String, Object?>>? _rows;
  String? _error;
  bool _editing = false;
  Map<String, Object?>? _current; // null + _editing == novo

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
      final rows = await widget.client.list(widget.listPath);
      if (mounted) setState(() => _rows = rows);
    } catch (e) {
      if (mounted) setState(() => _error = '$e');
    }
  }

  void _openEditor({Map<String, Object?>? row}) =>
      setState(() {
        _current = row;
        _editing = true;
      });

  void _closeEditor() {
    setState(() => _editing = false);
    _load();
  }

  Future<void> _delete(Map<String, Object?> row) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir post?'),
        content: Text('"${row['title']}" será removido do blog.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Excluir')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await widget.client.post(widget.deletePath, {'id': row['id']});
      await _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Erro: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_editing) {
      return PostEditorPage(
        client: widget.client,
        createPath: widget.createPath,
        updatePath: widget.updatePath,
        existing: _current,
        onSaved: _closeEditor,
      );
    }
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          child: Row(children: [
            Expanded(
              child: Text(widget.title,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w800)),
            ),
            IconButton(
                onPressed: _load,
                tooltip: 'Recarregar',
                icon: const Icon(Icons.refresh)),
            FilledButton.icon(
              onPressed: () => _openEditor(),
              icon: const Icon(Icons.add),
              label: const Text('Novo post'),
            ),
          ]),
        ),
        Expanded(child: _body(scheme)),
      ],
    );
  }

  Widget _body(ColorScheme scheme) {
    if (_error != null) {
      return Center(child: Text(_error!, style: TextStyle(color: scheme.error)));
    }
    if (_rows == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_rows!.isEmpty) {
      return Center(
          child: Text('Nenhum post no banco ainda. Crie o primeiro!',
              style: TextStyle(color: scheme.onSurfaceVariant)));
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      itemCount: _rows!.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, i) {
        final row = _rows![i];
        final draft = '${row['draft']}' == '1';
        return ListTile(
          title: Text('${row['title'] ?? '(sem título)'}',
              style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(
              '${row['category'] ?? ''}${draft ? '  ·  RASCUNHO' : ''}'),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => _openEditor(row: row)),
            IconButton(
                icon: Icon(Icons.delete_outline, color: scheme.error),
                onPressed: () => _delete(row)),
          ]),
        );
      },
    );
  }
}
