import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../flenx_palette.dart';

/// Campo de um [FlenxLeadForm].
class FlenxFormField {
  const FlenxFormField(
    this.name,
    this.label, {
    this.type = 'text',
    this.hint = '',
    this.required = false,
    this.half = false,
    this.options = const [],
  });

  final String name;
  final String label;

  /// text | email | tel | textarea | select
  final String type;
  final String hint;
  final bool required;

  /// Ocupa meia largura (dois campos `half` seguidos ficam lado a lado).
  final bool half;

  /// Opções do `select`.
  final List<String> options;
}

/// Formulário de captura de leads configurável, só-Dart (o CSS/JS fica
/// encapsulado aqui — nada de HTML no site). Envia por **mailto** compondo o
/// corpo com todos os campos (sem back-end). Renderize dentro de um hero/section.
class FlenxLeadForm extends StatelessComponent {
  const FlenxLeadForm({
    required this.fields,
    required this.mailtoTo,
    this.title,
    this.subtitle,
    this.badge,
    this.submitLabel = 'Enviar',
    this.subjectPrefix = 'Contato pelo site',
    this.accent = FlenxPalette.primary,
    this.accentDark = FlenxPalette.ink,
    this.noteEmail,
    this.formId = 'fx-lead',
    this.postUrl,
    this.successMessage = 'Recebemos seu contato! Em breve retornamos.',
    this.consentText,
    this.consentHref,
    this.consentLinkLabel = 'Política de Privacidade',
    this.requiredMessage = 'Preencha os campos obrigatórios (*).',
    this.consentRequiredMessage = 'É preciso aceitar para continuar.',
    super.key,
  });

  final List<FlenxFormField> fields;
  final String mailtoTo;
  final String? title;
  final String? subtitle;
  final String? badge;
  final String submitLabel;
  final String subjectPrefix;
  final String accent;
  final String accentDark;
  final String? noteEmail;
  final String formId;

  /// Se informado, POST JSON deste endpoint (Brevo/HubSpot/webhook); falha → mailto.
  final String? postUrl;
  final String successMessage;
  /// Checkbox de consentimento (LGPD). Nulo = sem checkbox; presente = exige
  /// aceite. [consentHref] adiciona o link da política.
  final String? consentText;
  final String? consentHref;
  final String consentLinkLabel;

  /// Alertas (JS) configuráveis (i18n).
  final String requiredMessage;
  final String consentRequiredMessage;

  static const _css = '''
.fxlf{background:#fff;border-radius:20px;padding:28px 26px;box-shadow:0 34px 80px rgba(0,0,0,.32);font-family:inherit;border-top:5px solid var(--fxlf-accent)}
.fxlf__badge{display:inline-block;font-size:.76rem;font-weight:700;color:#0e7a4f;background:#e7f7ef;border-radius:999px;padding:5px 12px;margin:0 0 10px}
.fxlf__title{font-weight:800;color:var(--fxlf-ink);font-size:1.5rem;margin:0 0 4px;line-height:1.15}
.fxlf__sub{color:#485a74;font-size:.92rem;line-height:1.5;margin:0 0 14px}
.fxlf label{display:block;font-size:.78rem;font-weight:700;color:#33425a;margin:11px 0 5px}
.fxlf input,.fxlf select,.fxlf textarea{width:100%;box-sizing:border-box;border:1.5px solid #cdd9ea;border-radius:11px;padding:12px 13px;font:inherit;font-size:.96rem;color:var(--fxlf-ink);background:#fff;outline:none}
.fxlf input::placeholder,.fxlf textarea::placeholder{color:#8fa0b8}
.fxlf input:focus,.fxlf select:focus,.fxlf textarea:focus{border-color:var(--fxlf-accent);box-shadow:0 0 0 3px color-mix(in srgb, var(--fxlf-accent) 22%, transparent)}
.fxlf__row{display:grid;grid-template-columns:1fr 1fr;gap:12px}
@media(max-width:520px){.fxlf__row{grid-template-columns:1fr}}
.fxlf__btn{margin-top:20px;width:100%;border:0;border-radius:999px;padding:15px 22px;background:linear-gradient(135deg,var(--fxlf-accent),var(--fxlf-accent-dark));color:#fff;font-weight:800;font-size:1.06rem;cursor:pointer;box-shadow:0 12px 26px rgba(14,34,64,.28);transition:transform .15s ease,box-shadow .15s ease}
.fxlf__btn:hover{transform:translateY(-2px);box-shadow:0 16px 32px rgba(14,34,64,.36)}
.fxlf__note{margin:12px 0 0;font-size:.82rem;color:#61728c;text-align:center}
.fxlf__note a{color:var(--fxlf-accent);text-decoration:none;font-weight:700}
.fxlf__consent{display:flex;gap:8px;align-items:flex-start;margin:14px 0 0;font-size:.8rem;color:#485a74;font-weight:500}
.fxlf__consent input{width:auto;margin-top:2px}
.fxlf__consent a{color:var(--fxlf-accent);font-weight:700;text-decoration:none}
''';

