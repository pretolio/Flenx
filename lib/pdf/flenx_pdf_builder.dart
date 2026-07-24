import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'flenx_pdf_models.dart';

/// Gera um PDF A4 comercial a partir de um [FlenxPdfDoc]. Cada página ocupa uma
/// folha A4 inteira, com o fundo (cor) sangrando até as bordas — imprime igual
/// em qualquer lugar, sem depender de "imprimir gráficos de fundo".
class FlenxPdf {
  /// [fontRegular]/[fontBold]: TTF opcionais. Se nulos, tenta Arial (Windows)
  /// e cai para Helvetica. A fonte precisa cobrir acentos pt-BR e ✓/×.
  static Future<Uint8List> build(
    FlenxPdfDoc doc, {
    String? fontRegular,
    String? fontBold,
  }) async {
    final b = doc.brand;
    final reg = await _font(fontRegular, const [
      'C:/Windows/Fonts/arial.ttf',
      '/Library/Fonts/Arial.ttf',
      '/System/Library/Fonts/Supplemental/Arial.ttf',
    ]);
    final bold = await _font(fontBold, const [
      'C:/Windows/Fonts/arialbd.ttf',
      '/Library/Fonts/Arial Bold.ttf',
      '/System/Library/Fonts/Supplemental/Arial Bold.ttf',
    ]);

    final theme = pw.ThemeData.withFont(base: reg ?? pw.Font.helvetica(), bold: bold ?? pw.Font.helveticaBold());
    final pdf = pw.Document(theme: theme);

    // Pré-carrega imagens usadas.
    final images = <String, pw.MemoryImage>{};
    Future<pw.MemoryImage?> image(String? path) async {
      if (path == null) return null;
      if (images.containsKey(path)) return images[path];
      final mi = await _loadImage(path);
      if (mi != null) images[path] = mi;
      return mi;
    }

    final total = doc.pages.length;
    var pageNum = 0;
    for (final page in doc.pages) {
      pageNum++;
      switch (page) {
        case FlenxPdfCover(:final imagePath, :final eyebrow, :final title, :final subtitle):
          final im = await image(imagePath);
          pdf.addPage(_coverPage(b, im, eyebrow, title, subtitle));
        case FlenxPdfChecklist():
          pdf.addPage(_sectionPage(b, page.tone, _checklist(b, page), page: pageNum, total: total));
        case FlenxPdfText():
          pdf.addPage(_sectionPage(b, page.tone, _text(b, page), page: pageNum, total: total));
        case FlenxPdfSpotlight():
          final im = await image(page.imagePath);
          pdf.addPage(_sectionPage(b, page.tone, _spotlight(b, page, im), page: pageNum, total: total));
        case FlenxPdfSteps():
          pdf.addPage(_sectionPage(b, page.tone, _steps(b, page), page: pageNum, total: total));
        case FlenxPdfCompare():
          pdf.addPage(_sectionPage(b, page.tone, _compare(b, page), page: pageNum, total: total));
        case FlenxPdfCombo():
          pdf.addPage(_sectionPage(b, page.tone, _combo(b, page), page: pageNum, total: total));
        case FlenxPdfContact():
          final im = await image(b.logoDarkBgPath);
          pdf.addPage(_sectionPage(b, page.tone, _contact(b, page, im), page: pageNum, total: total));
      }
    }
    return pdf.save();
  }

  // ---------- infra ----------
  static PdfColor _c(String hex) => PdfColor.fromHex(hex.replaceAll('#', ''));

  static Future<pw.Font?> _font(String? path, List<String> fallbacks) async {
    for (final p in [if (path != null) path, ...fallbacks]) {
      final f = File(p);
      if (await f.exists()) return pw.Font.ttf((await f.readAsBytes()).buffer.asByteData());
    }
    return null;
  }

