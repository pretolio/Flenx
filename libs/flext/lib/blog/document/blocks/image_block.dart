import '../post_block.dart';

/// Imagem com legenda e crédito (estilo G1). Renderiza como `<figure>` para
/// permitir legenda semântica — o renderer Markdown deixa HTML de bloco passar.
class ImageBlock extends PostBlock {
  const ImageBlock(this.url, {this.caption, this.credit, this.alt});

  final String url;
  final String? caption;
  final String? credit;
  final String? alt;

  @override
  String get type => 'image';

  @override
  String toMarkdown() {
    final altText = alt ?? caption ?? '';
    final legend = [
      if (caption != null && caption!.trim().isNotEmpty) caption!.trim(),
      if (credit != null && credit!.trim().isNotEmpty)
        '<span class="credit">${credit!.trim()}</span>',
    ].join(' — ');
    final figcaption =
        legend.isEmpty ? '' : '\n  <figcaption>$legend</figcaption>';
    return '<figure>\n  <img src="$url" alt="$altText" />$figcaption\n</figure>';
  }

  @override
  Map<String, Object?> data() =>
      {'url': url, 'caption': caption, 'credit': credit, 'alt': alt};

  factory ImageBlock.fromJson(Map<String, Object?> j) => ImageBlock(
        (j['url'] as String?) ?? '',
        caption: j['caption'] as String?,
        credit: j['credit'] as String?,
        alt: j['alt'] as String?,
      );
}
