import 'package:flutter_test/flutter_test.dart';
import 'package:flext/api/api.dart';

void main() {
  group('ApiResponse (envelope padrão)', () {
    test('ok envolve os dados', () {
      final r = ApiResponse.ok({'id': 1}).toJson();
      expect(r['success'], isTrue);
      expect(r['data'], {'id': 1});
      expect(r['error'], isNull);
      expect(r.containsKey('meta'), isFalse);
    });

    test('fail padroniza erro', () {
      final r = ApiResponse.fail('inválido').toJson();
      expect(r['success'], isFalse);
      expect(r['error'], 'inválido');
      expect(r['data'], isNull);
    });

    test('page inclui meta de paginação', () {
      final meta = PageMeta(page: 2, perPage: 10, total: 35);
      final r = ApiResponse.page([1, 2, 3], meta).toJson();
      expect(r['success'], isTrue);
      expect(r['data'], [1, 2, 3]);
      expect(r['meta']['page'], 2);
      expect(r['meta']['totalPages'], 4);
    });
  });
}
