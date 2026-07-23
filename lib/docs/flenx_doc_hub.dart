import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'commercial_doc.dart';

/// Central de Documentos Comerciais: lista os [docs] em cards, com filtro por
/// tipo, e links para abrir/imprimir cada um. Servida em [basePath].
class FlenxDocHub extends StatelessComponent {
  const FlenxDocHub({
    required this.docs,
    required this.basePath,
    required this.title,
    this.eyebrow = 'Central Comercial',
    this.subtitle = '',
    this.logoSrc,
    this.accent = '#F36B16',
    this.accentDark = '#D94E00',
    this.accentLight = '#FF8A31',
    this.ink = '#071C43',
    this.ink2 = '#0F2F69',
    super.key,
  });

  final List<CommercialDoc> docs;
  final String basePath;
  final String title;
  final String eyebrow;
  final String subtitle;
  final String? logoSrc;
  final String accent;
  final String accentDark;
  final String accentLight;
  final String ink;
  final String ink2;

  List<String> get _kinds {
    final seen = <String>{};
    final out = <String>[];
    for (final d in docs) {
      if (seen.add(d.kind)) out.add(d.kind);
    }
    return out;
  }

  static const _css = '''
.fxhub{max-width:1080px;margin:0 auto;padding:40px 24px 80px;
font-family:system-ui,-apple-system,"Segoe UI",Roboto,sans-serif;color:#0F1E38}
.fxhub__head{border-bottom:1px solid #E2E9F3;padding-bottom:26px;display:flex;flex-direction:column;gap:12px}
.fxhub__logo{height:52px;width:auto;border-radius:10px;box-shadow:0 6px 18px -8px rgba(7,28,67,.35);align-self:flex-start}
.fxhub__eyebrow{font-size:.72rem;font-weight:800;letter-spacing:.2em;text-transform:uppercase}
.fxhub__title{font-size:clamp(26px,3.6vw,38px);font-weight:900;letter-spacing:-.02em;margin:2px 0 0}
.fxhub__sub{color:#5B6B85;margin-top:6px;max-width:56ch}
.fxhub__filters{display:flex;flex-wrap:wrap;gap:8px;margin:26px 0 22px}
.fxhub__chip{border:1px solid #E2E9F3;background:#fff;color:#5B6B85;cursor:pointer;
font-family:inherit;font-size:.84rem;font-weight:700;padding:8px 16px;border-radius:999px;transition:.15s}
.fxhub__chip:hover{border-color:var(--fxa)}
.fxhub__chip.on{color:#fff}
.fxhub__grid{display:grid;grid-template-columns:repeat(3,1fr);gap:18px}
@media(max-width:820px){.fxhub__grid{grid-template-columns:1fr 1fr}}
@media(max-width:540px){.fxhub__grid{grid-template-columns:1fr}}
.fxhub__card{display:flex;flex-direction:column;background:#fff;border:1px solid #E2E9F3;
border-radius:16px;overflow:hidden;transition:transform .16s ease,box-shadow .16s ease,border-color .16s}
.fxhub__card:hover{transform:translateY(-3px);box-shadow:0 20px 50px -28px rgba(7,28,67,.5);border-color:#cdd6e6}
.fxhub__cardtop{height:6px}
.fxhub__cardbody{padding:22px;display:flex;flex-direction:column;flex:1}
.fxhub__kind{font-size:.68rem;font-weight:800;letter-spacing:.12em;text-transform:uppercase;
padding:4px 10px;border-radius:999px;align-self:flex-start}
.fxhub__ctitle{font-size:1.12rem;font-weight:800;color:#071C43;margin:12px 0 0;letter-spacing:-.01em}
.fxhub__desc{color:#5B6B85;font-size:.92rem;margin-top:7px;flex:1}
.fxhub__meta{color:#93a2bd;font-size:.76rem;margin-top:14px}
.fxhub__actions{display:flex;gap:8px;margin-top:16px}
.fxhub__btn{flex:1;text-align:center;padding:10px 14px;border-radius:10px;font-weight:800;
font-size:.86rem;text-decoration:none;transition:.15s}
.fxhub__foot{margin-top:40px;padding-top:22px;border-top:1px solid #E2E9F3;color:#93a2bd;font-size:.8rem}
''';

