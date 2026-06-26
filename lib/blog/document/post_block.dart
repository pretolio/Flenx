/// Bloco de conteúdo de um post rico (estilo G1). Cada tipo de bloco
/// (parágrafo, subtítulo, imagem, citação, lista, embed, divisor) é uma
/// subclasse com seu próprio arquivo. Um bloco sabe se serializar para JSON
/// (persistência estruturada) e para Markdown (render via [MarkdownRenderer]).
abstract class PostBlock {
  const PostBlock();

  /// Discriminador usado no JSON (`{"type": ...}`) e pela fábrica.
  String get type;

  /// Markdown equivalente — funil único de renderização do corpo do post.
  String toMarkdown();

  /// Representação serializável (sem o `type`, que é injetado por [toJson]).
  Map<String, Object?> data();

  Map<String, Object?> toJson() => {'type': type, ...data()};
}
