import 'package:markdown/markdown.dart' as md;

/// Converte Markdown em HTML (usado para renderizar o corpo dos posts no SSR).
/// Usa o pacote oficial `markdown` com extensões GitHub-flavored.
class MarkdownRenderer {
  const MarkdownRenderer();

  String toHtml(String markdown) {
    return md.markdownToHtml(
      markdown,
      extensionSet: md.ExtensionSet.gitHubWeb,
      inlineSyntaxes: [md.InlineHtmlSyntax()],
    );
  }
}