  String get _js => '''
(function(){var root=document.currentScript.closest('.fxhub')||document;
var chips=root.querySelectorAll('.fxhub__chip');var cards=root.querySelectorAll('.fxhub__card');
chips.forEach(function(c){c.addEventListener('click',function(){
var k=c.getAttribute('data-k');
chips.forEach(function(x){x.classList.toggle('on',x===c);
x.style.background=x===c?'#071C43':'#fff';x.style.borderColor=x===c?'#071C43':'#E2E9F3';});
cards.forEach(function(card){var show=k==='__all'||card.getAttribute('data-k')===k;
card.style.display=show?'flex':'none';});});});})();
''';

  Component _card(CommercialDoc d) {
    final grad = 'linear-gradient(90deg,$accentDark,$accentLight)';
    return div(classes: 'fxhub__card', attributes: {'data-k': d.kind}, [
      div(classes: 'fxhub__cardtop', styles: Styles(raw: {'background': grad}), []),
      div(classes: 'fxhub__cardbody', [
        span(
          classes: 'fxhub__kind',
          styles: Styles(raw: {'color': accentDark, 'background': _rgba(accent, .1)}),
          [Component.text(d.kind)],
        ),
        h2(classes: 'fxhub__ctitle', [Component.text(d.title)]),
        p(classes: 'fxhub__desc', [Component.text(d.description)]),
        if (d.meta != null) div(classes: 'fxhub__meta', [Component.text(d.meta!)]),
        div(classes: 'fxhub__actions', [
          a([Component.text('Abrir')],
              href: '$basePath/${d.slug}',
              classes: 'fxhub__btn',
              styles: Styles(raw: {'background': ink, 'color': '#fff'})),
          a([Component.text('Imprimir')],
              href: '$basePath/${d.slug}?print=1',
              classes: 'fxhub__btn',
              styles: Styles(raw: {'background': '#fff', 'color': ink, 'border': '1px solid #E2E9F3'})),
        ]),
      ]),
    ]);
  }

  @override
  Component build(BuildContext context) {
    return div(classes: 'fxhub', styles: Styles(raw: {'--fxa': accent}), [
      Component.element(tag: 'style', children: const [RawText(_css)]),
      div(classes: 'fxhub__head', [
        if (logoSrc != null) img(src: logoSrc!, alt: title, classes: 'fxhub__logo'),
        div([
          div(classes: 'fxhub__eyebrow', styles: Styles(raw: {'color': accent}), [Component.text(eyebrow)]),
          h1(classes: 'fxhub__title', [Component.text(title)]),
          if (subtitle.isNotEmpty) p(classes: 'fxhub__sub', [Component.text(subtitle)]),
        ]),
      ]),
      div(classes: 'fxhub__filters', [
        button(
          classes: 'fxhub__chip on',
          attributes: {'data-k': '__all'},
          styles: Styles(raw: {'background': ink, 'color': '#fff', 'border-color': ink}),
          [Component.text('Todos')],
        ),
        for (final k in _kinds)
          button(classes: 'fxhub__chip', attributes: {'data-k': k}, [Component.text(k)]),
      ]),
      div(classes: 'fxhub__grid', [for (final d in docs) _card(d)]),
      div(classes: 'fxhub__foot', [Component.text('$title · Central de Documentos Comerciais')]),
      Component.element(tag: 'script', children: [RawText(_js)]),
    ]);
  }

  static String _rgba(String hex, double a) {
    final h = hex.replaceAll('#', '');
    if (h.length != 6) return hex;
    final r = int.parse(h.substring(0, 2), radix: 16);
    final g = int.parse(h.substring(2, 4), radix: 16);
    final b = int.parse(h.substring(4, 6), radix: 16);
    return 'rgba($r,$g,$b,$a)';
  }
}
