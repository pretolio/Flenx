import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Hero da landing: headline, subtítulo, CTAs e um card de código ilustrativo.
class HeroSection extends StatelessComponent {
  const HeroSection({super.key});

  static const _code = '<span class="k">@FlextPage</span>(<span class="s">\'/\'</span>)\n'
      '<span class="k">@Ssr</span>\n'
      '<span class="k">class</span> HomePage <span class="k">extends</span> FlextWidget {\n'
      '  <span class="c">// SSR + SEO + sitemap: tudo automático</span>\n'
      '  Widget build(context) => Hero();\n'
      '}';

  @override
  Component build(BuildContext context) {
    return section(classes: 'hero', [
      div(classes: 'container', [
        div(classes: 'hero-grid', [
          div([
            p(classes: 'eyebrow', styles: Styles(color: const Color('#7dd3fc')), [
              .text('Framework web em Dart'),
            ]),
            h1([.text('Flutter na web como nunca antes')]),
            p([
              .text('SSR real, widgets Flutter de verdade e SEO/GEO/AEO '
                  'automáticos — tudo em Dart, com a DX de um framework moderno.'),
            ]),
            div(classes: 'hero-actions', [
              a([.text('Começar agora')], href: '#contato', classes: 'btn btn-primary'),
              a([.text('Ver no GitHub')],
                  href: 'https://github.com/flext',
                  classes: 'btn btn-ghost',
                  target: Target.blank),
            ]),
          ]),
          div(classes: 'code-card', [
            div(classes: 'bar', [
              Component.element(tag: 'i', attributes: {'class': 'dot-r'}),
              Component.element(tag: 'i', attributes: {'class': 'dot-y'}),
              Component.element(tag: 'i', attributes: {'class': 'dot-g'}),
            ]),
            Component.element(tag: 'pre', children: [RawText(_code)]),
          ]),
        ]),
      ]),
    ]);
  }
}
