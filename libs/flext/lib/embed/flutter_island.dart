import 'dart:async';

import 'package:jaspr/jaspr.dart';
import 'package:jaspr_flutter_embed/jaspr_flutter_embed.dart';

import 'viewport.dart';

/// Embute um app Flutter (deferido) como ilha interativa em 100% da viewport,
/// acompanhando o resize (sem F5). Toda a plumbing (medir viewport, debounce,
/// remontar por `key`, constraints finitos) fica aqui na lib — o app só passa
/// o `loadLibrary` (do `@Import.onWeb ... deferred`) e o `builder`.
class FlutterIsland extends StatefulComponent {
  const FlutterIsland({
    required this.loadLibrary,
    required this.builder,
    this.debounce = const Duration(milliseconds: 200),
    super.key,
  });

  /// `Future` de `<deferred>.loadLibrary()`.
  final Future<void> loadLibrary;

  /// Constrói o widget Flutter raiz (ex.: `() => app.MeuAdmin()`). Tipado como
  /// `dynamic` de propósito: assim a lib NÃO importa `package:flutter` (o que
  /// puxaria `dart:ui`/FFI e quebraria a compilação do servidor).
  final dynamic Function() builder;

  final Duration debounce;

  @override
  State<FlutterIsland> createState() => _FlutterIslandState();
}

class _FlutterIslandState extends State<FlutterIsland> {
  ({double width, double height}) _vp = viewportSize();
  void Function()? _cancelResize;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _cancelResize = onViewportResize(() {
      _debounce?.cancel();
      _debounce = Timer(component.debounce, () {
        if (!mounted) return;
        final v = viewportSize();
        if (v.width != _vp.width || v.height != _vp.height) {
          setState(() => _vp = v);
        }
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _cancelResize?.call();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    return FlutterEmbedView.deferred(
      key: ValueKey('${_vp.width.round()}x${_vp.height.round()}'),
      constraints: ViewConstraints(
        minWidth: _vp.width,
        maxWidth: _vp.width,
        minHeight: _vp.height,
        maxHeight: _vp.height,
      ),
      loadLibrary: component.loadLibrary,
      builder: () => component.builder(),
    );
  }
}
