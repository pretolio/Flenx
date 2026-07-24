import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'flenx_pdf_loader.dart';

/// Marca para o cartão de visita (cores + logo p/ fundo escuro).
class FlenxCardBrand {
  const FlenxCardBrand({
    required this.ink,
    required this.ink2,
    required this.accent,
    required this.accentDark,
    required this.accentLight,
    this.logoWhitePath,
  });
  final String ink, ink2, accent, accentDark, accentLight;

  /// Logo em versão clara (branca), para o fundo escuro do cartão.
  final String? logoWhitePath;
}

/// Dados de um cartão de visita.
class FlenxCardData {
  const FlenxCardData({
    required this.name,
    required this.role,
    required this.phone,
    required this.email,
    required this.site,
    required this.city,
    required this.whatsappUrl,
    required this.tagline,
  });
  final String name, role, phone, email, site, city, whatsappUrl, tagline;
}

/// Gera um cartão de visita PDF pronto para gráfica: 2 páginas (frente e verso),
/// 85×55 mm + 3 mm de sangria em cada lado (91×61 mm), fundo escuro sangrando
/// até a borda, QR (WhatsApp) na frente. Mesmo pipeline dos documentos.
class FlenxCardPdf {
  static const _mm = PdfPageFormat.mm;
  static const _bleed = 3.0 * _mm; // sangria
  static const _safe = 6.0 * _mm; // margem segura do conteúdo (borda + sangria)

  static PdfColor _c(String hex) => PdfColor.fromHex(hex.replaceAll('#', ''));

  static Future<Uint8List> build(
    FlenxCardData d,
    FlenxCardBrand b, {
    Uint8List? fontRegular,
    Uint8List? fontBold,
    Map<String, pw.MemoryImage>? preloadedImages,
  }) async {
    final reg = await _font(fontRegular, const ['C:/Windows/Fonts/arial.ttf', '/Library/Fonts/Arial.ttf']);
    final bold = await _font(fontBold, const ['C:/Windows/Fonts/arialbd.ttf', '/Library/Fonts/Arial Bold.ttf']);
    final theme = pw.ThemeData.withFont(base: reg ?? pw.Font.helvetica(), bold: bold ?? pw.Font.helveticaBold());
    final pdf = pw.Document(theme: theme);

    final logo = await _image(b.logoWhitePath, preloadedImages);
    final fmt = PdfPageFormat(91 * _mm, 61 * _mm, marginAll: 0);

    pdf.addPage(pw.Page(pageFormat: fmt, build: (ctx) => _front(b, d, logo)));
    pdf.addPage(pw.Page(pageFormat: fmt, build: (ctx) => _back(b, d, logo)));
    return pdf.save();
  }

  // ---------- páginas ----------

