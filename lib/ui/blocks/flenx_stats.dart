import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../flenx_palette.dart';
import '../flenx_section.dart';

/// Um número de destaque do [FlenxStats]: valor grande + rótulo curto.
class FlenxStatItem {
  const FlenxStatItem(this.value, this.label);
  final String value;
  final String label;
}

/// Faixa de estatísticas / prova social (números que geram confiança). Só-Dart —
/// o CSS fica encapsulado aqui. Ideal logo abaixo do hero.
class FlenxStats extends StatelessComponent {
  const FlenxStats({
    required this.items,
    this.background,
    this.accent = FlenxPalette.primary,
    this.valueColor = '#ffffff',
    this.labelColor = '#b3c7e0',
    this.id,
    super.key,
  });

  final List<FlenxStatItem> items;
  final String? background;
  final String accent;
  final String valueColor;
  final String labelColor;
  final String? id;

  static const _css = '''
.fxst__wrap{display:grid;grid-template-columns:repeat(var(--fxst-cols,4),1fr);gap:22px}
@media(max-width:760px){.fxst__wrap{grid-template-columns:repeat(2,1fr);gap:22px 14px}}
.fxst__item{display:flex;flex-direction:column;gap:3px;border-left:3px solid var(--fxst-accent);padding-left:14px}
.fxst__v{font-size:2rem;font-weight:800;line-height:1;font-variant-numeric:tabular-nums}
.fxst__l{font-size:.9rem;line-height:1.4}
''';

  @override
  Component build(BuildContext context) {
    return FlenxSection(
      id: id,
      background: background,
      paddingY: 34,
      child: div(
        classes: 'fxst__wrap',
        styles: Styles(raw: {'--fxst-cols': '${items.length}', '--fxst-accent': accent}),
        [
          Component.element(tag: 'style', children: const [RawText(_css)]),
          for (final it in items)
            div(classes: 'fxst__item', [
              Component.element(tag: 'strong', classes: 'fxst__v', styles: Styles(raw: {'color': valueColor}), children: [Component.text(it.value)]),
              span(classes: 'fxst__l', styles: Styles(raw: {'color': labelColor}), [Component.text(it.label)]),
            ]),
        ],
      ),
    );
  }
}
