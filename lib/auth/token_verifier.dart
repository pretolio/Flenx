import 'dart:async';

/// Verifica um token (Bearer) e devolve os claims, ou `null` se inválido.
///
/// Use [JwtService.verify] para tokens próprios, ou forneça uma função que
/// valida o **ID token do Firebase Auth** (recomendado: validar o JWT RS256
/// contra os certificados públicos do Google, ex. via `package:jose`).
typedef TokenVerifier = FutureOr<Map<String, Object?>?> Function(String token);
