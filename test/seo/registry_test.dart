import 'package:flutter_test/flutter_test.dart';
import 'package:flenx/seo/models/route_meta.dart';
import 'package:flenx/seo/sources/dynamic_route_source.dart';
import 'package:flenx/seo/sources/route_registry.dart';
import 'package:flenx/seo/sources/static_route_source.dart';

void main() {
  group('RouteRegistry + DynamicRouteSource', () {
    test('resolve estáticas + dinâmicas e expande os itens', () async {
      final registry = RouteRegistry([
        const StaticRouteSource([
          RouteMeta(path: '/', title: 'Home', description: 'd'),
        ]),
        DynamicRouteSource<String>(
          provider: () async => ['a', 'b', 'c'],
          build: (slug) =>
              RouteMeta(path: '/blog/$slug', title: slug, description: 'd'),
        ),
      ]);

      final all = await registry.resolveAll();
      expect(all.map((r) => r.path), [
        '/',
        '/blog/a',
        '/blog/b',
        '/blog/c',
      ]);
    });

    test('deduplica paths repetidos', () async {
      final registry = RouteRegistry([
        const StaticRouteSource([
          RouteMeta(path: '/', title: 'A', description: 'd'),
          RouteMeta(path: '/', title: 'B', description: 'd'),
        ]),
      ]);
      final all = await registry.resolveAll();
      expect(all, hasLength(1));
      expect(all.first.title, 'A');
    });

    test('indexable() remove rotas noindex', () async {
      final registry = RouteRegistry([
        const StaticRouteSource([
          RouteMeta(path: '/', title: 'Home', description: 'd'),
          RouteMeta(
              path: '/x', title: 'X', description: 'd', noindex: true),
        ]),
      ]);
      final idx = await registry.indexable();
      expect(idx.map((r) => r.path), ['/']);
    });

    test('find() localiza por path', () async {
      final registry = RouteRegistry([
        const StaticRouteSource([
          RouteMeta(path: '/about', title: 'Sobre', description: 'd'),
        ]),
      ]);
      final found = await registry.find('/about');
      expect(found?.title, 'Sobre');
      expect(await registry.find('/nope'), isNull);
    });
  });
}

