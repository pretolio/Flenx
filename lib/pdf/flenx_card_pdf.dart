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
/// 85×55 mm + 3 mm de sangria em cada lado (91×61 mm). Segue o manual de
/// identidade da Alstop: fundo navy em gradiente, faixas de velocidade
/// diagonais (laranja) como grafismo, logo claro e QR do WhatsApp.
class FlenxCardPdf {
  static const _mm = PdfPageFormat.mm;
  static const _safe = 6.0 * _mm; // margem segura (borda + sangria)

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

  // ---------- fundo (gradiente noturno da marca) ----------
  static pw.BoxDecoration _bg(FlenxCardBrand b) => pw.BoxDecoration(
        gradient: pw.LinearGradient(
          begin: pw.Alignment.topRight,
          end: pw.Alignment.bottomLeft,
          colors: [_c('#1a3059'), _c(b.ink)],
        ),
      );

  // ---------- frente ----------
  static pw.Widget _front(FlenxCardBrand b, FlenxCardData d, pw.MemoryImage? logo) {
    return pw.Container(
      decoration: _bg(b),
      child: pw.Stack(children: [
        // Grafismo: faixas de velocidade diagonais no canto superior direito.
        pw.Positioned(top: -1 * _mm, right: -1 * _mm, child: _stripes(b, 30 * _mm, 34 * _mm)),
        pw.Padding(
          padding: pw.EdgeInsets.all(_safe),
          child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
            if (logo != null)
              pw.SizedBox(height: 9 * _mm, child: pw.Align(alignment: pw.Alignment.centerLeft, child: pw.FittedBox(fit: pw.BoxFit.contain, child: pw.Image(logo)))),
            pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Text(d.name, style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 13.5)),
              pw.SizedBox(height: 2),
              pw.Text(d.role.toUpperCase(), style: pw.TextStyle(color: _c('#8791a3'), fontSize: 6.5, letterSpacing: 1.3)),
            ]),
            pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.end, mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
              pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                _dot(b, d.phone, PdfColors.white, true),
                pw.SizedBox(height: 3),
                _dot(b, d.email, _c('#e7edf7'), false),
                pw.SizedBox(height: 1.5),
                _dot(b, '${d.site}   ·   ${d.city}', _c('#8791a3'), false),
              ]),
              _qr(b, d.whatsappUrl),
            ]),
          ]),
        ),
      ]),
    );
  }

  // ---------- verso ----------
  static pw.Widget _back(FlenxCardBrand b, FlenxCardData d, pw.MemoryImage? logo) {
    return pw.Container(
      decoration: _bg(b),
      child: pw.Stack(children: [
        pw.Positioned(top: -1 * _mm, right: -1 * _mm, child: _stripes(b, 22 * _mm, 26 * _mm)),
        pw.Center(
          child: pw.Column(mainAxisSize: pw.MainAxisSize.min, children: [
            if (logo != null)
              pw.SizedBox(width: 48 * _mm, height: 15 * _mm, child: pw.FittedBox(fit: pw.BoxFit.contain, child: pw.Image(logo))),
            pw.SizedBox(height: 4 * _mm),
            pw.Container(width: 16 * _mm, height: 2, color: _c(b.accent)),
            pw.SizedBox(height: 3.5 * _mm),
            pw.Text(d.tagline, textAlign: pw.TextAlign.center, style: pw.TextStyle(color: _c('#c3d2ec'), fontSize: 7.5, letterSpacing: .3)),
          ]),
        ),
      ]),
    );
  }

  /// Linha de contato com bolinha laranja de destaque.
  static pw.Widget _dot(FlenxCardBrand b, String t, PdfColor color, bool strong) => pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Container(width: 3, height: 3, margin: const pw.EdgeInsets.only(right: 5), decoration: pw.BoxDecoration(color: _c(b.accent), shape: pw.BoxShape.circle)),
          pw.Text(t, style: pw.TextStyle(color: color, fontSize: strong ? 9 : 7.5, fontWeight: strong ? pw.FontWeight.bold : pw.FontWeight.normal)),
        ],
      );

  /// QR do WhatsApp num selo branco arredondado (leitura garantida).
  static pw.Widget _qr(FlenxCardBrand b, String url) => pw.Column(mainAxisSize: pw.MainAxisSize.min, children: [
        pw.Container(
          padding: const pw.EdgeInsets.all(3),
          decoration: pw.BoxDecoration(color: PdfColors.white, borderRadius: pw.BorderRadius.circular(4)),
          child: pw.SizedBox(
            width: 13.5 * _mm,
            height: 13.5 * _mm,
            child: pw.BarcodeWidget(
              barcode: pw.Barcode.qrCode(errorCorrectLevel: pw.BarcodeQRCorrectionLevel.medium),
              data: url,
              color: _c(b.ink),
              drawText: false,
            ),
          ),
        ),
        pw.SizedBox(height: 2),
        pw.Text('WHATSAPP', style: pw.TextStyle(color: _c('#8791a3'), fontSize: 5, letterSpacing: 1.2)),
      ]);

  /// Faixas de velocidade: duas barras diagonais laranja (~15°) — grafismo
  /// oficial da marca. Sangram pelo canto.
  static pw.Widget _stripes(FlenxCardBrand b, double w, double h) => pw.SizedBox(
        width: w,
        height: h,
        child: pw.CustomPaint(
          size: PdfPoint(w, h),
          painter: (c, s) {
            c
              ..setStrokeColor(_c(b.accent))
              ..setLineCap(PdfLineCap.butt)
              ..setLineWidth(s.x * 0.15);
            final slant = s.y * 0.27; // ~15° da vertical
            for (var k = 0; k < 2; k++) {
              final x0 = s.x * 0.46 + k * s.x * 0.30;
              c
                ..moveTo(x0, -2)
                ..lineTo(x0 - slant, s.y + 2)
                ..strokePath();
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
