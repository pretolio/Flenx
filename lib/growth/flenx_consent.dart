import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Banner de consentimento (LGPD/cookies). Genérico e themeável: cores via
/// tokens (`--surface/--ink/--border/--primary`), textos configuráveis. Fica
/// escondido para quem já decidiu; ao aceitar/recusar chama
/// `flenx.grantConsent()`/`flenx.denyConsent()` (do [FlenxTracking]).
///
/// Renderize como um dos [floatingButtons] do `FlenxApp` (aparece em todas as
/// páginas). Sem ele, o rastreamento assume consentimento implícito.
class FlenxConsent extends StatelessComponent {
  const FlenxConsent({
    this.message =
        'Usamos cookies e pixels para medir audiência e personalizar anúncios. '
        'Você pode aceitar ou recusar.',
    this.acceptLabel = 'Aceitar',
    this.declineLabel = 'Recusar',
    this.policyHref,
    this.policyLabel = 'Política de Privacidade',
    super.key,
  });

  final String message;
  final String acceptLabel;
  final String declineLabel;

  /// Link para a Política de Privacidade (exibido no fim da mensagem).
  final String? policyHref;
  final String policyLabel;

  static const _css = '''
.fxconsent{display:none;position:fixed;left:16px;right:16px;bottom:16px;z-index:9999;
max-width:760px;margin:0 auto;background:var(--surface,#F8FAFC);color:var(--ink,#0F172A);
border:1px solid var(--border,#E2E8F0);border-radius:14px;padding:16px 18px;
box-shadow:0 20px 50px -20px rgba(2,6,23,.5);
display:none;gap:14px;align-items:center;flex-wrap:wrap;font-size:.9rem;line-height:1.5}
.fxconsent__msg{flex:1;min-width:240px;margin:0}
.fxconsent__msg a{color:var(--primary,#01589B);font-weight:700}
.fxconsent__actions{display:flex;gap:10px;flex-wrap:wrap}
.fxconsent__btn{border:0;border-radius:9999px;padding:10px 20px;font-weight:700;
font-size:.88rem;cursor:pointer;font-family:inherit}
.fxconsent__btn--ok{background:var(--primary,#01589B);color:#fff}
.fxconsent__btn--no{background:transparent;color:var(--ink,#0F172A);
border:1px solid var(--border,#E2E8F0)}
@media(max-width:520px){.fxconsent__actions{width:100%}.fxconsent__btn{flex:1}}
''';

  static const _js = '''
(function(){var el=document.getElementById('fx-consent');if(!el)return;
window.fxConsentSet=function(v){el.style.display='none';if(window.flenx){v?flenx.grantConsent():flenx.denyConsent()}};
try{if(!localStorage.getItem('flenx_consent'))el.style.display='flex'}catch(e){el.style.display='flex'}})();
''';

  @override
  Component build(BuildContext context) {
    return div([
      Component.element(tag: 'style', children: const [RawText(_css)]),
      div(id: 'fx-consent', classes: 'fxconsent', [
        p(classes: 'fxconsent__msg', [
          Component.text('$message '),
          if (policyHref != null)
            a(href: policyHref!, [Component.text(policyLabel)]),
        ]),
        div(classes: 'fxconsent__actions', [
          button(
            classes: 'fxconsent__btn fxconsent__btn--no',
            attributes: {'type': 'button', 'onclick': 'fxConsentSet(false)'},
            [Component.text(declineLabel)],
          ),
          button(
            classes: 'fxconsent__btn fxconsent__btn--ok',
            attributes: {'type': 'button', 'onclick': 'fxConsentSet(true)'},
            [Component.text(acceptLabel)],
          ),
        ]),
      ]),
      Component.element(tag: 'script', children: const [RawText(_js)]),
    ]);
  }
}
