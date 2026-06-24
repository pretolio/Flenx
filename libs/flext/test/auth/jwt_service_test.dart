import 'package:flutter_test/flutter_test.dart';
import 'package:flext/auth/auth.dart';

void main() {
  group('JwtService', () {
    const jwt = JwtService('segredo-super');

    test('assina e valida (roundtrip com claims)', () {
      final token = jwt.sign({'sub': '42', 'role': 'admin'});
      final claims = jwt.verify(token);
      expect(claims, isNotNull);
      expect(claims!['sub'], '42');
      expect(claims['role'], 'admin');
      expect(claims['exp'], isA<int>());
    });

    test('rejeita token adulterado', () {
      final token = jwt.sign({'sub': '1'});
      final tampered = '${token.substring(0, token.length - 2)}xx';
      expect(jwt.verify(tampered), isNull);
      expect(jwt.verify('aaa.bbb.ccc'), isNull);
    });

    test('rejeita token expirado', () {
      final token = jwt.sign({'sub': '1'}, expiresIn: const Duration(seconds: -5));
      expect(jwt.verify(token), isNull);
    });

    test('rejeita segredo errado', () {
      final token = jwt.sign({'sub': '1'});
      expect(const JwtService('outro').verify(token), isNull);
    });
  });
}
