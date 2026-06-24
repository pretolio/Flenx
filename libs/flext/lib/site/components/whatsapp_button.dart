import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Botão flutuante de WhatsApp (canto inferior direito). Abre o wa.me com a
/// mensagem pré-preenchida. Número e mensagem são personalizáveis via [url].
class WhatsappButton extends StatelessComponent {
  const WhatsappButton({required this.url, this.label = 'Fale no WhatsApp', super.key});

  final String url;
  final String label;

  @override
  Component build(BuildContext context) {
    return a(
      [
        span(classes: 'wa-icon', [.text('💬')]),
        span(classes: 'wa-label', [.text(label)]),
      ],
      href: url,
      classes: 'whatsapp-fab',
      target: Target.blank,
      attributes: {'rel': 'noopener noreferrer', 'aria-label': label},
    );
  }
}
