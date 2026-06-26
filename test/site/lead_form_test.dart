import 'package:jaspr_test/jaspr_test.dart';
import 'package:flenx/site/components/lead_form.dart';
import 'package:flenx/site/components/whatsapp_button.dart';

void main() {
  group('LeadForm', () {
    testComponents('renderiza o formulário com o botão de envio', (tester) async {
      tester.pumpComponent(const LeadForm(action: '/api/leads'));
      expect(find.tag('form'), findsOneComponent);
      expect(find.text('Quero saber mais'), findsOneComponent);
      expect(find.text('Nome'), findsOneComponent);
      expect(find.text('E-mail'), findsOneComponent);
    });

    testComponents('mostra agradecimento quando submetido', (tester) async {
      tester.pumpComponent(const LeadForm(action: '/api/leads', submitted: true));
      expect(find.text('Recebemos seu contato!'), findsOneComponent);
      expect(find.tag('form'), findsNothing);
    });
  });

  group('WhatsappButton', () {
    testComponents('renderiza o link com o url do WhatsApp', (tester) async {
      tester.pumpComponent(const WhatsappButton(
        url: 'https://wa.me/5511999999999?text=oi',
        label: 'Fale no WhatsApp',
      ));
      expect(find.text('Fale no WhatsApp'), findsOneComponent);
      expect(find.tag('a'), findsOneComponent);
    });
  });
}

