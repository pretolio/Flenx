/// Modelos declarativos para gerar um documento PDF comercial (A4) — você
/// descreve as páginas em Dart e o [FlenxPdf] renderiza. Reutilizável entre
/// sites: cada proposta é só uma lista de páginas.

/// Cor de fundo de uma página.
enum FlenxPdfTone { white, light, ink }

/// Identidade visual do documento.
class FlenxPdfBrand {
  const FlenxPdfBrand({
    required this.primary,
    required this.primaryDark,
    required this.primaryLight,
    required this.ink,
    required this.ink2,
    this.light = '#F5F8FD',
    this.logoDarkBgPath,
    this.logoLightBgPath,
    this.coverLogoPath,
    this.footerText,
    this.footerSite,
  });

  /// Cores em hex (#RRGGBB).
  final String primary;
  final String primaryDark;
  final String primaryLight;
  final String ink;
  final String ink2;
  final String light;

  /// Caminho do arquivo do logo para fundo escuro (usado no contato; e na capa
  /// se [coverLogoPath] for nulo).
  final String? logoDarkBgPath;

  /// Logo específico da CAPA (se nulo, usa [logoDarkBgPath]).
  final String? coverLogoPath;

  /// Caminho do logo para fundo claro/branco — usado no cabeçalho tipo
  /// "papel timbrado" de cada página de conteúdo (ver [FlenxPdf._sectionPage]).
  final String? logoLightBgPath;

  /// Rodapé de cada página: texto à esquerda (ex.: "EMPRESA · PROPOSTA
  /// COMERCIAL") e site à direita (ex.: "empresa.com.br"). Se nulos, o rodapé
  /// mostra só a numeração de página.
  final String? footerText;
  final String? footerSite;
}

/// Item de lista (título + descrição opcional).
class FlenxPdfItem {
  const FlenxPdfItem(this.title, [this.description]);
  final String title;
  final String? description;
}

/// Destaque numérico/curto (valor + rótulo).
class FlenxPdfStat {
  const FlenxPdfStat(this.value, this.label);
  final String value;
  final String label;
}

/// Uma página do documento.
sealed class FlenxPdfPage {
  const FlenxPdfPage();
}

/// Estilo da capa.
/// - [fullBleed]: foto cobrindo a página + faixa sólida (ink) com texto na base.
/// - [editorial]: foto no topo com varredura curva branca + logo e texto
///   centralizados no branco embaixo (padrão institucional "folheto").
enum FlenxPdfCoverStyle { fullBleed, editorial }

/// Capa: imagem de fundo cobrindo a página + gradiente + texto na base.
class FlenxPdfCover extends FlenxPdfPage {
  const FlenxPdfCover({
    required this.imagePath,
    this.eyebrow,
    required this.title,
    this.subtitle,
    this.style = FlenxPdfCoverStyle.fullBleed,
  });
  final String imagePath;
  final String? eyebrow;
  final String title;
  final String? subtitle;
  final FlenxPdfCoverStyle style;
}

/// Lista de itens com marcador (✓ ou ×), 1–2 colunas.
class FlenxPdfChecklist extends FlenxPdfPage {
  const FlenxPdfChecklist({
    this.eyebrow,
    required this.title,
    this.subtitle,
    required this.items,
    this.columns = 2,
    this.negative = false,
    this.tone = FlenxPdfTone.white,
    this.highlight,
    this.trend,
  });
  final String? eyebrow;
  final String title;
  final String? subtitle;
  final List<FlenxPdfItem> items;
  final int columns;
  final bool negative;
  final FlenxPdfTone tone;

  /// Frase de fechamento em destaque, num card abaixo da lista (opcional).
  final String? highlight;

  /// Card de estatística + mini-gráfico de tendência (queda), abaixo da
  /// lista — alternativa ao [highlight] quando o ponto vale um gráfico.
  final FlenxPdfTrend? trend;
}

/// Um ponto do mini-gráfico de [FlenxPdfTrend] (rótulo do eixo + valor
/// ilustrativo, não é dado de mercado — é só pra desenhar a tendência).
class FlenxPdfTrendPoint {
  const FlenxPdfTrendPoint(this.label, this.value);
  final String label;
  final double value;
}

/// Card de estatística em destaque + mini-gráfico de linha (tendência) —
/// usado pra ilustrar queda/perda ao lado de uma lista de dores.
class FlenxPdfTrend {
  const FlenxPdfTrend({required this.stat, required this.statLabel, required this.points});
  final String stat;
  final String statLabel;
  final List<FlenxPdfTrendPoint> points;
}

