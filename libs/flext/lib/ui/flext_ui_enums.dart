/// Enums de layout/estilo (estilo Flutter) usados pelos componentes UI do Flext.
/// Quem usa só precisa do Dart — nada de HTML/CSS.

/// Alinhamento em [FlextColumn]/[FlextRow] (vira flexbox por baixo).
enum FlextAlign { start, center, end, spaceBetween, spaceAround, stretch }

extension FlextAlignCss on FlextAlign {
  String get css => switch (this) {
        FlextAlign.start => 'flex-start',
        FlextAlign.center => 'center',
        FlextAlign.end => 'flex-end',
        FlextAlign.spaceBetween => 'space-between',
        FlextAlign.spaceAround => 'space-around',
        FlextAlign.stretch => 'stretch',
      };
}

/// Alinhamento de texto.
enum FlextTextAlign { left, center, right, justify }

/// Variante visual de [FlextButton].
enum FlextButtonVariant { primary, ghost, soft }
