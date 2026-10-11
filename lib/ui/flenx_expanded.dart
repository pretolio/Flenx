import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Ocupa o espaço que sobrar dentro de um `FlenxColumn` — como o `Spacer`/
/// `Expanded` do Flutter. Use com `FlenxColumn(fillHeight: true)` para fixar o
/// que vem depois (ex.: um botão) no fim do cartão.
class FlenxExpanded extends StatelessComponent {
  const FlenxExpanded({super.key});

  @override
  Component build(BuildContext context) =>
      div(styles: Styles(raw: {'flex': '1 1 auto'}), []);
}
