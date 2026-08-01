import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Cartão de visita imprimível (frente + verso), 85×55 mm — pronto para gráfica.
/// Tudo em Dart: logo, nome, cargo, linhas de contato, tagline e cores.
class FlenxBusinessCard extends StatelessComponent {
  const FlenxBusinessCard({
    required this.logoSrc,
    required this.name,
    required this.role,
    required this.lines,
    required this.tagline,
    this.ink = '#071C43',
    this.ink2 = '#0F2F69',
    this.accentDark = '#D94E00',
    this.accent = '#F36B16',
    this.accentLight = '#FF8A31',
    super.key,
  });

  /// Logo em versão para fundo escuro (será invertida no verso).
  final String logoSrc;
  final String name;
  final String role;
  final List<String> lines;
  final String tagline;
  final String ink;
  final String ink2;
  final String accentDark;
  final String accent;
  final String accentLight;

  static const _css = '''
.fxbc-stage{display:flex;flex-wrap:wrap;gap:26px;justify-content:center;align-content:flex-start;
padding:40px 20px;background:#e9eef6;min-height:100vh;
font-family:system-ui,-apple-system,"Segoe UI",Roboto,sans-serif}
.fxbc{width:85mm;height:55mm;border-radius:3.5mm;overflow:hidden;position:relative;color:#fff;
box-shadow:0 12px 34px -10px rgba(7,28,67,.5)}
.fxbc__pad{position:absolute;inset:0;padding:6mm 7mm;display:flex;flex-direction:column;justify-content:space-between}
.fxbc__logo{height:9mm;width:auto;display:block}
.fxbc__name{font-size:4.1mm;font-weight:800;letter-spacing:.02em}
.fxbc__role{font-size:2.7mm;margin-top:.6mm;opacity:.82}
.fxbc__lines{display:flex;flex-direction:column;gap:1.1mm;font-size:2.7mm;margin-top:2.4mm}
.fxbc__center{height:100%;display:flex;flex-direction:column;align-items:center;justify-content:center;text-align:center;gap:2mm}
.fxbc__center img{height:12mm;filter:brightness(0) invert(1)}
.fxbc__tagline{font-size:3mm;font-weight:700;letter-spacing:.02em;opacity:.95}
.fxbc__label{width:100%;text-align:center;color:#5B6B85;font-size:.8rem;font-weight:700;
letter-spacing:.06em;text-transform:uppercase}
@media print{
.fxbc-stage{background:#fff;padding:0;gap:8mm}
.fxbc{box-shadow:none;break-inside:avoid;-webkit-print-color-adjust:exact;print-color-adjust:exact}
.fxbc__label{display:none}
@page{margin:12mm}
}
''';

  @override
  Component build(BuildContext context) {
    final frontBg = 'radial-gradient(120% 120% at 100% 0%, ${_rgba(accent, .5)}, transparent 55%),'
        'linear-gradient(150deg,#050B1C,$ink 60%,$ink2)';
    final backBg = 'linear-gradient(135deg,$accentDark,$accent 60%,$accentLight)';

    return div(classes: 'fxbc-stage', [
      Component.element(tag: 'style', children: const [RawText(_css)]),
      // Frente
      div(classes: 'fxbc', styles: Styles(raw: {'background': frontBg}), [
        div(classes: 'fxbc__pad', [
          img(src: logoSrc, alt: name, classes: 'fxbc__logo'),
          div([
            div(classes: 'fxbc__name', [Component.text(name)]),
            div(classes: 'fxbc__role', [Component.text(role)]),
            div(classes: 'fxbc__lines', [for (final l in lines) span([Component.text(l)])]),
          ]),
        ]),
      ]),
      // Verso
      div(classes: 'fxbc', styles: Styles(raw: {'background': backBg}), [
        div(classes: 'fxbc__pad', [
          div(classes: 'fxbc__center', [
            img(src: logoSrc, alt: name),
            div(classes: 'fxbc__tagline', [Component.text(tagline)]),
          ]),
        ]),
      ]),
      div(classes: 'fxbc__label', [Component.text('Frente & verso · 85 × 55 mm')]),
    ]);
  }

  /// #RRGGBB + alpha → rgba(). Aceita só hex de 6 dígitos.
  static String _rgba(String hex, double a) {
    final h = hex.replaceAll('#', '');
    if (h.length != 6) return hex;
    final r = int.parse(h.substring(0, 2), radix: 16);
    final g = int.parse(h.substring(2, 4), radix: 16);
    final b = int.parse(h.substring(4, 6), radix: 16);
    return 'rgba($r,$g,$b,$a)';
  }
}
