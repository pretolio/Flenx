import 'package:flutter/material.dart';

/// Campos de cabeçalho do post (estilo G1): manchete, linha-fina, resumo,
/// autor, categoria, tags e imagem de capa. Guarda os controllers e os expõe
/// para a página montar o payload.
class PostMetaForm extends StatelessWidget {
  const PostMetaForm({
    required this.c,
    required this.onDraftChanged,
    required this.draft,
    super.key,
  });

  final PostMetaControllers c;
  final bool draft;
  final ValueChanged<bool> onDraftChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _f(c.title, 'Manchete (título)', big: true),
        _f(c.subtitle, 'Linha-fina (subtítulo)'),
        _f(c.description, 'Resumo (para listagem e SEO)', lines: 2),
        Row(children: [
          Expanded(child: _f(c.author, 'Autor')),
          const SizedBox(width: 12),
          Expanded(child: _f(c.category, 'Categoria (ex.: Brasil/Economia)')),
        ]),
        Row(children: [
          Expanded(child: _f(c.tags, 'Tags (separadas por vírgula)')),
          const SizedBox(width: 12),
          Expanded(child: _f(c.image, 'URL da imagem de capa')),
        ]),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Rascunho (não publica)'),
          value: draft,
          onChanged: onDraftChanged,
        ),
      ],
    );
  }

  Widget _f(TextEditingController ctrl, String label,
      {int lines = 1, bool big = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: ctrl,
        minLines: lines,
        maxLines: lines == 1 ? 1 : lines + 2,
        style: big
            ? const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)
            : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }
}

/// Agrupa os controllers do cabeçalho (1 lugar para criar/dar dispose).
class PostMetaControllers {
  final title = TextEditingController();
  final subtitle = TextEditingController();
  final description = TextEditingController();
  final author = TextEditingController();
  final category = TextEditingController();
  final tags = TextEditingController();
  final image = TextEditingController();

  void dispose() {
    for (final c in [
      title,
      subtitle,
      description,
      author,
      category,
      tags,
      image
    ]) {
      c.dispose();
    }
  }
}