  static pw.Widget _front(FlenxCardBrand b, FlenxCardData d, pw.MemoryImage? logo) {
    return pw.Container(
      color: _c(b.ink),
      child: pw.Stack(children: [
        // Faixa de destaque (laranja) na borda esquerda — sangra até o topo/base.
        pw.Positioned(left: 0, top: 0, bottom: 0, child: pw.Container(width: _bleed + 2.2 * _mm, color: _c(b.accent))),
        pw.Padding(
          padding: pw.EdgeInsets.fromLTRB(_safe + 2.5 * _mm, _safe, _safe, _safe),
          child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
            if (logo != null)
              pw.SizedBox(height: 9 * _mm, child: pw.Align(alignment: pw.Alignment.centerLeft, child: pw.FittedBox(fit: pw.BoxFit.contain, child: pw.Image(logo)))),
            pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Text(d.name, style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 13)),
              pw.SizedBox(height: 1.2),
              pw.Text(d.role.toUpperCase(), style: pw.TextStyle(color: _c('#8fa3c9'), fontSize: 6.5, letterSpacing: 1.2)),
              pw.SizedBox(height: 6),
              pw.Text(d.phone, style: pw.TextStyle(color: _c(b.accentLight), fontWeight: pw.FontWeight.bold, fontSize: 14)),
              pw.Text('ATENDIMENTO', style: pw.TextStyle(color: _c('#8fa3c9'), fontSize: 5.5, letterSpacing: 1.5)),
            ]),
            pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
              pw.Expanded(
                child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                  _line(b, d.email),
                  _line(b, d.site),
                  _line(b, d.city),
                ]),
              ),
              // QR (WhatsApp) num selo branco p/ leitura garantida.
              pw.Container(
                padding: const pw.EdgeInsets.all(3),
                decoration: pw.BoxDecoration(color: PdfColors.white, borderRadius: pw.BorderRadius.circular(4)),
                child: pw.SizedBox(
                  width: 15 * _mm,
                  height: 15 * _mm,
                  child: pw.BarcodeWidget(
                    barcode: pw.Barcode.qrCode(errorCorrectLevel: pw.BarcodeQRCorrectionLevel.medium),
                    data: d.whatsappUrl,
                    color: _c(b.ink),
                    drawText: false,
                  ),
                ),
              ),
            ]),
          ]),
        ),
      ]),
    );
  }

  static pw.Widget _back(FlenxCardBrand b, FlenxCardData d, pw.MemoryImage? logo) {
    return pw.Container(
      color: _c(b.ink),
      child: pw.Stack(children: [
        // Chevrons sutis (marca-d'água) no canto — eco do motivo da marca.
        pw.Positioned(right: -6 * _mm, bottom: -2 * _mm, child: pw.Opacity(opacity: 0.10, child: _chevrons(b, 26 * _mm))),
        pw.Center(
          child: pw.Column(mainAxisSize: pw.MainAxisSize.min, children: [
            if (logo != null)
              pw.SizedBox(width: 46 * _mm, height: 14 * _mm, child: pw.FittedBox(fit: pw.BoxFit.contain, child: pw.Image(logo))),
            pw.SizedBox(height: 4 * _mm),
            pw.Container(width: 14 * _mm, height: 1.5, color: _c(b.accent)),
            pw.SizedBox(height: 3 * _mm),
            pw.Text(d.tagline, textAlign: pw.TextAlign.center, style: pw.TextStyle(color: _c('#c3d2ec'), fontSize: 7, letterSpacing: .3)),
          ]),
        ),
      ]),
    );
  }

  static pw.Widget _line(FlenxCardBrand b, String t) => pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 1.5),
        child: pw.Text(t, style: pw.TextStyle(color: _c('#e7edf7'), fontSize: 7)),
      );

  /// Três chevrons (») apontando à direita — motivo de velocidade da marca.
  static pw.Widget _chevrons(FlenxCardBrand b, double size) => pw.SizedBox(
        width: size,
        height: size,
        child: pw.CustomPaint(
          size: PdfPoint(size, size),
          painter: (c, s) {
            c.setFillColor(_c(b.accent));
            final w = s.x, h = s.y;
            for (var k = 0; k < 3; k++) {
              final ox = w * (0.12 + k * 0.28);
              c
                ..moveTo(ox, h * 0.15)
                ..lineTo(ox + w * 0.2, h * 0.5)
                ..lineTo(ox, h * 0.85)
                ..lineTo(ox + w * 0.09, h * 0.85)
                ..lineTo(ox + w * 0.29, h * 0.5)
                ..lineTo(ox + w * 0.09, h * 0.15)
                ..fillPath();
            }
          },
        ),
      );

  // ---------- infra ----------
  static Future<pw.Font?> _font(Uint8List? injected, List<String> fallbacks) async {
    if (injected != null) return pw.Font.ttf(injected.buffer.asByteData());
    for (final p in fallbacks) {
      final bytes = await loadLocalFile(p);
      if (bytes != null) return pw.Font.ttf(bytes.buffer.asByteData());
    }
    return null;
  }

  static Future<pw.MemoryImage?> _image(String? path, Map<String, pw.MemoryImage>? pre) async {
    if (path == null) return null;
    if (pre != null && pre.containsKey(path)) return pre[path];
    final bytes = await loadLocalFile(path);
    if (bytes == null) return null;
    final decoded = img.decodeImage(bytes);
    if (decoded == null) return null;
    return pw.MemoryImage(img.encodePng(decoded));
  }
}
