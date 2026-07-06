import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Botão flutuante de WhatsApp (canto inferior direito). Abre o wa.me com a
/// mensagem pré-preenchida. Estilizado inline (sem classes CSS).
class WhatsappButton extends StatelessComponent {
  const WhatsappButton({
    required this.url,
    this.label = 'Fale no WhatsApp',
    super.key,
  });

  final String url;
  final String label;

  @override
  Component build(BuildContext context) {
    return a(
      [
        span(styles: Styles(raw: {'font-size': '18px'}), [.text('💬')]),
        span([.text(label)]),
      ],
      href: url,
      target: Target.blank,
      attributes: {'rel': 'noopener noreferrer', 'aria-label': label},
      styles: Styles(
        raw: {
          'position': 'fixed',
          'right': '20px',
          'bottom': '20px',
          'z-index': '50',
          'display': 'inline-flex',
          'align-items': 'center',
          'gap': '8px',
          'background': '#25D366',
          'color': '#ffffff',
          'padding': '12px 18px',
          'border-radius': '999px',
          'text-decoration': 'none',
          'font-weight': '700',
          'box-shadow': '0 8px 24px rgba(0,0,0,.18)',
        },
      ),
    );
  }
}
