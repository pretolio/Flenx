import 'package:flutter/material.dart';

import 'resource_config.dart';
import 'resource_field.dart';

/// Diálogo de criar/editar um registro, montado a partir dos
/// [ResourceConfig.fields]. Devolve o `Map` com os valores ao salvar, ou `null`
/// se cancelado. Sem lógica de rede — quem chama decide create/update.
class ResourceFormDialog extends StatefulWidget {
  const ResourceFormDialog({required this.config, this.initial, super.key});

  final ResourceConfig config;

  /// Valores iniciais (edição) ou `null` (criação).
  final Map<String, Object?>? initial;

  @override
  State<ResourceFormDialog> createState() => _ResourceFormDialogState();
}

class _ResourceFormDialogState extends State<ResourceFormDialog> {
  final _controllers = <String, TextEditingController>{};
  final _bools = <String, bool>{};
  final _selects = <String, String>{};

  @override
  void initState() {
    super.initState();
    for (final f in widget.config.fields) {
      final v = widget.initial?[f.key];
      switch (f.kind) {
        case FieldKind.boolean:
          _bools[f.key] = v == true || v == 1 || v == '1' || v == 'true';
        case FieldKind.select:
          _selects[f.key] =
              (v?.toString().isNotEmpty ?? false) ? v.toString() : f.options.first;
        default:
          _controllers[f.key] = TextEditingController(text: v?.toString() ?? '');
      }
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Map<String, Object?> _collect() => {
        if (widget.initial?[widget.config.idKey] != null)
          widget.config.idKey: widget.initial![widget.config.idKey],
        for (final f in widget.config.fields)
          f.key: switch (f.kind) {
            FieldKind.boolean => _bools[f.key]! ? '1' : '0',
            FieldKind.select => _selects[f.key],
            _ => _controllers[f.key]!.text.trim(),
          },
      };

  String? _validate() {
    for (final f in widget.config.fields) {
      if (f.required &&
          (_controllers[f.key]?.text.trim().isEmpty ?? false)) {
        return 'Preencha "${f.label}".';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initial != null;
    return AlertDialog(
      title: Text('${isEdit ? 'Editar' : 'Novo'} ${widget.config.singular}'),
      content: SizedBox(
        width: 460,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final f in widget.config.fields) _field(f),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar')),
        FilledButton(
          onPressed: () {
            final err = _validate();
            if (err != null) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(err)));
              return;
            }
            Navigator.pop(context, _collect());
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }

  Widget _field(ResourceField f) {
    final pad = const EdgeInsets.only(bottom: 12);
    if (f.kind == FieldKind.boolean) {
      return Padding(
        padding: pad,
        child: SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(f.label),
          value: _bools[f.key]!,
          onChanged: (v) => setState(() => _bools[f.key] = v),
        ),
      );
    }
    if (f.kind == FieldKind.select) {
      return Padding(
        padding: pad,
        child: DropdownButtonFormField<String>(
          initialValue: _selects[f.key],
          decoration: InputDecoration(
              labelText: f.label, border: const OutlineInputBorder()),
          items: [
            for (final o in f.options)
              DropdownMenuItem(value: o, child: Text(o)),
          ],
          onChanged: (v) => setState(() => _selects[f.key] = v ?? f.options.first),
        ),
      );
    }
    final lines = f.kind == FieldKind.multiline ? 4 : 1;
    return Padding(
      padding: pad,
      child: TextField(
        controller: _controllers[f.key],
        minLines: lines,
        maxLines: lines == 1 ? 1 : lines + 3,
        keyboardType:
            f.kind == FieldKind.number ? TextInputType.number : null,
        decoration: InputDecoration(
          labelText: f.label,
          hintText: f.hint,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }
}
