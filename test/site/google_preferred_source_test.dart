import 'package:flenx/flenx.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('URL por publicationId', () {
    const c = GooglePreferredSource(name: 'X', publicationId: 'ABC');
    expect(
      c.url,
      'https://news.google.com/swg/ui/v1/addpreferredsource'
      '?publication_id=ABC&hl=pt-BR',
    );
  });

  test('URL por domínio (limpa protocolo e caminho)', () {
    const c = GooglePreferredSource(name: 'X', domain: 'https://site.com.br/a');
    expect(
      c.url,
      'https://www.google.com/preferences/source?q=site.com.br&hl=pt-BR',
    );
  });
}
