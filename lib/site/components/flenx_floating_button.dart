import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Canto onde o botão flutuante fica fixado.
enum FlenxCorner { bottomRight, bottomLeft }

/// Botão de ação flutuante e fixo (canto da tela) — para WhatsApp ou **qualquer
/// chat/ação** (Telegram, Messenger, chat próprio, telefone…). Só Dart.
///
/// ```dart
/// FlenxFloatingButton.whatsapp(href: 'https://wa.me/5511...')
/// FlenxFloatingButton(href: '/chat', label: 'Chat', icon: '💬', background: '#111')
/// ```
class FlenxFloatingButton extends StatelessComponent {
  const FlenxFloatingButton({
    required this.href,
    this.label = '',
    this.icon = '💬',
    this.iconImage,
    this.background = '#2563eb',
    this.textColor = '#ffffff',
    this.corner = FlenxCorner.bottomRight,
    this.newTab = true,
    this.offset = 20,
    this.pulse = false,
    this.pulseColor = 'rgba(37,99,235,.55)',
    super.key,
  });

  /// Preset WhatsApp (verde + ícone de balão).
  const FlenxFloatingButton.whatsapp({
    required this.href,
    this.label = 'Fale no WhatsApp',
    this.corner = FlenxCorner.bottomRight,
    this.newTab = true,
    this.offset = 20,
    super.key,
  }) : icon = '💬',
       iconImage = null,
       background = '#25D366',
       textColor = '#ffffff',
       pulse = false,
       pulseColor = 'rgba(37,99,235,.55)';

  /// Preset Telegram.
  const FlenxFloatingButton.telegram({
    required this.href,
    this.label = 'Telegram',
    this.corner = FlenxCorner.bottomRight,
    this.newTab = true,
    this.offset = 20,
    super.key,
  }) : icon = '✈️',
       iconImage = null,
       background = '#229ED9',
       textColor = '#ffffff',
       pulse = false,
       pulseColor = 'rgba(37,99,235,.55)';

  /// Preset Messenger.
  const FlenxFloatingButton.messenger({
    required this.href,
    this.label = 'Messenger',
    this.corner = FlenxCorner.bottomRight,
    this.newTab = true,
    this.offset = 20,
    super.key,
  }) : icon = '💬',
       iconImage = null,
       background = '#0084FF',
       textColor = '#ffffff',
       pulse = false,
       pulseColor = 'rgba(37,99,235,.55)';

  final String href;
  final String label;

  /// Ícone como emoji/texto (ignorado se [iconImage] for informado).
  final String icon;

  /// URL de uma imagem/ícone (ex.: SVG). Se nulo, usa [icon].
  final String? iconImage;
  final String background;
  final String textColor;
  final FlenxCorner corner;
  final bool newTab;
  final double offset;

  /// Animação de pulso (anel expansivo) para chamar atenção. Inclui elevação
  /// no hover. Respeita `prefers-reduced-motion`.
  final bool pulse;

  /// Cor do anel do pulso (aceita rgba para o fade ficar suave).
  final String pulseColor;

  static String _px(double v) =>
      v == v.roundToDouble() ? '${v.toInt()}px' : '${v}px';

  /// CSS injetado (uma vez; conteúdo idêntico é deduplicado pelo browser):
  /// elevação no hover, keyframes do pulso e guarda de acessibilidade.
  static const _css =
      '.flenx-fab{transition:transform .18s ease,box-shadow .18s ease}'
      '.flenx-fab:hover{transform:translateY(-3px) scale(1.04)}'
      '.flenx-fab--pulse{animation:flenxFabPulse 2.4s ease-out infinite}'
      '@keyframes flenxFabPulse{'
      '0%{box-shadow:0 10px 26px rgba(0,0,0,.28),0 0 0 0 var(--fab-pulse)}'
      '70%{box-shadow:0 10px 26px rgba(0,0,0,.28),0 0 0 16px transparent}'
      '100%{box-shadow:0 10px 26px rgba(0,0,0,.28),0 0 0 0 transparent}}'
      '@media(prefers-reduced-motion:reduce){.flenx-fab--pulse{animation:none}}';

  @override
  Component build(BuildContext context) {
    final side = corner == FlenxCorner.bottomLeft ? 'left' : 'right';
    final link = a(
      [
        if (iconImage != null)
          img(
            src: iconImage!,
            alt: '',
            styles: Styles(raw: {'height': '20px', 'width': '20px'}),
          )
        else
          span(styles: Styles(raw: {'font-size': '18px'}), [.text(icon)]),
        if (label.isNotEmpty) span([.text(label)]),
      ],
      href: href,
      target: newTab ? Target.blank : null,
      classes: pulse ? 'flenx-fab flenx-fab--pulse' : 'flenx-fab',
      attributes: {
        if (newTab) 'rel': 'noopener noreferrer',
        'aria-label': label.isNotEmpty ? label : 'Abrir',
      },
      styles: Styles(
        raw: {
          'position': 'fixed',
          side: _px(offset),
          'bottom': _px(offset),
          'z-index': '50',
          'display': 'inline-flex',
          'align-items': 'center',
          'gap': '8px',
          'background': background,
          'color': textColor,
          'padding': '12px 18px',
          'border-radius': '999px',
          'text-decoration': 'none',
          'font-weight': '700',
          'box-shadow': '0 8px 24px rgba(0,0,0,.18)',
          if (pulse) '--fab-pulse': pulseColor,
        },
      ),
    );
    return span(styles: Styles(raw: {'display': 'contents'}), [
      Component.element(tag: 'style', children: [RawText(_css)]),
      link,
    ]);
  }
}
