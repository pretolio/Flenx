import 'package:flext/app.dart';

/// Anúncios do portal. Troque o `clientId` pelo seu `ca-pub-...` do AdSense e
/// os `slot` pelas suas unidades. Aqui: um na home e um nas páginas de
/// categoria "Tecnologia".
const newsAds = AdsConfig(
  clientId: 'ca-pub-0000000000000000',
  placements: [
    AdPlacement(slot: '1111111111', paths: ['/']),
    AdPlacement(slot: '2222222222', categories: ['Tecnologia']),
  ],
);
