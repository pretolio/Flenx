import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Seção da página — uma faixa com espaçamento vertical e um contêiner central
/// de largura máxima (como um bloco de tela). Estilo por parâmetros; sem CSS.
class FlextSection extends StatelessComponent {
  const FlextSection({
    required this.child,
    this.background,
    this.paddingY = 72,
    this.maxWidthPx = 1120,
    this.id,
    super.key,
  });

  final Component child;

  /// Cor/gradiente de fundo (hex ou valor CSS). Nulo = transparente.
  final String? background;
  final double paddingY;
  final double maxWidthPx;
  final String? id;

  @override
  Component build(BuildContext context) {
    return Component.element(
      tag: 'section',
      id: id,
      styles: Styles(raw: {
        'padding': '${paddingY}px 24px',
        if (background != null) 'background': background!,
      }),
      children: [
        div(
          styles: Styles(raw: {
            'max-width': '${maxWidthPx}px',
            'margin': '0 auto',
          }),
          [child],
        ),
      ],
    );
  }
}
