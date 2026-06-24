import 'render_mode.dart';

/// Marca um widget como **isomórfico**: o transpilador de build gera, num
/// arquivo `part` (`.flext.dart`), a versão HTML/jaspr equivalente para SSR.
///
/// O mesmo widget continua compilando como widget Flutter normal para o app
/// mobile e para ilhas interativas — esta anotação só habilita a geração da
/// representação HTML server-side.
class Ssr {
  /// Estratégia de renderização aplicada ao widget. Padrão: [RenderMode.server].
  final RenderMode mode;

  const Ssr({this.mode = RenderMode.server});
}

/// Atalho conveniente: `@ssr` em vez de `@Ssr()`.
const ssr = Ssr();
