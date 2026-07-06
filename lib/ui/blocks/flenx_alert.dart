import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../flenx_column.dart';
import '../flenx_text.dart';
import 'flenx_alert_variant.dart';

export 'flenx_alert_variant.dart';

/// Caixa de alerta com ícone, título opcional e mensagem. Use para validações,
/// avisos e confirmações — sem escrever HTML/CSS.
///
/// ```dart
/// FlenxAlert('Pedido enviado!', variant: FlenxAlertVariant.success)
/// FlenxAlert('Campos obrigatórios.', title: 'Atenção', variant: FlenxAlertVariant.warning)
/// ```
class FlenxAlert extends StatelessComponent {
  const FlenxAlert(
    this.message, {
    this.title,
    this.variant = FlenxAlertVariant.info,
    super.key,
  });

  final String message;
  final String? title;
  final FlenxAlertVariant variant;

  ({String icon, String bg, String textColor, String border}) get _config =>
      switch (variant) {
        FlenxAlertVariant.info => (
          icon: 'ℹ️',
          bg: '#EFF6FF',
          textColor: '#1D4ED8',
          border: '#BFDBFE',
        ),
        FlenxAlertVariant.success => (
          icon: '✅',
          bg: '#F0FDF4',
          textColor: '#15803D',
          border: '#BBF7D0',
        ),
        FlenxAlertVariant.warning => (
          icon: '⚠️',
          bg: '#FFFBEB',
          textColor: '#92400E',
          border: '#FDE68A',
        ),
        FlenxAlertVariant.error => (
          icon: '❌',
          bg: '#FEF2F2',
          textColor: '#B91C1C',
          border: '#FECACA',
        ),
      };

  @override
  Component build(BuildContext context) {
    final c = _config;
    return Component.element(
      tag: 'div',
      styles: Styles(
        raw: {
          'display': 'flex',
          'gap': '12px',
          'align-items': 'flex-start',
          'background': c.bg,
          'border': '1px solid ${c.border}',
          'border-left': '4px solid ${c.textColor}',
          'border-radius': '8px',
          'padding': '14px 16px',
        },
      ),
      children: [
        FlenxText(c.icon, size: 18),
        FlenxColumn(gap: 4, [
          if (title != null) FlenxText(title!, weight: 700, color: c.textColor),
          FlenxText(message, color: c.textColor, size: 14),
        ]),
      ],
    );
  }
}
