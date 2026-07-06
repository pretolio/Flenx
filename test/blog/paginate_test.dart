import 'package:flutter_test/flutter_test.dart';
import 'package:flenx/blog/utils/paginate.dart';

void main() {
  group('Paginate', () {
    final all = List.generate(10, (i) => i); // 0..9

    test('fatia a página corretamente', () {
      final p1 = Paginate.of(all, page: 1, perPage: 4);
      expect(p1.items, [0, 1, 2, 3]);
      expect(p1.current, 1);
      expect(p1.totalPages, 3); // 10/4 = 3 páginas

      final p3 = Paginate.of(all, page: 3, perPage: 4);
      expect(p3.items, [8, 9]);
      expect(p3.current, 3);
    });

    test('clampa página fora do intervalo', () {
      expect(Paginate.of(all, page: 0, perPage: 4).current, 1);
      expect(Paginate.of(all, page: 99, perPage: 4).current, 3);
    });

    test('lista vazia tem 1 página', () {
      final p = Paginate.of(<int>[], page: 1, perPage: 4);
      expect(p.items, isEmpty);
      expect(p.totalPages, 1);
    });
  });
}
