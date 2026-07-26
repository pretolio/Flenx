/// Camada de *growth*/omnipresença do Flenx — rastreamento (pixels/analytics),
/// eventos e consentimento (LGPD). Tudo genérico e config-driven: cada projeto
/// declara só os provedores que usa.
///
/// ```dart
/// FlenxApp.run(
///   tracking: FlenxTracking(providers: [Ga4('G-X'), MetaPixel('123')]),
///   consent: const FlenxConsent(policyHref: '/privacidade'),
///   ...
/// );
/// ```
library;

export 'tracking_provider.dart';
export 'tracking_providers.dart';
export 'flenx_tracking.dart';
export 'flenx_consent.dart';
export 'flenx_events.dart';
export 'flenx_view_event.dart';