  static Future<pw.MemoryImage?> _loadImage(String path) async {
    final f = File(path);
    if (!await f.exists()) return null;
    final bytes = await f.readAsBytes();
    // O package pdf lê PNG/JPG — decodifica (inclusive webp) e recodifica.
    // Logos com transparência real precisam continuar em PNG: reencodar em
    // JPG apaga o alpha e pinta a área transparente de branco sólido (o
    // "quadrado branco" atrás do logo no fundo escuro). Fotos/prints não têm
    // transparência de verdade mesmo quando decodificam com 4 canais — por
    // isso checamos se existe algum pixel realmente transparente, em vez de
    // só olhar o número de canais (senão toda imagem vira PNG, bem mais
    // pesado que JPG).
    final decoded = img.decodeImage(bytes);
    if (decoded == null) return null;
    final transparent = decoded.hasAlpha && decoded.any((p) => p.a < 255);
    return pw.MemoryImage(transparent ? img.encodePng(decoded) : img.encodeJpg(decoded, quality: 86));
  }

  static PdfColor _bg(FlenxPdfBrand b, FlenxPdfTone t) =>
      switch (t) { FlenxPdfTone.white => PdfColors.white, FlenxPdfTone.light => _c(b.light), FlenxPdfTone.ink => _c(b.ink) };
  static PdfColor _title(FlenxPdfBrand b, FlenxPdfTone t) => t == FlenxPdfTone.ink ? PdfColors.white : _c(b.ink);
  static PdfColor _body(FlenxPdfBrand b, FlenxPdfTone t) => t == FlenxPdfTone.ink ? _c('#c3d2ec') : _c('#43536b');
  static PdfColor _eye(FlenxPdfBrand b, FlenxPdfTone t) => t == FlenxPdfTone.ink ? _c(b.primaryLight) : _c(b.primaryDark);

