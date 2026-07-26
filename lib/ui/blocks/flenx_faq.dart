import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../flenx_palette.dart';
import '../../seo/models/faq_item.dart';
import '../flenx_section.dart';

/// Seção de **FAQ visível** (AEO) — perguntas/respostas em `<details>` nativo,
/// sem JS. Reusa o model [FaqItem]. Para o rich result **FAQPage**, passe os
/// MESMOS itens em `RouteMeta.faqs` (o schema é emitido no `<head>` pela lib).
class FlenxFaq extends StatelessComponent {
  const FlenxFaq({
    required this.items,
    this.eyebrow,
    this.title,
    this.subtitle,
    this.background,
    this.accent = FlenxPalette.primary,
    this.eyebrowColor,
    this.titleColor = FlenxPalette.ink,
    this.id,
    super.key,
  });

  final List<FaqItem> items;
  final String? eyebrow;
  final String? title;
  final String? subtitle;
  final String? background;
  final String accent;

  /// Cor do eyebrow. Ausente = [accent] com contraste AA no fundo real.
  final String? eyebrowColor;
  final String titleColor;
  final String? id;

  static const _css = '''
.fxfaq__head{max-width:60ch;margin:0 auto 26px;text-align:center}
.fxfaq__eyebrow{font-size:.72rem;font-weight:800;letter-spacing:.2em;text-transform:uppercase;margin:0}
.fxfaq__title{font-size:clamp(24px,3.4vw,36px);font-weight:800;letter-spacing:-.02em;margin:10px 0 0}
.fxfaq__sub{font-size:1.05rem;margin:12px 0 0;color:var(--muted,#475569)}
.fxfaq__list{max-width:760px;margin:0 auto}
.fxfaq details{border-bottom:1px solid var(--border,#E2E8F0)}
.fxfaq summary{list-style:none;cursor:pointer;padding:16px 4px;font-weight:700;font-size:1.02rem;
display:flex;justify-content:space-between;gap:12px;align-items:flex-start}
.fxfaq summary::-webkit-details-marker{display:none}
.fxfaq summary::after{content:'+';color:var(--muted,#475569);font-weight:400;font-size:20px;flex:none}
.fxfaq details[open] summary::after{content:'\\2013'}
.fxfaq__a{padding:0 4px 18px;color:var(--muted,#475569);line-height:1.6;font-size:.96rem;margin:0}
''';

  @override
  Component build(BuildContext context) {
    final eyebrowCol = FlenxPalette.contrastOnLight(
      eyebrowColor ?? accent,
      bg: background ?? '#ffffff',
    );
    return FlenxSection(
      id: id,
      background: background,
      child: div(classes: 'fxfaq', [
        Component.element(tag: 'style', children: const [RawText(_css)]),
        if (eyebrow != null || title != null || subtitle != null)
          div(classes: 'fxfaq__head', [
            if (eyebrow != null)
              p(classes: 'fxfaq__eyebrow', styles: Styles(raw: {'color': eyebrowCol}), [Component.text(eyebrow!)]),
            if (title != null)
              h2(classes: 'fxfaq__title', styles: Styles(raw: {'color': titleColor}), [Component.text(title!)]),
            if (subtitle != null) p(classes: 'fxfaq__sub', [Component.text(subtitle!)]),
          ]),
        div(classes: 'fxfaq__list', [
          for (final f in items)
            Component.element(tag: 'details', children: [
              Component.element(tag: 'summary', styles: Styles(raw: {'color': titleColor}), children: [Component.text(f.question)]),
              p(classes: 'fxfaq__a', [Component.text(f.answer)]),
            ]),
        ]),
      ]),
    );
  }
}
