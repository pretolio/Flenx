import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Espaçamento vertical fixo — como o `SizedBox(height: X)` do Flutter.
/// Use dentro de `FlenxColumn` quando precisar de espaçamento pontual diferente
/// do `gap` uniforme da coluna.
///
/// ```dart
/// FlenxColumn(gap: 8, [
///   FlenxHeading('Título'),
///   FlenxSpacer(32),       // espaço extra antes do botão
///   FlenxButton('Ação', href: '/'),
/// ])
/// ```
class FlenxSpacer extends StatelessComponent {
  const FlenxSpacer(this.height, {super.key});

  final double height;

  @override
  Component build(BuildContext context) => div(
        styles: Styles(raw: {'height': '${height}px', 'flex-shrink': '0'}),
        [],
      );
}
