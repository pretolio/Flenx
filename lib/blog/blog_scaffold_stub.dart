/// Stub Web de [BlogScaffold] — criação de arquivos só existe no servidor.
class BlogScaffold {
  const BlogScaffold({this.dir = 'content/blog'});

  final String dir;

  Never _unsupported() =>
      throw UnsupportedError('BlogScaffold só está disponível no servidor (dart:io).');

  Never markdown({
    required String title,
    String category = 'Sem categoria',
    List<String> tags = const [],
    DateTime? date,
    String author = 'Equipe Flenx',
    String description = 'TODO — resumo curto e atraente (até ~155 caracteres).',
    bool draft = true,
    String body = 'Escreva o conteúdo aqui em **Markdown**.',
  }) => _unsupported();

  Never create({
    required String title,
    String category = 'Sem categoria',
    List<String> tags = const [],
    DateTime? date,
    String author = 'Equipe Flenx',
    String description = 'TODO — resumo curto e atraente (até ~155 caracteres).',
    bool draft = true,
    String body = 'Escreva o conteúdo aqui em **Markdown**.',
  }) => _unsupported();

  Never createWelcome() => _unsupported();
}
