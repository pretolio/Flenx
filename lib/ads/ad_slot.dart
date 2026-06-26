import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'ads_config.dart';

/// Renderiza **um** anúncio: uma unidade do AdSense (`ins.adsbygoogle` + push)
/// ou um HTML custom. Precisa do loader do AdSense no `<head>` (o
/// `FlenxApp.run(ads: ...)` injeta automaticamente).
class AdSlot extends StatelessComponent {
  const AdSlot({required this.clientId, required this.placement, super.key});

  final String clientId;
  final AdPlacement placement;

  @override
  Component build(BuildContext context) {
    if (placement.html != null) {
      return div(styles: Styles(raw: {'margin': '16px 0'}),
          [RawText(placement.html!)]);
    }
    return div(
      styles: Styles(raw: {'margin': '16px 0', 'text-align': 'center'}),
      [
        Component.element(tag: 'ins', attributes: {
          'class': 'adsbygoogle',
          'style': 'display:block',
          'data-ad-client': clientId,
          'data-ad-slot': placement.slot,
          'data-ad-format': placement.format,
          'data-full-width-responsive': 'true',
        }, children: const []),
        Component.element(tag: 'script', children: const [
          RawText('(adsbygoogle = window.adsbygoogle || []).push({});'),
        ]),
      ],
    );
  }
}

/// Renderiza **todos** os anúncios configurados para um contexto. É só dropar
/// onde quiser exibir: `FlenxAds(ads, path: ctx.path)` ou
/// `FlenxAds(ads, category: 'Tecnologia', position: AdPosition.top)`.
class FlenxAds extends StatelessComponent {
  const FlenxAds(
    this.config, {
    this.path,
    this.category,
    this.position,
    super.key,
  });

  final AdsConfig config;
  final String? path;
  final String? category;
  final AdPosition? position;

  @override
  Component build(BuildContext context) {
    final units = config.placementsFor(
        path: path, category: category, position: position);
    return div(
      styles: Styles(raw: {if (units.isEmpty) 'display': 'none'}),
      [
        for (final p in units)
          AdSlot(clientId: config.clientId, placement: p),
      ],
    );
  }
}
