import 'package:flutter/material.dart';

import 'block_type.dart';
import 'editable_block.dart';

/// Card de edição de UM bloco do post. Mostra os campos conforme o tipo e os
/// controles de mover/remover. Edita o [block] e avisa via [onChanged].
class BlockCard extends StatelessWidget {
  const BlockCard({
    required this.block,
    required this.onChanged,
    required this.onRemove,
    required this.onMoveUp,
    required this.onMoveDown,
    super.key,
  });

  final EditableBlock block;
  final VoidCallback onChanged;
  final VoidCallback onRemove;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(block.type.icon, size: 18, color: scheme.primary),
                const SizedBox(width: 8),
                Text(
                  block.type.label,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                IconButton(
                  tooltip: 'Subir',
                  icon: const Icon(Icons.arrow_upward, size: 18),
                  onPressed: onMoveUp,
                ),
                IconButton(
                  tooltip: 'Descer',
                  icon: const Icon(Icons.arrow_downward, size: 18),
                  onPressed: onMoveDown,
                ),
                IconButton(
                  tooltip: 'Remover',
                  icon: const Icon(Icons.delete_outline, size: 18),
                  color: scheme.error,
                  onPressed: onRemove,
                ),
              ],
            ),
            const SizedBox(height: 8),
            ..._fields(),
          ],
        ),
      ),
    );
  }

  List<Widget> _fields() {
    switch (block.type) {
      case BlockType.divider:
        return const [Text('— linha divisória —')];
      case BlockType.image:
        return [
          _field('URL da imagem', (v) => block.url = v, block.url),
          _field('Legenda', (v) => block.text = v, block.text),
          _field(
            'Crédito (ex.: Foto: Agência)',
            (v) => block.secondary = v,
            block.secondary,
          ),
        ];
      case BlockType.quote:
        return [
          _field(
            'Texto da citação',
            (v) => block.text = v,
            block.text,
            lines: 2,
          ),
          _field('Fonte / autor', (v) => block.secondary = v, block.secondary),
        ];
      case BlockType.heading:
        return [
          _field('Texto do subtítulo', (v) => block.text = v, block.text),
          Row(
            children: [
              const Text('Nível: '),
              DropdownButton<int>(
                value: block.level,
                items: const [2, 3, 4]
                    .map((n) => DropdownMenuItem(value: n, child: Text('H$n')))
                    .toList(),
                onChanged: (v) {
                  block.level = v ?? 2;
                  onChanged();
                },
              ),
            ],
          ),
        ];
      case BlockType.list:
        return [
          _field(
            'Itens (um por linha)',
            (v) => block.text = v,
            block.text,
            lines: 3,
          ),
          Row(
            children: [
              Checkbox(
                value: block.ordered,
                onChanged: (v) {
                  block.ordered = v ?? false;
                  onChanged();
                },
              ),
              const Text('Lista numerada'),
            ],
          ),
        ];
      case BlockType.embed:
        return [
          _field(
            'HTML do embed (<iframe ...>)',
            (v) => block.text = v,
            block.text,
            lines: 3,
          ),
        ];
      case BlockType.paragraph:
        return [
          _field(
            'Texto (aceita Markdown)',
            (v) => block.text = v,
            block.text,
            lines: 3,
          ),
        ];
    }
  }

  Widget _field(
    String label,
    ValueChanged<String> onUpdate,
    String initial, {
    int lines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        initialValue: initial,
        minLines: lines,
        maxLines: lines == 1 ? 1 : lines + 2,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
        onChanged: (v) {
          onUpdate(v);
          onChanged();
        },
      ),
    );
  }
}
