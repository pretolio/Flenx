import 'package:flext/blog/document/post_document.dart';
import 'package:flext/blog/utils/slugify.dart';
import 'package:flutter/material.dart';

import 'block_card.dart';
import 'block_type.dart';
import 'editable_block.dart';
import 'post_api_client.dart';
import 'post_meta_form.dart';

/// Editor de post completo (estilo G1): cabeçalho + blocos arrastáveis
/// (parágrafo, subtítulo, imagem c/ legenda, citação, lista, vídeo). Salva no
/// **banco** via `/api/blog/posts` — a segunda forma de criar posts, ao lado
/// dos arquivos `.md`.
class PostEditorPage extends StatefulWidget {
  const PostEditorPage({this.api = const PostApiClient(), super.key});

  final PostApiClient api;

  @override
  State<PostEditorPage> createState() => _PostEditorPageState();
}

class _PostEditorPageState extends State<PostEditorPage> {
  final _meta = PostMetaControllers();
  final _blocks = <EditableBlock>[];
  bool _draft = false;
  bool _saving = false;
  int _seq = 0;

  @override
  void initState() {
    super.initState();
    _add(BlockType.paragraph);
  }

  @override
  void dispose() {
    _meta.dispose();
    super.dispose();
  }

  void _add(BlockType type) =>
      setState(() => _blocks.add(EditableBlock(_seq++, type)));

  void _move(int i, int delta) {
    final j = i + delta;
    if (j < 0 || j >= _blocks.length) return;
    setState(() {
      final b = _blocks.removeAt(i);
      _blocks.insert(j, b);
    });
  }

  Future<void> _save() async {
    final title = _meta.title.text.trim();
    if (title.isEmpty) {
      _snack('Informe a manchete (título).');
      return;
    }
    setState(() => _saving = true);
    try {
      final doc = PostDocument(
          _blocks.map((b) => b.toPostBlock()).toList(growable: false));
      final id = await widget.api.create({
        'slug': Slugify.call(title),
        'title': title,
        'subtitle': _meta.subtitle.text.trim(),
        'description': _meta.description.text.trim(),
        'body': doc.toMarkdown(),
        'blocks': doc.toJsonString(),
        'author': _meta.author.text.trim(),
        'image': _meta.image.text.trim(),
        'category': _meta.category.text.trim(),
        'tags': _meta.tags.text.trim(),
        'draft': _draft ? '1' : '0',
        'date': DateTime.now().toIso8601String(),
      });
      _snack('Post salvo no banco (id $id). Já aparece no /blog.');
    } catch (e) {
      _snack('Erro ao salvar: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _snack(String msg) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(children: [
          const Expanded(
            child: Text('Novo post',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
          ),
          FilledButton.icon(
            onPressed: _saving ? null : _save,
            icon: _saving
                ? const SizedBox(
                    width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.save_outlined),
            label: const Text('Salvar no banco'),
          ),
        ]),
        const SizedBox(height: 16),
        PostMetaForm(
          c: _meta,
          draft: _draft,
          onDraftChanged: (v) => setState(() => _draft = v),
        ),
        const Divider(height: 32),
        const Text('Corpo do post',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        for (var i = 0; i < _blocks.length; i++)
          BlockCard(
            key: ValueKey(_blocks[i].id),
            block: _blocks[i],
            onChanged: () {},
            onRemove: () => setState(() => _blocks.removeAt(i)),
            onMoveUp: () => _move(i, -1),
            onMoveDown: () => _move(i, 1),
          ),
        const SizedBox(height: 8),
        _addMenu(),
      ],
    );
  }

  Widget _addMenu() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final t in BlockType.values)
          OutlinedButton.icon(
            onPressed: () => _add(t),
            icon: Icon(t.icon, size: 18),
            label: Text(t.label),
          ),
      ],
    );
  }
}
