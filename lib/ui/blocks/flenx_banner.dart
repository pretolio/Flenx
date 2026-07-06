import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../flenx_palette.dart';
import '../flenx_button.dart';
import '../flenx_row.dart';
import '../flenx_text.dart';
import '../flenx_ui_enums.dart';

/// Barra de anúncio no topo da página — promoções, avisos de manutenção,
/// novidades. Exibe [message] e um [action] opcional. Sem HTML/CSS.
///
/// ```dart
/// FlenxBanner(message: '🎉 Promoção: 10% off em todas as entregas hoje!')
/// FlenxBanner(
///   message: 'Novo serviço disponível: Entregas expressas em 2h.',
///   action: FlenxButton('Saiba mais', href: '/express'),
///   background: '#0F766E',
/// )
/// ```
class FlenxBanner extends StatelessComponent {
  const FlenxBanner({
    required this.message,
    this.action,
    this.background = FlenxPalette.primary,
    this.textColor = '#ffffff',
    super.key,
  });

  final String message;
  final FlenxButton? action;
  final String background;
  final String textColor;

  @override
  Component build(BuildContext context) {
    return Component.element(
      tag: 'div',
      styles: Styles(
        raw: {
          'background': background,
          'color': textColor,
          'padding': '10px 24px',
          'text-align': 'center',
        },
      ),
      children: [
        FlenxRow(
          gap: 16,
          wrap: true,
          main: FlenxAlign.center,
          cross: FlenxAlign.center,
          [
            FlenxText(message, color: textColor, size: 14, weight: 600),
            if (action != null) action!,
          ],
        ),
      ],
    );
  }
}