/// Texto institucional: parágrafos + destaques (stats) opcionais.
class FlenxPdfText extends FlenxPdfPage {
  const FlenxPdfText({
    this.eyebrow,
    required this.title,
    this.paragraphs = const [],
    this.stats = const [],
    this.tone = FlenxPdfTone.white,
    this.imagePath,
  });
  final String? eyebrow;
  final String title;
  final List<String> paragraphs;
  final List<FlenxPdfStat> stats;
  final FlenxPdfTone tone;

  /// Foto opcional abaixo do texto/estatísticas — cresce pra preencher o
  /// resto da folha, igual à imagem do [FlenxPdfSpotlight].
  final String? imagePath;
}

/// Spotlight: texto + bullets + imagem (screenshot) embaixo.
class FlenxPdfSpotlight extends FlenxPdfPage {
  const FlenxPdfSpotlight({
    this.eyebrow,
    required this.title,
    this.description,
    this.bullets = const [],
    required this.imagePath,
    this.tone = FlenxPdfTone.white,
  });
  final String? eyebrow;
  final String title;
  final String? description;
  final List<String> bullets;
  final String imagePath;
  final FlenxPdfTone tone;
}

/// Passos numerados.
class FlenxPdfSteps extends FlenxPdfPage {
  const FlenxPdfSteps({
    this.eyebrow,
    required this.title,
    required this.steps,
    this.tone = FlenxPdfTone.white,
    this.highlight,
    this.timeline = false,
  });
  final String? eyebrow;
  final String title;
  final List<FlenxPdfItem> steps;
  final FlenxPdfTone tone;

  /// Frase de fechamento em destaque, num card abaixo dos passos (opcional).
  final String? highlight;

  /// `true`: uma coluna, círculos maiores ligados por uma linha vertical
  /// (visual de "jornada") — usa bem mais altura, bom quando os passos são
  /// a única lista da página. `false` (default): grade 2×2 compacta, boa
  /// quando a página já tem outro conteúdo.
  final bool timeline;
}

/// Tabela genérica de dados (preços, prazos, faixas etc.) — cabeçalho +
/// linhas listradas. [columnFlex] controla a largura relativa de cada
/// coluna (default: todas iguais); use um valor maior na 1ª coluna quando
/// ela tiver texto mais longo (nome de região, por exemplo).
class FlenxPdfTable extends FlenxPdfPage {
  const FlenxPdfTable({
    this.eyebrow,
    required this.title,
    this.subtitle,
    required this.columns,
    required this.rows,
    this.columnFlex,
    this.note,
    this.tone = FlenxPdfTone.white,
  });
  final String? eyebrow;
  final String title;
  final String? subtitle;
  final List<String> columns;
  final List<List<String>> rows;
  final List<int>? columnFlex;

  /// Nota de rodapé abaixo da tabela (ex.: "+ R$ 3,00 por envio via Correios").
  final String? note;
  final FlenxPdfTone tone;
}

/// Uma linha do comparativo: recurso + se a Alstop e a alternativa atendem.
class FlenxPdfCompareRow {
  const FlenxPdfCompareRow(this.label, {this.ours = true, this.theirs = false, this.theirsNote});
  final String label;
  final bool ours;
  final bool theirs;
  final String? theirsNote;
}

/// Tabela comparativa (Alstop × alternativa) — 2 colunas de check/×.
class FlenxPdfCompare extends FlenxPdfPage {
  const FlenxPdfCompare({
    this.eyebrow,
    required this.title,
    this.subtitle,
    required this.ourLabel,
    required this.theirLabel,
    required this.rows,
    this.tone = FlenxPdfTone.white,
  });
  final String? eyebrow;
  final String title;
  final String? subtitle;
  final String ourLabel;
  final String theirLabel;
  final List<FlenxPdfCompareRow> rows;
  final FlenxPdfTone tone;
}

/// Duas ou mais seções curtas empilhadas numa única folha (mesmo tom de
/// fundo) — para juntar conteúdos que sozinhos não preenchem uma página A4.
/// Aceita blocos de texto, checklist, passos e comparativo (não capa,
/// spotlight nem contato/fechamento).
class FlenxPdfCombo extends FlenxPdfPage {
  const FlenxPdfCombo({required this.blocks, this.tone = FlenxPdfTone.white});
  final List<FlenxPdfPage> blocks;
  final FlenxPdfTone tone;
}

/// Fechamento com logo + dados de contato.
class FlenxPdfContact extends FlenxPdfPage {
  const FlenxPdfContact({required this.title, this.subtitle, required this.lines, this.tone = FlenxPdfTone.ink});
  final String title;
  final String? subtitle;
  final List<String> lines;
  final FlenxPdfTone tone;
}

/// Documento completo: marca + páginas.
class FlenxPdfDoc {
  const FlenxPdfDoc({required this.brand, required this.pages});
  final FlenxPdfBrand brand;
  final List<FlenxPdfPage> pages;
}
