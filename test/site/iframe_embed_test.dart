import 'package:flenx/site/components/iframe_embed.dart';
import 'package:jaspr_test/jaspr_test.dart';

void main() {
  group('IframeEmbed', () {
    testComponents('renderiza um iframe com a URL (altura fixa)',
        (tester) async {
      tester.pumpComponent(
        const IframeEmbed('https://exemplo.com', height: 600),
      );
      expect(find.tag('iframe'), findsOneComponent);
    });

    testComponents('modo responsivo embrulha o iframe num wrapper',
        (tester) async {
      tester.pumpComponent(
        const IframeEmbed('https://youtube.com/embed/x',
            ratio: '16 / 9', classes: 'meu-embed'),
      );
      expect(find.tag('iframe'), findsOneComponent);
      expect(find.tag('div'), findsOneComponent); // wrapper de proporção
    });
  });
}
