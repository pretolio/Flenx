import 'breadcrumb.dart';
import 'change_freq.dart';
import 'faq_item.dart';
import 'page_kind.dart';

/// Metadados de UMA rota — a **fonte única de verdade**. A partir dela o
/// framework deriva automaticamente: meta tags, Open Graph/Twitter, JSON-LD,
/// entrada no sitemap, item do llms.txt e conteúdo do llms-full.txt.
///
/// A mesma definição alimenta o roteamento web (jaspr_router), a navegação do
/// app (go_router) e os geradores de SEO.
class RouteMeta {
  const RouteMeta({
    required this.path,
    required this.title,
    required this.description,
    this.kind = PageKind.website,
    this.image,
    this.changeFreq,
    this.priority,
    this.lastmod,
    this.keywords = const [],
    this.noindex = false,
    this.section,
    this.summary,
    this.markdown,
    this.faqs = const [],
    this.breadcrumbs = const [],
    this.author,
    this.datePublished,
    this.alternates = const {},
  });

  /// Caminho absoluto da rota no site (ex.: `/`, `/blog/post-1`).
  final String path;

  /// Título da página (≤ ~60 chars). Vira `<title>`, `og:title`, headline.
  final String title;

  /// Descrição (≤ ~155 chars). Vira `<meta description>` e `og:description`.
  final String description;

  /// Tipo semântico — define `og:type` e o `@type` do JSON-LD.
  final PageKind kind;

  /// Imagem social absoluta ou relativa (1200×630 ideal).
  final String? image;

  /// Frequência de atualização (sitemap).
  final ChangeFreq? changeFreq;

  /// Prioridade 0.0–1.0 (sitemap).
  final double? priority;

  /// Última modificação — reusada em `lastmod`, `dateModified` e meta.
  final DateTime? lastmod;

  /// Palavras-chave / entidades nomeadas (reforço GEO).
  final List<String> keywords;

  /// Se `true`, emite `noindex` e é omitida do sitemap.
  final bool noindex;

  /// Seção para agrupar no llms.txt (ex.: 'Docs', 'Blog').
  final String? section;

  /// Resumo curto para o llms.txt (fallback: [description]).
  final String? summary;

  /// Conteúdo markdown completo da página para o llms-full.txt.
  final String? markdown;

  /// Perguntas/respostas → JSON-LD FAQPage (AEO).
  final List<FaqItem> faqs;

  /// Trilha de navegação → JSON-LD BreadcrumbList.
  final List<Breadcrumb> breadcrumbs;

  /// Autor (Article/BlogPosting).
  final String? author;

  /// Data de publicação (Article/BlogPosting).
  final DateTime? datePublished;

  /// Variantes de idioma: `locale` → URL absoluta (hreflang).
  final Map<String, String> alternates;

  /// Resumo efetivo usado em listagens/llms.
  String get effectiveSummary => summary ?? description;
}
