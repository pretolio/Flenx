import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Tamanho real da viewport no navegador — usado para dimensionar a ilha
/// Flutter para 100% da tela.
({double width, double height}) viewportSize() => (
  width: web.window.innerWidth.toDouble(),
  height: web.window.innerHeight.toDouble(),
);

/// Assina o evento `resize` da janela; retorna uma função que cancela a assinatura.
void Function() onViewportResize(void Function() callback) {
  void handler(web.Event _) => callback();
  final jsHandler = handler.toJS;
  web.window.addEventListener('resize', jsHandler);
  return () => web.window.removeEventListener('resize', jsHandler);
}
