import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Serviço de token JWT (HS256) — emite e valida tokens próprios do app.
/// Para Firebase Auth, veja [FirebaseAuthVerifier] (valida o ID token do Firebase).
class JwtService {
  const JwtService(this.secret, {this.issuer});

  /// Segredo HMAC — leia do `.env` (`JWT_SECRET`), nunca hardcode.
  final String secret;
  final String? issuer;

  /// Emite um token assinado com [claims] (ex.: `{sub, email, role}`).
  String sign(
    Map<String, Object?> claims, {
    Duration expiresIn = const Duration(days: 7),
  }) {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final payload = <String, Object?>{
      ...claims,
      'iat': now,
      'exp': now + expiresIn.inSeconds,
      if (issuer != null) 'iss': issuer,
    };
    final h = _b64(jsonEncode({'alg': 'HS256', 'typ': 'JWT'}));
    final p = _b64(jsonEncode(payload));
    final sig = _sign('$h.$p');
    return '$h.$p.$sig';
  }

  /// Valida o token; retorna os claims ou `null` se inválido/expirado.
  Map<String, Object?>? verify(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return null;
    final expected = _sign('${parts[0]}.${parts[1]}');
    if (!_constTimeEquals(expected, parts[2])) return null;
    final claims = jsonDecode(_unb64(parts[1])) as Map<String, Object?>;
    final exp = claims['exp'];
    if (exp is int && DateTime.now().millisecondsSinceEpoch ~/ 1000 > exp) {
      return null; // expirado
    }
    return claims;
  }

  String _sign(String data) => _b64Bytes(
    Hmac(sha256, utf8.encode(secret)).convert(utf8.encode(data)).bytes,
  );

  String _b64(String s) => _b64Bytes(utf8.encode(s));
  String _b64Bytes(List<int> b) => base64Url.encode(b).replaceAll('=', '');
  String _unb64(String s) =>
      utf8.decode(base64Url.decode(s + '=' * ((4 - s.length % 4) % 4)));

  bool _constTimeEquals(String a, String b) {
    if (a.length != b.length) return false;
    var r = 0;
    for (var i = 0; i < a.length; i++) {
      r |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return r == 0;
  }
}
