import 'package:flutter_test/flutter_test.dart';
import 'package:flext/site/models/lead.dart';
import 'package:flext/site/models/site_config.dart';

void main() {
  group('Lead', () {
    test('serializa e desserializa (round-trip)', () {
      final lead = Lead(
        name: 'Ana',
        email: 'ana@x.com',
        message: 'oi',
        createdAt: DateTime.utc(2026, 6, 23),
      );
      final back = Lead.fromJson(lead.toJson());
      expect(back.name, 'Ana');
      expect(back.email, 'ana@x.com');
      expect(back.message, 'oi');
    });

    test('validação exige nome e e-mail', () {
      expect(const Lead(name: 'Ana', email: 'a@b.com').isValid, isTrue);
      expect(const Lead(name: '', email: 'a@b.com').isValid, isFalse);
      expect(const Lead(name: 'Ana', email: 'sem-arroba').isValid, isFalse);
    });
  });

  group('SiteConfig', () {
    test('monta a URL do WhatsApp com a mensagem codificada', () {
      const c = SiteConfig(whatsappNumber: '5511988887777', whatsappMessage: 'Olá Flext');
      expect(c.whatsappUrl, startsWith('https://wa.me/5511988887777?text='));
      expect(c.whatsappUrl, contains('Ol%C3%A1%20Flext'));
    });
  });
}

