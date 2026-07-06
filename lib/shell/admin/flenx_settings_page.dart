import 'dart:convert';

import 'package:flutter/material.dart';

import 'admin_rest_client.dart';
import 'settings_field.dart';

/// Editor de configurações em forma de JSON num único registro (`site_settings`
/// id=1, coluna `data`). Usado para **editar a tela home** (hero, destaques) e
/// outras opções do site sem código. Carrega, edita os [fields] e salva o JSON.
class FlenxSettingsPage extends StatefulWidget {
  const FlenxSettingsPage({
    required this.fields,
    this.client = const AdminRestClient(),
    this.getPath = '/api/settings/get?id=1',
    this.updatePath = '/api/settings/update',
    this.id = '1',
    this.title = 'Tela inicial',
    this.intro = 'Edite os textos da home. As mudanças aparecem ao recarregar.',
    super.key,
  });

  final List<SettingField> fields;
  final AdminRestClient client;
  final String getPath;
  final String updatePath;
  final String id;
  final String title;
  final String intro;

  @override
  State<FlenxSettingsPage> createState() => _FlenxSettingsPageState();
}

class _FlenxSettingsPageState extends State<FlenxSettingsPage> {
  final _controllers = <String, TextEditingController>{};
  bool _loading = true;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    for (final f in widget.fields) {
      _controllers[f.key] = TextEditingController();
    }
    _load();
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final row = await widget.client.getOne(widget.getPath);
      final data = _decode(row?['data']);
      for (final f in widget.fields) {
        _controllers[f.key]!.text = '${data[f.key] ?? ''}';
      }
    } catch (e) {
      _error = '$e';
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Map<String, Object?> _decode(Object? raw) {
    if (raw is Map) return raw.cast<String, Object?>();
    if (raw is String && raw.trim().isNotEmpty) {
      try {
        final d = jsonDecode(raw);
        if (d is Map) return d.cast<String, Object?>();
      } catch (_) {
        /* ignora */
      }
    }
    return {};
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final data = {
        for (final f in widget.fields) f.key: _controllers[f.key]!.text.trim(),
      };
      await widget.client.post(widget.updatePath, {
        'id': widget.id,
        'data': jsonEncode(data),
      });
      _snack('Configurações salvas. Recarregue o site para ver.');
    } catch (e) {
      _snack('Erro ao salvar: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _snack(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Text(_error!, style: TextStyle(color: scheme.error)),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined),
              label: const Text('Salvar'),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(widget.intro, style: TextStyle(color: scheme.onSurfaceVariant)),
        const SizedBox(height: 20),
        for (final f in widget.fields)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: TextField(
              controller: _controllers[f.key],
              minLines: f.multiline ? 3 : 1,
              maxLines: f.multiline ? 8 : 1,
              decoration: InputDecoration(
                labelText: f.label,
                hintText: f.hint,
                border: const OutlineInputBorder(),
              ),
            ),
          ),
      ],
    );
  }
}
