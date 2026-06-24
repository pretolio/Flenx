/// Anotações públicas do framework Flext.
///
/// Importadas tanto pelo código do usuário quanto pelo code-gen (que as lê via
/// analyzer em build-time — não há reflection em runtime na web).
library flext_annotations;

export 'src/render_mode.dart';
export 'src/ssr.dart';
export 'src/flext_page.dart';
export 'src/api.dart';
export 'src/persist.dart';
export 'src/island.dart';
