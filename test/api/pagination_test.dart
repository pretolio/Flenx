import 'package:flutter_test/flutter_test.dart';
import 'package:flenx/api/api.dart';

void main() {
  group('PageRequest', () {
    test('offset/limit corretos', () {
      const p = PageRequest(page: 3, perPage: 20);
      expect(p.offset, 40);
      expect(p.limit, 20);
    });

    test('fromQuery aplica limites sãos', () {
      final p = PageRequest.fromQuery({
        'page': '2',
        'perPage': '500',
      }, maxPerPage: 100);
      expect(p.page, 2);
      expect(p.perPage, 100); // capado
      final d = PageRequest.fromQuery({}, defaultPerPage: 15);
      expect(d.page, 1);
      expect(d.perPage, 15);
    });
  });

  group('PageMeta', () {
    test('calcula totalPages e flags', () {
      const meta = PageMeta(page: 2, perPage: 10, total: 35);
      expect(meta.totalPages, 4);
      expect(meta.hasNext, isTrue);
      expect(meta.hasPrev, isTrue);
      const last = PageMeta(page: 4, perPage: 10, total: 35);
      expect(last.hasNext, isFalse);
    });

    test('lista vazia → 1 página', () {
      const meta = PageMeta(page: 1, perPage: 10, total: 0);
      expect(meta.totalPages, 1);
    });
  });
}
