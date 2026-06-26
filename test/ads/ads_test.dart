import 'package:flenx/ads/ad_slot.dart';
import 'package:flenx/ads/ads_config.dart';
import 'package:jaspr_test/jaspr_test.dart';

void main() {
  const ads = AdsConfig(clientId: 'ca-pub-123', placements: [
    AdPlacement(slot: 'home', paths: ['/']),
    AdPlacement(slot: 'tech', categories: ['Tecnologia']),
    AdPlacement(slot: 'todas'), // sem restrição
  ]);

  group('AdsConfig.placementsFor', () {
    test('home: mostra slot da home + o sem restrição', () {
      final ps = ads.placementsFor(path: '/');
      expect(ps.map((p) => p.slot), containsAll(['home', 'todas']));
      expect(ps.map((p) => p.slot), isNot(contains('tech')));
    });

    test('categoria Tecnologia: mostra o da categoria + o sem restrição', () {
      final ps = ads.placementsFor(category: 'Tecnologia');
      expect(ps.map((p) => p.slot), containsAll(['tech', 'todas']));
      expect(ps.map((p) => p.slot), isNot(contains('home')));
    });

    test('desativado não mostra nada', () {
      const off = AdsConfig(
          clientId: 'x', enabled: false, placements: [AdPlacement(slot: 'a')]);
      expect(off.placementsFor(path: '/'), isEmpty);
    });

    test('loaderUrl inclui o client id', () {
      expect(ads.loaderUrl, contains('client=ca-pub-123'));
    });
  });

  group('FlenxAds', () {
    testComponents('renderiza as unidades do AdSense (ins.adsbygoogle)',
        (tester) async {
      tester.pumpComponent(const FlenxAds(ads, path: '/'));
      expect(find.tag('ins'), findsNComponents(2)); // home + todas
    });
  });
}
