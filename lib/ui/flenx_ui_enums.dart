/// Enums de layout/estilo (estilo Flutter) usados pelos componentes UI do Flenx.
/// Quem usa só precisa do Dart — nada de HTML/CSS.
library;

/// Alinhamento em [FlenxColumn]/[FlenxRow] (vira flexbox por baixo).
enum FlenxAlign { start, center, end, spaceBetween, spaceAround, stretch }

extension FlenxAlignCss on FlenxAlign {
  String get css => switch (this) {
    FlenxAlign.start => 'flex-start',
    FlenxAlign.center => 'center',
    FlenxAlign.end => 'flex-end',
    FlenxAlign.spaceBetween => 'space-between',
    FlenxAlign.spaceAround => 'space-around',
    FlenxAlign.stretch => 'stretch',
  };
}

/// Alinhamento de texto.
enum FlenxTextAlign { left, center, right, justify }

/// Variante visual de [FlenxButton].
enum FlenxButtonVariant { primary, ghost, soft }