  Component _control(FlenxFormField f) {
    final req = {if (f.required) 'required': ''};
    if (f.type == 'select') {
      return Component.element(
        tag: 'select',
        attributes: {'name': f.name, 'id': '${formId}-${f.name}'},
        children: [for (final o in f.options) Component.element(tag: 'option', children: [Component.text(o)])],
      );
    }
    if (f.type == 'textarea') {
      return Component.element(tag: 'textarea', attributes: {'name': f.name, 'id': '${formId}-${f.name}', 'rows': '2', 'placeholder': f.hint, ...req});
    }
    return Component.element(tag: 'input', attributes: {'name': f.name, 'id': '${formId}-${f.name}', 'type': f.type, 'placeholder': f.hint, ...req});
  }

  Component _labeled(FlenxFormField f) => div([
        Component.element(tag: 'label', attributes: {'for': '${formId}-${f.name}'}, children: [Component.text(f.label + (f.required ? ' *' : ''))]),
        _control(f),
      ]);

  String get _script {
    final names = fields.map((f) => "'${f.name}'").join(',');
    final labels = {for (final f in fields) f.name: f.label};
    final labelMap = labels.entries.map((e) => "'${e.key}':'${e.value.replaceAll("'", r"\'")}'").join(',');
    final reqNames = fields.where((f) => f.required).map((f) => "'${f.name}'").join(',');
    final consentCheck = consentText == null
        ? ''
        : "var cc=document.getElementById('$formId-consent');if(cc&&!cc.checked){alert('${consentRequiredMessage.replaceAll("'", r"\'")}');return;}";
    final mailto =
        "window.location.href='mailto:$mailtoTo?subject='+encodeURIComponent(subj)+'&body='+encodeURIComponent(body);";
    final send = postUrl == null
        ? mailto
        : "var data={};for(var k=0;k<FN.length;k++){data[FN[k]]=v(FN[k]);}"
            "fetch('$postUrl',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(data)})"
            ".then(function(r){if(!r.ok)throw 0;f.reset();alert('${successMessage.replaceAll("'", r"\'")}');})"
            ".catch(function(){$mailto});";
    return '''
(function(){
  var f=document.getElementById('$formId'); if(!f) return;
  var FN=[$names],LB={$labelMap},RQ=[$reqNames];
  function v(n){var el=document.getElementById('$formId-'+n);return el?el.value.trim():'';}
  f.addEventListener('submit',function(e){
    e.preventDefault();
    for(var i=0;i<RQ.length;i++){if(!v(RQ[i])){alert('${requiredMessage.replaceAll("'", r"\'")}');return;}}
    $consentCheck
    if(window.flenx)flenx.track('Lead',{});
    var body='';for(var j=0;j<FN.length;j++){var val=v(FN[j]);if(val)body+=LB[FN[j]]+': '+val+'\\n';}
    var subj='$subjectPrefix';var inst=v('inst')||v('instituicao');if(inst)subj+=' — '+inst;
    $send
  });
})();''';
  }

  @override
  Component build(BuildContext context) {
    // agrupa campos: dois `half` seguidos viram uma linha de 2 colunas.
    final rows = <Component>[];
    for (var i = 0; i < fields.length; i++) {
      final f = fields[i];
      if (f.half && i + 1 < fields.length && fields[i + 1].half) {
        rows.add(div(classes: 'fxlf__row', [_labeled(f), _labeled(fields[i + 1])]));
        i++;
      } else {
        rows.add(_labeled(f));
      }
    }
    return Component.element(
      tag: 'form',
      id: formId,
      classes: 'fxlf',
      styles: Styles(raw: {'--fxlf-accent': accent, '--fxlf-accent-dark': accentDark, '--fxlf-ink': FlenxPalette.ink}),
      children: [
        Component.element(tag: 'style', children: const [RawText(_css)]),
        if (badge != null) p(classes: 'fxlf__badge', [Component.text(badge!)]),
        if (title != null) Component.element(tag: 'h3', classes: 'fxlf__title', children: [Component.text(title!)]),
        if (subtitle != null) p(classes: 'fxlf__sub', [Component.text(subtitle!)]),
        ...rows,
        if (consentText != null)
          Component.element(tag: 'label', classes: 'fxlf__consent', attributes: {'for': '$formId-consent'}, children: [
            Component.element(tag: 'input', attributes: {'type': 'checkbox', 'id': '$formId-consent', 'name': 'consent'}),
            span([
              Component.text('$consentText '),
              if (consentHref != null)
                Component.element(tag: 'a', attributes: {'href': consentHref!, 'target': '_blank', 'rel': 'noopener'}, children: [Component.text(consentLinkLabel)]),
            ]),
          ]),
        Component.element(tag: 'button', classes: 'fxlf__btn', attributes: const {'type': 'submit'}, children: [Component.text(submitLabel)]),
        if (noteEmail != null)
          p(classes: 'fxlf__note', [
            Component.text('Ou escreva para '),
            Component.element(tag: 'a', attributes: {'href': 'mailto:$noteEmail'}, children: [Component.text(noteEmail!)]),
          ]),
        Component.element(tag: 'script', children: [RawText(_script)]),
      ],
    );
  }
}
