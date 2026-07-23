import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../flenx_palette.dart';
import '../flenx_section.dart';

/// Item de uma [FlenxChecklist]: título e (opcional) descrição curta.
class FlenxChecklistItem {
  const FlenxChecklistItem(this.title, [this.description]);
  final String title;
  final String? description;
}

/// Lista densa de itens com marcador — para apresentar MUITOS recursos,
/// diferenciais ou dores sem virar um grid de cards genérico. Marcador de
/// "check" (positivo) ou "×" (negativo, ex.: seção "o desafio").
class FlenxChecklist extends StatelessComponent {
  const FlenxChecklist({
    required this.items,
    this.eyebrow,
    this.title,
    this.subtitle,
    this.columns = 2,
    this.negative = false,
    this.background,
    this.accent = FlenxPalette.primary,
    this.titleColor = FlenxPalette.ink,
    this.textColor = FlenxPalette.muted,
    this.id,
    super.key,
  });

  final List<FlenxChecklistItem> items;
  final String? eyebrow;
  final String? title;
  final String? subtitle;
  final int columns;
  final bool negative;
  final String? background;
  final String accent;
  final String titleColor;
  final String textColor;
  final String? id;

  static const _css = '''
.fxck__head{max-width:60ch;margin:0 auto 30px;text-align:center}
.fxck__eyebrow{font-size:.72rem;font-weight:800;letter-spacing:.2em;text-transform:uppercase;margin:0}
.fxck__title{font-size:clamp(24px,3.4vw,36px);font-weight:800;letter-spacing:-.02em;margin:10px 0 0}
.fxck__sub{font-size:1.05rem;margin:12px 0 0}
.fxck__grid{display:grid;gap:16px 28px;grid-template-columns:repeat(2,minmax(0,1fr))}
.fxck__grid--1{grid-template-columns:1fr}
.fxck__grid--3{grid-template-columns:repeat(3,minmax(0,1fr))}
@media(max-width:720px){.fxck__grid,.fxck__grid--3{grid-template-columns:1fr}}
.fxck__item{display:flex;gap:12px;align-items:flex-start}
.fxck__mk{flex:none;width:26px;height:26px;border-radius:8px;display:flex;align-items:center;
justify-content:center;color:#fff;font-size:15px;font-weight:900;margin-top:1px}
.fxck__it{font-size:1rem;font-weight:700;line-height:1.3}
.fxck__id{font-size:.9rem;line-height:1.45;margin:2px 0 0}
''';

  @override
  Component build(BuildContext context) {
    final gridClass = 'fxck__grid${columns == 1 ? ' fxck__grid--1' : columns >= 3 ? ' fxck__grid--3' : ''}';
    return FlenxSection(
      id: id,
      background: background,
      child: div([
        Component.element(tag: 'style', children: const [RawText(_css)]),
        if (eyebrow != null || title != null || subtitle != null)
          div(classes: 'fxck__head', [
            if (eyebrow != null)
              p(classes: 'fxck__eyebrow', styles: Styles(raw: {'color': accent}), [Component.text(eyebrow!)]),
            if (title != null)
              h2(classes: 'fxck__title', styles: Styles(raw: {'color': titleColor}), [Component.text(title!)]),
            if (subtitle != null)
              p(classes: 'fxck__sub', styles: Styles(raw: {'color': textColor}), [Component.text(subtitle!)]),
          ]),
        div(
          classes: gridClass,
          [
            for (final it in items)
              div(classes: 'fxck__item', [
                div(
                  classes: 'fxck__mk',
                  styles: Styles(raw: {'background': negative ? '#94a3b8' : accent}),
                  [Component.text(negative ? '×' : '✓')],
                ),
                div([
                  div(classes: 'fxck__it', styles: Styles(raw: {'color': titleColor}), [Component.text(it.title)]),
                  if (it.description != null)
                    div(classes: 'fxck__id', styles: Styles(raw: {'color': textColor}), [Component.text(it.description!)]),
                ]),
              ]),
          ],
        ),
      ]),
    );
  }
}
