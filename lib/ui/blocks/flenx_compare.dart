import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../flenx_palette.dart';
import '../flenx_section.dart';

/// Linha de um [FlenxCompare]: o recurso e se cada lado o oferece.
class FlenxCompareRow {
  const FlenxCompareRow(this.label, {this.us = true, this.them = false, this.themNote});

  final String label;

  /// Nós oferecemos (coluna destacada).
  final bool us;

  /// O concorrente oferece.
  final bool them;

  /// Nota curta na célula do concorrente (ex.: "às vezes", "raro").
  final String? themNote;
}

/// Tabela comparativa "nós x eles" — quebra a objeção de preço/valor mostrando,
/// de forma escaneável, o que muda entre a sua marca e a alternativa comum.
/// Componente só-Dart (o CSS fica encapsulado aqui, sem HTML/CSS no site).
class FlenxCompare extends StatelessComponent {
  const FlenxCompare({
    required this.rows,
    required this.usLabel,
    required this.themLabel,
    this.eyebrow,
    this.title,
    this.subtitle,
    this.background,
    this.accent = FlenxPalette.primary,
    this.titleColor = FlenxPalette.ink,
    this.textColor = FlenxPalette.muted,
    this.id,
    super.key,
  });

  final List<FlenxCompareRow> rows;
  final String usLabel;
  final String themLabel;
  final String? eyebrow;
  final String? title;
  final String? subtitle;
  final String? background;
  final String accent;
  final String titleColor;
  final String textColor;
  final String? id;

  static String _check(String c) =>
      '<svg viewBox="0 0 24 24" fill="none" stroke="$c" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" width="20" height="20"><path d="M20 6 9 17l-5-5"/></svg>';
  static const _cross =
      '<svg viewBox="0 0 24 24" fill="none" stroke="#cbd5e1" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" width="18" height="18"><path d="M18 6 6 18M6 6l12 12"/></svg>';

  static const _css = '''
.fxcmp__head{max-width:60ch;margin:0 auto 30px;text-align:center}
.fxcmp__eyebrow{font-size:.72rem;font-weight:800;letter-spacing:.2em;text-transform:uppercase;margin:0}
.fxcmp__title{font-size:clamp(24px,3.4vw,36px);font-weight:800;letter-spacing:-.02em;margin:10px 0 0}
.fxcmp__sub{font-size:1.05rem;margin:12px 0 0}
.fxcmp__wrap{max-width:820px;margin:0 auto;overflow-x:auto}
.fxcmp__t{width:100%;border-collapse:separate;border-spacing:0;min-width:520px}
.fxcmp__t th,.fxcmp__t td{padding:15px 18px;text-align:left}
.fxcmp__t thead th{font-size:1rem;font-weight:800;text-transform:uppercase;letter-spacing:.03em}
.fxcmp__t th.us{color:#fff;text-align:center;border-radius:12px 12px 0 0}
.fxcmp__t th.them{color:#94a3b8;text-align:center}
.fxcmp__t tbody td{border-top:1px solid #eef2f7;font-size:.95rem}
.fxcmp__t td.c{text-align:center}
.fxcmp__t tbody tr:last-child td.us{border-radius:0 0 12px 12px}
.fxcmp__note{display:block;font-size:.72rem;color:#94a3b8;margin-top:2px}
''';

  @override
  Component build(BuildContext context) {
    final usTint = '${accent}14';
    return FlenxSection(
      id: id,
      background: background,
      maxWidthPx: 960,
      child: div([
        Component.element(tag: 'style', children: const [RawText(_css)]),
        if (eyebrow != null || title != null || subtitle != null)
          div(classes: 'fxcmp__head', [
            if (eyebrow != null)
              p(classes: 'fxcmp__eyebrow', styles: Styles(raw: {'color': accent}), [Component.text(eyebrow!)]),
            if (title != null)
              h2(classes: 'fxcmp__title', styles: Styles(raw: {'color': titleColor}), [Component.text(title!)]),
            if (subtitle != null)
              p(classes: 'fxcmp__sub', styles: Styles(raw: {'color': textColor}), [Component.text(subtitle!)]),
          ]),
        div(classes: 'fxcmp__wrap', [
          Component.element(tag: 'table', classes: 'fxcmp__t', children: [
            Component.element(tag: 'thead', children: [
              Component.element(tag: 'tr', children: [
                Component.element(tag: 'th', children: [Component.text('')]),
                Component.element(tag: 'th', classes: 'us', styles: Styles(raw: {'background': accent}), children: [Component.text(usLabel)]),
                Component.element(tag: 'th', classes: 'them', children: [Component.text(themLabel)]),
              ]),
            ]),
            Component.element(tag: 'tbody', children: [
              for (final r in rows)
                Component.element(tag: 'tr', children: [
                  Component.element(tag: 'td', styles: Styles(raw: {'color': titleColor}), children: [Component.text(r.label)]),
                  Component.element(tag: 'td', classes: 'c us', styles: Styles(raw: {'background': usTint}), children: [RawText(r.us ? _check(accent) : _cross)]),
                  Component.element(tag: 'td', classes: 'c', children: [
                    RawText(r.them ? _check(accent) : _cross),
                    if (r.themNote != null) Component.element(tag: 'span', classes: 'fxcmp__note', children: [Component.text(r.themNote!)]),
                  ]),
                ]),
            ]),
          ]),
        ]),
      ]),
    );
  }
}
