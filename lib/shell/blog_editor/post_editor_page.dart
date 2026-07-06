import 'package:flutter/material.dart';

import '../../blog/document/post_document.dart';
import '../../blog/utils/slugify.dart';
import '../admin/admin_rest_client.dart';
import 'block_card.dart';
import 'block_type.dart';
import 'editable_block.dart';
import 'post_meta_form.dart';

/// Editor de post completo (estilo G1): cabeçalho + blocos (parágrafo,
/// subtítulo, imagem c/ legenda, citação, lista, vídeo). Cria OU edita um post
/// no banco via a API (`createPath`/`updatePath`). Reaproveitável por qualquer
/// portal (news, demo) — salva o corpo em Markdown + os blocos em JSON.
class PostEditorPage extends StatefulWidget {
  const PostEditorPage({
    this.client = const AdminRestClient(),
    this.createPath = '/api/blog/posts',
    this.updatePath = '/api/blog/posts/update',
    this.existing,
    this.onSaved,
    this.defaultAuthor,
    super.key,
  });

  final AdminRestClient client;
  final String createPath;
  final String updatePath;

  /// Linha do post para edição (`null` = novo post).
  final Map<String, Object?>? existing;
  final VoidCallback? onSaved;

  /// Autor pré-preenchido ao criar um post novo (ex.: o usuário logado).
  final String? defaultAuthor;

  @override
  State<PostEditorPage> createState() => _PostEditorPageState();
}

class _PostEditorPageState extends State<PostEditorPage> {
  final _meta = PostMetaControllers();
  final _blocks = <EditableBlock>[];
  bool _draft = false;
  bool _saving = false;
  int _seq = 0;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    if (e != null) {
      _meta.title.text = '${e['title'] ?? ''}';
      _meta.subtitle.text = '${e['subtitle'] ?? ''}';
      _meta.description.text = '${e['description'] ?? ''}';
      _meta.author.text = '${e['author'] ?? ''}';
      _meta.category.text = '${e['category'] ?? ''}';
      _meta.tags.text = '${e['tags'] ?? ''}';
      _meta.image.text = '${e['image'] ?? ''}';
      _draft = '${e['draft']}' == '1' || e['draft'] == true;
      for (final b in PostDocument.parse('${e['blocks'] ?? ''}').blocks) {
        _blocks.add(EditableBlock.fromPostBlock(_seq++, b));
      }
    } else if (widget.defaultAuthor != null) {
      // Post novo: assina com o usuário logado (editável se quiser trocar).
      _meta.author.text = widget.defaultAuthor!;
    }
    if (_blocks.isEmpty) _add(BlockType.paragraph);
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
    setState(() => _blocks.insert(j, _blocks.removeAt(i)));
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
        _blocks.map((b) => b.toPostBlock()).toList(growable: false),
      );
      final payload = <String, Object?>{
        if (_isEdit) 'id': widget.existing!['id'],
        'slug': _isEdit ? widget.existing!['slug'] : Slugify.call(title),
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
        'date': _isEdit
            ? '${widget.existing!['date']}'
            : DateTime.now().toIso8601String(),
      };
      await widget.client.post(
        _isEdit ? widget.updatePath : widget.createPath,
        payload,
      );
      _snack(_isEdit ? 'Post atualizado.' : 'Post publicado no blog.');
      widget.onSaved?.call();
    } catch (e) {
      _snack('Erro ao salvar: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                _isEdit ? 'Editar post' : 'Novo post',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            if (widget.onSaved != null)
              TextButton(
                onPressed: widget.onSaved,
                child: const Text('Voltar'),
              ),
            const SizedBox(width: 8),
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
        const SizedBox(height: 16),
        PostMetaForm(
          c: _meta,
          draft: _draft,
          onDraftChanged: (v) => setState(() => _draft = v),
        ),
        const Divider(height: 32),
        const Text(
          'Corpo do post',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
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
        Wrap(
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
        ),
      ],
    );
  }
}
