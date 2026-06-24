import 'dart:async';

import 'package:flext/embed.dart'; // viewportSize() + onViewportResize()
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_flutter_embed/jaspr_flutter_embed.dart';

// O shell é Flutter puro e só é importado na web (o servidor não importa Flutter),
// como biblioteca deferida para não bloquear a hidratação do restante do site.
@Import.onWeb('shell_demo.dart', show: [#ShellDemo])
import 'admin_embed.imports.dart' deferred as shell;

/// Embute o [ShellDemo] (app shell Flutter) como ilha interativa em 100% da
/// viewport, **acompanhando o resize** (sem F5). A view Flutter precisa de
/// constraints finitos: medimos a viewport (helpers da lib) e remontamos por
/// `key` ao redimensionar.
///
/// A chamada de [FlutterEmbedView] fica aqui (no app) de propósito — o
/// jaspr_builder escaneia o app para gerar o bootstrap do Flutter.
class AdminEmbed extends StatefulComponent {
  const AdminEmbed({super.key});

  @override
  State<AdminEmbed> createState() => _AdminEmbedState();
}

class _AdminEmbedState extends State<AdminEmbed> {
  ({double width, double height}) _vp = viewportSize();
  void Function()? _cancelResize;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _cancelResize = onViewportResize(() {
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 200), () {
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
      loadLibrary: shell.loadLibrary(),
      builder: () => shell.ShellDemo(),
    );
  }
}