  // ---------- páginas ----------
  /// O corpo ocupa toda a altura útil da folha (entre o topo e o rodapé de
  /// marca): listas se distribuem para preencher o espaço; blocos de texto
  /// ficam centralizados nele. Nunca sobra metade da folha em branco.
  static pw.Page _sectionPage(FlenxPdfBrand b, FlenxPdfTone tone, pw.Widget child, {required int page, required int total}) {
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.zero,
      build: (ctx) => pw.Container(
        color: _bg(b, tone),
        width: double.infinity,
        height: double.infinity,
        padding: const pw.EdgeInsets.fromLTRB(46, 54, 46, 34),
        child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.stretch, children: [
          pw.Expanded(child: child),
          _footer(b, tone, page, total),
        ]),
      ),
    );
  }

  static pw.Widget _footer(FlenxPdfBrand b, FlenxPdfTone tone, int page, int total) {
    final rule = tone == FlenxPdfTone.ink ? _c('#1c3565') : _c('#e3e9f5');
    final txt = tone == FlenxPdfTone.ink ? _c('#8fa3c9') : _c('#8a95a8');
    return pw.Column(mainAxisSize: pw.MainAxisSize.min, children: [
      pw.Container(height: 0.75, color: rule),
      pw.SizedBox(height: 10),
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
        pw.Text('ALSTOP EXPRESS · PROPOSTA COMERCIAL', style: pw.TextStyle(color: txt, fontSize: 7.5, letterSpacing: 0.6)),
        pw.Text('alstop.com.br', style: pw.TextStyle(color: txt, fontSize: 7.5, letterSpacing: 0.6)),
        pw.Text('$page / $total', style: pw.TextStyle(color: txt, fontSize: 7.5, letterSpacing: 0.6)),
      ]),
    ]);
  }

  static pw.Widget _head(FlenxPdfBrand b, FlenxPdfTone tone, String? eyebrow, String title, [String? subtitle, bool center = true]) {
    return pw.Column(crossAxisAlignment: center ? pw.CrossAxisAlignment.center : pw.CrossAxisAlignment.start, children: [
      if (eyebrow != null)
        pw.Text(eyebrow.toUpperCase(), style: pw.TextStyle(color: _eye(b, tone), fontWeight: pw.FontWeight.bold, fontSize: 9, letterSpacing: 2)),
      pw.SizedBox(height: 6),
      pw.Text(title, textAlign: center ? pw.TextAlign.center : pw.TextAlign.left,
          style: pw.TextStyle(color: _title(b, tone), fontWeight: pw.FontWeight.bold, fontSize: 25, lineSpacing: 1.5)),
      if (subtitle != null) ...[
        pw.SizedBox(height: 10),
        pw.Text(subtitle, textAlign: center ? pw.TextAlign.center : pw.TextAlign.left,
            style: pw.TextStyle(color: _body(b, tone), fontSize: 11.5, lineSpacing: 1.6)),
      ],
    ]);
  }

  /// Marcador visual (sem glifo — Arial não tem ✓): um "check" desenhado como
  /// dois traços, ou um traço para o negativo. Fica dentro de um quadrado colorido.
  static pw.Widget _marker(FlenxPdfBrand b, bool negative) => pw.Container(
        width: 18, height: 18, margin: const pw.EdgeInsets.only(top: 1, right: 9),
        decoration: pw.BoxDecoration(color: negative ? _c('#94a3b8') : _c(b.primary), borderRadius: pw.BorderRadius.circular(5)),
        alignment: pw.Alignment.center,
        child: negative ? _dash() : _check(),
      );

  /// Checkmark vetorial (branco), independente de fonte.
  static pw.Widget _check() => pw.SizedBox(
        width: 10, height: 10,
        child: pw.CustomPaint(
          size: const PdfPoint(10, 10),
          painter: (c, size) {
            c
              ..setStrokeColor(PdfColors.white)
              ..setLineWidth(1.6)
              ..setLineCap(PdfLineCap.round)
              ..setLineJoin(PdfLineJoin.round)
              ..moveTo(2.0, 5.4)
              ..lineTo(4.1, 3.0)
              ..lineTo(8.4, 7.8)
              ..strokePath();
          },
        ),
      );

  static pw.Widget _dash() => pw.Container(width: 9, height: 1.8, color: PdfColors.white);

  static pw.Widget _itemRow(FlenxPdfBrand b, FlenxPdfTone tone, FlenxPdfItem it, bool negative) => pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 20),
        child: pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          _marker(b, negative),
          pw.Expanded(
            child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Text(it.title, style: pw.TextStyle(color: _title(b, tone), fontWeight: pw.FontWeight.bold, fontSize: 12.5)),
              if (it.description != null) ...[
                pw.SizedBox(height: 2),
                pw.Text(it.description!, style: pw.TextStyle(color: _body(b, tone), fontSize: 10.5, lineSpacing: 1.7)),
              ],
            ]),
          ),
        ]),
      );

  /// Duas colunas de linhas, alinhadas no topo.
  static pw.Widget _twoCols(List<pw.Widget> rows) {
    final mid = (rows.length / 2).ceil();
    return pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Expanded(child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: rows.sublist(0, mid))),
      pw.SizedBox(width: 34),
      pw.Expanded(child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: rows.sublist(mid))),
    ]);
  }

  /// Cabeçalho + lista, sempre ancorados no topo da folha — sem centralizar
  /// e sem espaçamento artificial; a página se preenche com conteúdo real
  /// (mais itens/descrição), não com espaço em branco distribuído.
  static pw.Widget _checklist(FlenxPdfBrand b, FlenxPdfChecklist p) {
    final rows = p.items.map((it) => _itemRow(b, p.tone, it, p.negative)).toList();
    final twoCol = p.columns >= 2 && rows.length > 3;
    return pw.Align(
      alignment: pw.Alignment.topLeft,
      child: pw.Column(mainAxisSize: pw.MainAxisSize.min, crossAxisAlignment: pw.CrossAxisAlignment.stretch, children: [
        _head(b, p.tone, p.eyebrow, p.title, p.subtitle),
        pw.SizedBox(height: 28),
        twoCol ? _twoCols(rows) : pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: rows),
        if (p.highlight != null) ...[
          pw.SizedBox(height: 22),
          pw.Container(
            padding: const pw.EdgeInsets.fromLTRB(18, 14, 18, 14),
            decoration: pw.BoxDecoration(
              color: p.tone == FlenxPdfTone.ink ? _c('#0f2a57') : _c(b.light),
              borderRadius: pw.BorderRadius.circular(8),
              border: pw.Border(left: pw.BorderSide(color: _c(b.primary), width: 3)),
            ),
            child: pw.Text(p.highlight!,
                style: pw.TextStyle(color: _title(b, p.tone), fontWeight: pw.FontWeight.bold, fontSize: 12, lineSpacing: 1.6)),
          ),
        ],
        if (p.trend != null) ...[
          pw.SizedBox(height: 22),
          _trendCard(b, p.tone, p.trend!),
        ],
      ]),
    );
  }

  /// Card de estatística + mini-gráfico de linha em queda (valores
  /// ilustrativos — comunica a tendência, não é dado de mercado).
  static pw.Widget _trendCard(FlenxPdfBrand b, FlenxPdfTone tone, FlenxPdfTrend t) {
    final values = t.points.map((p) => p.value).toList();
    final maxV = values.reduce((a, c) => a > c ? a : c);
    final minV = values.reduce((a, c) => a < c ? a : c);
    final range = (maxV - minV) == 0 ? 1.0 : (maxV - minV);
    final cardBg = tone == FlenxPdfTone.ink ? _c('#0f2a57') : PdfColors.white;
    final cardBorder = tone == FlenxPdfTone.ink ? _c('#1c3565') : _c('#e3e9f5');
    final axisTxt = _body(b, tone);

    return pw.Container(
      padding: const pw.EdgeInsets.all(18),
      decoration: pw.BoxDecoration(color: cardBg, borderRadius: pw.BorderRadius.circular(10), border: pw.Border.all(color: cardBorder, width: 1)),
      child: pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
        pw.Expanded(
          flex: 5,
          child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text(t.stat, style: pw.TextStyle(color: _c(b.primaryDark), fontWeight: pw.FontWeight.bold, fontSize: 15)),
            pw.SizedBox(height: 5),
            pw.Text(t.statLabel, style: pw.TextStyle(color: _title(b, tone), fontSize: 11, lineSpacing: 1.6)),
          ]),
        ),
        pw.SizedBox(width: 22),
        pw.Expanded(
          flex: 4,
          child: pw.Column(children: [
            pw.SizedBox(
              height: 70,
              width: double.infinity,
              child: pw.CustomPaint(
                size: const PdfPoint(200, 70),
                painter: (c, size) {
                  final n = values.length;
                  if (n < 2) return;
                  const padX = 5.0, padY = 8.0;
                  final w = size.x - padX * 2, h = size.y - padY * 2;
                  double xAt(int i) => padX + w * i / (n - 1);
                  double yAt(double v) => padY + h * (v - minV) / range;
                  c
                    ..setStrokeColor(cardBorder)
                    ..setLineWidth(0.75)
                    ..drawLine(padX, padY, size.x - padX, padY)
                    ..strokePath();
                  c
                    ..setStrokeColor(_c(b.primaryDark))
                    ..setLineWidth(2.2)
                    ..setLineCap(PdfLineCap.round)
                    ..setLineJoin(PdfLineJoin.round)
                    ..moveTo(xAt(0), yAt(values[0]));
                  for (var i = 1; i < n; i++) {
                    c.lineTo(xAt(i), yAt(values[i]));
                  }
                  c.strokePath();
                  for (var i = 0; i < n; i++) {
                    final last = i == n - 1;
                    c
                      ..setFillColor(last ? _c(b.primaryDark) : cardBg)
                      ..setStrokeColor(_c(b.primaryDark))
                      ..setLineWidth(1.3)
                      ..drawEllipse(xAt(i), yAt(values[i]), last ? 3.4 : 2.6, last ? 3.4 : 2.6)
                      ..fillAndStrokePath();
                  }
                },
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
              pw.Text(t.points.first.label, style: pw.TextStyle(color: axisTxt, fontSize: 8)),
              pw.Text(t.points.last.label, style: pw.TextStyle(color: axisTxt, fontSize: 8)),
            ]),
          ]),
        ),
      ]),
    );
  }

  /// Card de estatística (valor + rótulo) com borda — usado em [_text].
  static pw.Widget _statCard(FlenxPdfBrand b, FlenxPdfTone tone, FlenxPdfStat s) => pw.Container(
        width: 132,
        padding: const pw.EdgeInsets.fromLTRB(14, 12, 14, 14),
        decoration: pw.BoxDecoration(
          color: tone == FlenxPdfTone.ink ? _c('#0f2a57') : PdfColors.white,
          borderRadius: pw.BorderRadius.circular(8),
          border: pw.Border.all(color: tone == FlenxPdfTone.ink ? _c('#1c3565') : _c('#e3e9f5'), width: 1),
        ),
        child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Text(s.value, style: pw.TextStyle(color: _c(b.primary), fontWeight: pw.FontWeight.bold, fontSize: 16)),
          pw.SizedBox(height: 3),
          pw.Text(s.label, style: pw.TextStyle(color: _body(b, tone), fontSize: 9.5, lineSpacing: 1.4)),
        ]),
      );

  /// Cabeçalho + parágrafos/estatísticas ancorados no topo da folha.
  static pw.Widget _text(FlenxPdfBrand b, FlenxPdfText p) {
    final block = pw.Column(mainAxisSize: pw.MainAxisSize.min, crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      _head(b, p.tone, p.eyebrow, p.title, null, false),
      pw.SizedBox(height: 20),
      for (final para in p.paragraphs) ...[
        pw.Text(para, style: pw.TextStyle(color: _body(b, p.tone), fontSize: 12, lineSpacing: 2.6)),
        pw.SizedBox(height: 16),
      ],
      if (p.stats.isNotEmpty) ...[
        pw.SizedBox(height: 10),
        pw.Wrap(spacing: 14, runSpacing: 14, children: [for (final s in p.stats) _statCard(b, p.tone, s)]),
      ],
    ]);
    return pw.Align(alignment: pw.Alignment.topLeft, child: block);
  }

  static pw.Widget _bullet(FlenxPdfBrand b, FlenxPdfTone tone, String t) => pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 12),
        child: pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Container(width: 16, height: 16, margin: const pw.EdgeInsets.only(top: 1, right: 8),
              decoration: pw.BoxDecoration(color: _c(b.primary), borderRadius: pw.BorderRadius.circular(4)),
              alignment: pw.Alignment.center,
              child: _check()),
          pw.Expanded(child: pw.Text(t, style: pw.TextStyle(color: _title(b, tone), fontSize: 11.5, lineSpacing: 1.7))),
        ]),
      );

  /// Texto + bullets no topo; se houver imagem, ela cresce para preencher todo
  /// o resto da folha, emoldurada como um card de produto — sem cortar nada
  /// (BoxFit.contain: o print inteiro sempre visível, nunca com pedaço fora).
  static pw.Widget _spotlight(FlenxPdfBrand b, FlenxPdfSpotlight p, pw.MemoryImage? im) {
    final head = pw.Column(mainAxisSize: pw.MainAxisSize.min, crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      _head(b, p.tone, p.eyebrow, p.title, null, false),
      if (p.description != null) ...[
        pw.SizedBox(height: 12),
        pw.Text(p.description!, style: pw.TextStyle(color: _body(b, p.tone), fontSize: 12, lineSpacing: 2.2)),
      ],
      pw.SizedBox(height: 20),
      for (final t in p.bullets) _bullet(b, p.tone, t),
    ]);
    if (im == null) return pw.Align(alignment: pw.Alignment.centerLeft, child: head);
    return pw.Column(mainAxisSize: pw.MainAxisSize.max, crossAxisAlignment: pw.CrossAxisAlignment.stretch, children: [
      head,
      pw.SizedBox(height: 26),
      pw.Expanded(
        child: pw.Container(
          decoration: pw.BoxDecoration(
            color: PdfColors.white,
            borderRadius: pw.BorderRadius.circular(10),
            border: pw.Border.all(color: _c('#e3e9f5'), width: 1),
          ),
          padding: const pw.EdgeInsets.all(14),
          alignment: pw.Alignment.center,
          child: pw.Image(im, fit: pw.BoxFit.contain),
        ),
      ),
    ]);
  }

  /// Cabeçalho + passos numerados, ancorados no topo da folha.
  static pw.Widget _steps(FlenxPdfBrand b, FlenxPdfSteps p) {
    var n = 0;
    final rows = p.steps.map((s) {
      n++;
      return pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 22),
        child: pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Container(width: 30, height: 30, margin: const pw.EdgeInsets.only(right: 14),
              decoration: pw.BoxDecoration(color: _c(b.primary), borderRadius: pw.BorderRadius.circular(8)),
              alignment: pw.Alignment.center,
              child: pw.Text('$n', style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 13))),
          pw.Expanded(child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text(s.title, style: pw.TextStyle(color: _title(b, p.tone), fontWeight: pw.FontWeight.bold, fontSize: 13.5)),
            if (s.description != null) ...[
              pw.SizedBox(height: 3),
              pw.Text(s.description!, style: pw.TextStyle(color: _body(b, p.tone), fontSize: 11, lineSpacing: 1.7)),
            ],
          ])),
        ]),
      );
    }).toList();
    return pw.Align(
      alignment: pw.Alignment.topLeft,
      child: pw.Column(mainAxisSize: pw.MainAxisSize.min, crossAxisAlignment: pw.CrossAxisAlignment.stretch, children: [
        _head(b, p.tone, p.eyebrow, p.title),
        pw.SizedBox(height: 30),
        _twoCols(rows),
      ]),
    );
  }

  static pw.Widget _compareMark(FlenxPdfBrand b, bool yes, String? note) => pw.Column(children: [
        pw.Container(
          width: 22, height: 22,
          decoration: pw.BoxDecoration(
            color: yes ? _c(b.primary) : _c('#e7ebf2'),
            borderRadius: pw.BorderRadius.circular(6),
          ),
          alignment: pw.Alignment.center,
          child: yes ? _check() : _dash(),
        ),
        if (note != null) ...[
          pw.SizedBox(height: 3),
          pw.Text(note, textAlign: pw.TextAlign.center, style: pw.TextStyle(color: _c('#8a95a8'), fontSize: 7.5)),
        ],
      ]);

  /// Tabela comparativa Alstop × alternativa — gráfico simples (check/×) que
  /// carrega informação real, em vez de espaço decorativo.
  static pw.Widget _compare(FlenxPdfBrand b, FlenxPdfCompare p) {
    final rowsW = <pw.Widget>[];
    for (var i = 0; i < p.rows.length; i++) {
      final r = p.rows[i];
      rowsW.add(pw.Container(
        color: i.isOdd ? _c(p.tone == FlenxPdfTone.light ? '#eef2f9' : '#f5f8fd') : null,
        padding: const pw.EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
          pw.Expanded(flex: 5, child: pw.Text(r.label, style: pw.TextStyle(color: _title(b, p.tone), fontSize: 11.5, fontWeight: pw.FontWeight.bold))),
          pw.Expanded(flex: 2, child: pw.Center(child: _compareMark(b, r.ours, null))),
          pw.Expanded(flex: 2, child: pw.Center(child: _compareMark(b, r.theirs, r.theirsNote))),
        ]),
      ));
    }
    return pw.Align(
      alignment: pw.Alignment.topLeft,
      child: pw.Column(mainAxisSize: pw.MainAxisSize.min, crossAxisAlignment: pw.CrossAxisAlignment.stretch, children: [
        _head(b, p.tone, p.eyebrow, p.title, p.subtitle),
        pw.SizedBox(height: 28),
        pw.Container(
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: _c('#e3e9f5'), width: 1),
            borderRadius: pw.BorderRadius.circular(10),
          ),
          child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.stretch, children: [
            pw.Container(
              color: _c(b.ink),
              padding: const pw.EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: pw.Row(children: [
                pw.Expanded(flex: 5, child: pw.SizedBox()),
                pw.Expanded(flex: 2, child: pw.Center(child: pw.Text(p.ourLabel, style: pw.TextStyle(color: _c(b.primaryLight), fontWeight: pw.FontWeight.bold, fontSize: 10)))),
                pw.Expanded(flex: 2, child: pw.Center(child: pw.Text(p.theirLabel, style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 10)))),
              ]),
            ),
            pw.ClipRRect(
              horizontalRadius: 10,
              verticalRadius: 10,
              child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.stretch, children: rowsW),
            ),
          ]),
        ),
      ]),
    );
  }

  static pw.Widget _renderBlock(FlenxPdfBrand b, FlenxPdfPage blk) => switch (blk) {
        FlenxPdfText() => _text(b, blk),
        FlenxPdfChecklist() => _checklist(b, blk),
        FlenxPdfSteps() => _steps(b, blk),
        FlenxPdfCompare() => _compare(b, blk),
        _ => throw UnsupportedError('Bloco não suportado em FlenxPdfCombo: ${blk.runtimeType}'),
      };

  /// Empilha os blocos de um [FlenxPdfCombo] numa folha só, com uma linha
  /// divisória entre cada um — todos ancorados no topo.
  static pw.Widget _combo(FlenxPdfBrand b, FlenxPdfCombo p) {
    final rule = p.tone == FlenxPdfTone.ink ? '#1c3565' : '#e3e9f5';
    final children = <pw.Widget>[];
    for (var i = 0; i < p.blocks.length; i++) {
      if (i > 0) {
        children.add(pw.SizedBox(height: 26));
        children.add(pw.Container(height: 0.75, color: _c(rule)));
        children.add(pw.SizedBox(height: 26));
      }
      children.add(_renderBlock(b, p.blocks[i]));
    }
    return pw.Align(
      alignment: pw.Alignment.topLeft,
      child: pw.Column(mainAxisSize: pw.MainAxisSize.min, crossAxisAlignment: pw.CrossAxisAlignment.stretch, children: children),
    );
  }

  /// Fechamento — bloco de contato centralizado na folha (única página do
  /// documento que não fica ancorada no topo: é o encerramento).
  static pw.Widget _contact(FlenxPdfBrand b, FlenxPdfContact p, pw.MemoryImage? logo) {
    final block = pw.Column(mainAxisSize: pw.MainAxisSize.min, crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
      if (logo != null) ...[pw.Image(logo, width: 210), pw.SizedBox(height: 30)],
      pw.Text(p.title, textAlign: pw.TextAlign.center, style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 26, lineSpacing: 1.4)),
      if (p.subtitle != null) ...[
        pw.SizedBox(height: 12),
        pw.Text(p.subtitle!, textAlign: pw.TextAlign.center, style: pw.TextStyle(color: _c('#c3d2ec'), fontSize: 12, lineSpacing: 1.7)),
      ],
      pw.SizedBox(height: 30),
      pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.symmetric(vertical: 22, horizontal: 24),
        decoration: pw.BoxDecoration(
          color: _c('#0f2a57'),
          borderRadius: pw.BorderRadius.circular(10),
          border: pw.Border.all(color: _c('#1c3565'), width: 1),
        ),
        child: pw.Column(children: [
          for (final l in p.lines)
            pw.Padding(padding: const pw.EdgeInsets.only(bottom: 8),
                child: pw.Text(l, textAlign: pw.TextAlign.center, style: pw.TextStyle(color: PdfColors.white, fontSize: 11.5))),
        ]),
      ),
    ]);
    return pw.Align(alignment: pw.Alignment.center, child: block);
  }

  static pw.Page _coverPage(FlenxPdfBrand b, pw.MemoryImage? im, String? eyebrow, String title, String? subtitle) {
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.zero,
      build: (ctx) => pw.Stack(fit: pw.StackFit.expand, children: [
        // Foto ocupa a página inteira.
        if (im != null) pw.Image(im, fit: pw.BoxFit.cover) else pw.Container(color: _c(b.ink)),
        // Faixa inferior sólida (ink) com o texto — legível sobre qualquer foto.
        pw.Align(
          alignment: pw.Alignment.bottomLeft,
          child: pw.Container(
            width: double.infinity,
            color: _c(b.ink),
            padding: const pw.EdgeInsets.fromLTRB(46, 34, 46, 40),
            child: pw.Column(mainAxisSize: pw.MainAxisSize.min, crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              if (eyebrow != null)
                pw.Text(eyebrow.toUpperCase(), style: pw.TextStyle(color: _c(b.primaryLight), fontWeight: pw.FontWeight.bold, fontSize: 10, letterSpacing: 2)),
              pw.SizedBox(height: 12),
              pw.Text(title, style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 28, lineSpacing: 2)),
              if (subtitle != null) ...[
                pw.SizedBox(height: 12),
                pw.Text(subtitle, style: pw.TextStyle(color: _c('#e7edf7'), fontSize: 11.5, lineSpacing: 2.5)),
              ],
            ]),
          ),
        ),
      ]),
    );
  }
}
