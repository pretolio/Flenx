import 'package:flext/flext.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'sections/site_footer.dart';
import 'site_nav.dart';

/// Página "Sobre" — conteúdo institucional real do projeto, com o mesmo
/// header, estilo e rodapé do restante do site.
class AboutPage extends StatelessComponent {
  const AboutPage({super.key});

  static const _cards = [
    ('🎯', 'A missão', 'Levar a web ao patamar de PHP, Next e Astro — só que em Dart, reaproveitando os widgets do seu app.'),
    ('⚙️', 'Como funciona', 'SSR com jaspr, ilhas de widgets Flutter reais e SEO/GEO/AEO gerados a partir das rotas.'),
    ('👥', 'Para quem', 'De iniciantes que querem um site rápido a times que já têm um app Flutter e querem web de verdade.'),
  ];

  @override
  Component build(BuildContext context) {
    return SiteLayout(
      brand: siteBrand,
      links: siteNavLinks,
      loginOptions: siteLoginOptions,
      footer: const SiteFooter(),
      child: div([
        section(classes: 'section', [
          div(classes: 'container', [
            p(classes: 'eyebrow', [.text('Sobre o projeto')]),
            h2(classes: 'title', [.text('Flutter para a web, do jeito certo')]),
            p(classes: 'lead', [
              .text('O Flext é um framework web em Dart, no espírito do Next.js: '
                  'renderiza HTML no servidor (SSR) para SEO real, mas mantém os '
                  'widgets Flutter do seu app como ilhas interativas.'),
            ]),
            p(classes: 'lead', styles: Styles(margin: Margin.only(top: 14.px)), [
              .text('A ideia é simples: escreva uma vez, rode no app e na web — '
                  'com sitemap, robots e llms.txt automáticos, sem configuração.'),
            ]),
          ]),
        ]),
        section(classes: 'section',
            styles: Styles(backgroundColor: const Color('#f8fafc')), [
          div(classes: 'container', [
            p(classes: 'eyebrow center', [.text('Por que existe')]),
            h2(classes: 'title center', [.text('A web merece a DX do Flutter')]),
            div(classes: 'grid', styles: Styles(margin: Margin.only(top: 40.px)), [
              for (final c in _cards)
                div(classes: 'card', [
                  div(classes: 'ico', [.text(c.$1)]),
                  h3([.text(c.$2)]),
                  p([.text(c.$3)]),
                ]),
            ]),
          ]),
        ]),
        section(classes: 'section', [
          div(classes: 'container', [
            p(classes: 'eyebrow center', [.text('Demonstração')]),
            h2(classes: 'title center', [.text('Embute qualquer site ou vídeo')]),
            p(classes: 'lead center', [
              .text('É só passar a URL — o Flext carrega num iframe responsivo.'),
            ]),
            div(styles: Styles(raw: {'max-width': '760px', 'margin': '32px auto 0'}), [
              const IframeEmbed(
                'https://www.youtube.com/embed/dQw4w9WgXcQ',
                title: 'Vídeo de exemplo',
                ratio: '16 / 9',
              ),
            ]),
          ]),
        ]),
        section(classes: 'section', [
          div(classes: 'container', [
            div(classes: 'cta', [
              h2([.text('Quer fazer parte?')]),
              p([.text('O Flext é open source (MIT). Fale com a gente e participe.')]),
              a([.text('Fale com a gente')], href: '/#contato', classes: 'btn btn-ghost'),
            ]),
          ]),
        ]),
      ]),
    );
  }
}
