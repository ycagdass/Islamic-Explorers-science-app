import 'package:flutter/material.dart';
import 'dart:math';

class ScientistBackground extends StatelessWidget {
  final String scientistName;
  final Widget child;

  const ScientistBackground({
    super.key,
    required this.scientistName,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;

    return Stack(
      children: [
        // Katman 1: Gradient zemin rengi (çok hafif)
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primary.withValues(alpha: isDark ? 0.09 : 0.05),
                  primary.withValues(alpha: isDark ? 0.04 : 0.02),
                  primary.withValues(alpha: isDark ? 0.07 : 0.04),
                ],
              ),
            ),
          ),
        ),
        // Katman 2: Tematik arka plan çizimleri (CustomPaint)
        Positioned.fill(
          child: CustomPaint(
            painter: _BackgroundPainter(scientistName, primary, isDark),
          ),
        ),
        // Katman 3: İçerik
        child,
        // Katman 4: Dekoratif ön-plan overlay (içeriğin üstünde ama IgnorePointer ile dokunulamaz)
        // Sadece köşe / kenar bölgelerine hafif dekoratif elementler ekler
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: _OverlayPainter(scientistName, primary, isDark),
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// ANA ARKA PLAN PAINTER — yoğun, belirgin tematik elementler
// ═══════════════════════════════════════════════════════════════════════════
class _BackgroundPainter extends CustomPainter {
  final String name;
  final Color primaryColor;
  final bool isDark;

  _BackgroundPainter(this.name, this.primaryColor, this.isDark);

  // Opaklık seviyeleri: eskiye göre ~2.5x artırıldı
  double get _strokeAlpha => isDark ? 0.42 : 0.28;
  double get _fillAlpha => isDark ? 0.26 : 0.17;
  double get _textAlpha => isDark ? 0.52 : 0.34;

  Paint _sp([double? a]) => Paint()
    ..color = primaryColor.withValues(alpha: a ?? _strokeAlpha)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.8;

  Paint _fp([double? a]) => Paint()
    ..color = primaryColor.withValues(alpha: a ?? _fillAlpha)
    ..style = PaintingStyle.fill;

  void _txt(
    Canvas canvas,
    String text,
    Offset offset,
    double fontSize, {
    double angle = 0,
    double? alpha,
    FontWeight weight = FontWeight.bold,
  }) {
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    canvas.rotate(angle);
    final tp = TextPainter(textDirection: TextDirection.ltr)
      ..text = TextSpan(
        text: text,
        style: TextStyle(
          fontSize: fontSize,
          color: primaryColor.withValues(alpha: alpha ?? _textAlpha),
          fontWeight: weight,
        ),
      )
      ..layout();
    tp.paint(canvas, Offset.zero);
    canvas.restore();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(name.hashCode);
    if (name.contains('Harezmi')) {
      _harezmi(canvas, size, rng);
    } else if (name.contains('Ali Ku')) {
      _aliKuscu(canvas, size, rng);
    } else if (name.contains('bn-i Sina') || name.contains('İbn')) {
      _ibniSina(canvas, size, rng);
    } else if (name.contains('Ulu')) {
      _ulugBey(canvas, size, rng);
    } else if (name.contains('Cahit') || name.contains('Arf')) {
      _cahitArf(canvas, size, rng);
    } else {
      _defaultBg(canvas, size, rng);
    }
  }

  // ═══════════════════════════════════════════════════════════
  // HAREZMİ — Cebir, algoritmalar, Hint-Arap rakamları
  // Referans görsel mantığı: büyük rakamlar + cebirsel ifadeler ön planda
  // ═══════════════════════════════════════════════════════════
  void _harezmi(Canvas canvas, Size size, Random rng) {
    // === HERO ELEMENT: Köşeye büyük sayı/formül bloğu ===
    // Sol üst: büyük "al-jabr" yazısı
    _txt(canvas, 'al-jabr', Offset(size.width * 0.03, size.height * 0.04),
        size.width * 0.10,
        alpha: _textAlpha * 1.1);
    // Sağ alt: büyük eşitlik sembolü
    _txt(canvas, 'x²+bx+c=0',
        Offset(size.width * 0.35, size.height * 0.84), size.width * 0.07,
        alpha: _textAlpha * 1.0);

    // Katman 1: Büyük cebirsel ifadeler (belirgin metin)
    final exprs = [
      'ax² + bx + c = 0',
      'x = (−b ± √Δ) / 2a',
      '∑ nᵢ = n(n+1)/2',
      'الجبر والمقابلة',
      'f(x) = ax + b',
      'Algorithm',
      '٠ ١ ٢ ٣ ٤ ٥',
      'n = p × q',
      'x² − y² = (x+y)(x−y)',
    ];
    for (int i = 0; i < exprs.length; i++) {
      final x = rng.nextDouble() * size.width * 0.75;
      final y = rng.nextDouble() * size.height * 0.82;
      final fs = 22.0 + rng.nextDouble() * 30.0;
      final angle = (rng.nextDouble() - 0.5) * pi / 6;
      _txt(canvas, exprs[i], Offset(x, y), fs,
          angle: angle,
          alpha: _textAlpha * (0.75 + rng.nextDouble() * 0.40));
    }

    // Katman 2: Hint-Arap rakamları çeşitli boyutlarda — daha büyük & belirgin
    const digits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    for (int i = 0; i < 28; i++) {
      final d = digits[rng.nextInt(digits.length)];
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final fs = 36.0 + rng.nextDouble() * 88.0;
      _txt(canvas, d, Offset(x, y), fs,
          alpha: _textAlpha * (0.40 + rng.nextDouble() * 0.65));
    }

    // Katman 3: Tablo/ızgara (hesap tabloları) — daha net çizgi kalınlığı
    for (int i = 0; i < 6; i++) {
      final x = rng.nextDouble() * size.width * 0.65;
      final y = rng.nextDouble() * size.height * 0.65;
      final cell = 20.0 + rng.nextDouble() * 26.0;
      final cols = 3 + rng.nextInt(5);
      final rows = 2 + rng.nextInt(4);
      final gp = _sp(_strokeAlpha * 0.85)..strokeWidth = 1.8;
      for (int r = 0; r <= rows; r++) {
        canvas.drawLine(
          Offset(x, y + r * cell),
          Offset(x + cols * cell, y + r * cell),
          gp,
        );
      }
      for (int c = 0; c <= cols; c++) {
        canvas.drawLine(
          Offset(x + c * cell, y),
          Offset(x + c * cell, y + rows * cell),
          gp,
        );
      }
    }

    // Katman 4: Geometrik inşalar — daire + içine yazılı kare (daha büyük)
    for (int i = 0; i < 7; i++) {
      final cx = rng.nextDouble() * size.width;
      final cy = rng.nextDouble() * size.height;
      final r = 32.0 + rng.nextDouble() * 65.0;
      canvas.drawCircle(Offset(cx, cy), r, _sp());
      final side = r * sqrt2;
      canvas.drawRect(
        Rect.fromCenter(center: Offset(cx, cy), width: side, height: side),
        _sp(_strokeAlpha * 0.75),
      );
    }

    // Katman 5: Parabol eğrileri — daha belirgin stroke
    for (int i = 0; i < 6; i++) {
      final path = Path();
      final sx = rng.nextDouble() * size.width * 0.5;
      final sy = size.height * (0.15 + rng.nextDouble() * 0.70);
      final span = 100.0 + rng.nextDouble() * 150.0;
      final depth = 55.0 + rng.nextDouble() * 110.0;
      final sign = rng.nextBool() ? 1.0 : -1.0;
      path.moveTo(sx, sy);
      path.quadraticBezierTo(sx + span / 2, sy - sign * depth, sx + span, sy);
      canvas.drawPath(path, _sp(_strokeAlpha * 1.15)..strokeWidth = 2.2);
    }
  }

  // ═══════════════════════════════════════════════════════════
  // ALİ KUŞÇU — Gökbilim, yörüngeler, yıldızlar
  // ═══════════════════════════════════════════════════════════
  void _aliKuscu(Canvas canvas, Size size, Random rng) {
    // === HERO: Büyük yörünge sistemi merkezde ===
    final heroC = Offset(size.width * 0.75, size.height * 0.25);
    for (int ring = 1; ring <= 7; ring++) {
      canvas.drawCircle(
        heroC,
        ring * size.shortestSide * 0.055,
        _sp(_strokeAlpha * (1.1 - ring * 0.08))..strokeWidth = 1.6,
      );
    }
    // Gezegen noktaları
    for (int p = 2; p <= 5; p++) {
      final a = p * 1.2;
      final r = p * size.shortestSide * 0.055;
      canvas.drawCircle(
        Offset(heroC.dx + cos(a) * r, heroC.dy + sin(a) * r),
        5.0 + p * 0.5,
        _fp(_fillAlpha * 1.6),
      );
    }

    // Katman 1: Gezegen yörünge sistemleri (iç içe daireler)
    for (int i = 0; i < 5; i++) {
      final cx = size.width * (0.15 + rng.nextDouble() * 0.70);
      final cy = size.height * (0.15 + rng.nextDouble() * 0.70);
      final base = 30.0 + rng.nextDouble() * 60.0;
      for (int ring = 1; ring <= 5; ring++) {
        canvas.drawCircle(Offset(cx, cy), base * ring,
            _sp(_strokeAlpha * (1.1 - ring * 0.12)));
      }
      final a = rng.nextDouble() * 2 * pi;
      final pPos = Offset(cx + cos(a) * base * 2.5, cy + sin(a) * base * 2.5);
      canvas.drawCircle(pPos, 6.0, _fp(_fillAlpha * 2.0));
    }

    // Katman 2: Yıldız sahası (daha fazla ve belirgin)
    for (int i = 0; i < 70; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final r = 1.5 + rng.nextDouble() * 6.5;
      canvas.drawCircle(
          Offset(x, y), r, _fp(_fillAlpha * (0.55 + rng.nextDouble())));
    }

    // Katman 3: 5 köşeli yıldız şekilleri (daha büyük)
    for (int i = 0; i < 11; i++) {
      final cx = rng.nextDouble() * size.width;
      final cy = rng.nextDouble() * size.height;
      final outerR = 16.0 + rng.nextDouble() * 46.0;
      _drawStar(canvas, Offset(cx, cy), outerR, outerR * 0.40, 5,
          _sp(_strokeAlpha * (0.80 + rng.nextDouble() * 0.45))
            ..strokeWidth = 2.0);
    }

    // Katman 4: Takımyıldız çizgileri
    final pts = List.generate(
        18,
        (_) =>
            Offset(rng.nextDouble() * size.width, rng.nextDouble() * size.height));
    for (int i = 0; i < pts.length - 1; i += 2) {
      canvas.drawLine(pts[i], pts[i + 1],
          _sp(_strokeAlpha * 0.65)..strokeWidth = 1.2);
    }

    // Katman 5: Astronomi sembol metinleri (daha büyük)
    final astro = ['☽', '☆', '✦', 'α', 'β', 'δ', 'γ', 'θ', '∠', '°', '☀', '♃'];
    for (int i = 0; i < 18; i++) {
      final x = rng.nextDouble() * size.width * 0.90;
      final y = rng.nextDouble() * size.height * 0.90;
      _txt(canvas, astro[rng.nextInt(astro.length)], Offset(x, y),
          20.0 + rng.nextDouble() * 46.0,
          alpha: _textAlpha * (0.60 + rng.nextDouble() * 0.55));
    }
  }

  // ═══════════════════════════════════════════════════════════
  // İBN-İ SİNA — Tıp, kitaplar, bitkiler, el yazmaları
  // ═══════════════════════════════════════════════════════════
  void _ibniSina(Canvas canvas, Size size, Random rng) {
    // === HERO: Büyük tıp sembolü sol üst ===
    _txt(canvas, '⚕', Offset(size.width * 0.02, size.height * 0.03),
        size.width * 0.18,
        alpha: _textAlpha * 1.1);
    _txt(canvas, 'الشفاء', Offset(size.width * 0.55, size.height * 0.05),
        size.width * 0.09,
        alpha: _textAlpha * 1.0);

    // Katman 1: Tıp sembolü büyük metinler
    final medSyms = ['⚕', '+', '✚'];
    for (int i = 0; i < 16; i++) {
      final x = rng.nextDouble() * size.width * 0.85;
      final y = rng.nextDouble() * size.height * 0.85;
      _txt(canvas, medSyms[rng.nextInt(medSyms.length)], Offset(x, y),
          42.0 + rng.nextDouble() * 75.0,
          angle: (rng.nextDouble() - 0.5) * pi / 8,
          alpha: _textAlpha * (0.60 + rng.nextDouble() * 0.55));
    }

    // Katman 2: Kitap şekilleri — daha kalın çizgiler
    for (int i = 0; i < 9; i++) {
      final x = rng.nextDouble() * size.width * 0.75;
      final y = rng.nextDouble() * size.height * 0.75;
      final w = 52.0 + rng.nextDouble() * 65.0;
      final h = w * 1.35;
      canvas.drawRect(Rect.fromLTWH(x, y, w, h),
          _sp()..strokeWidth = 2.0);
      canvas.drawLine(Offset(x + 10, y), Offset(x + 10, y + h),
          _sp(_strokeAlpha * 0.75));
      for (int ln = 1; ln <= 5; ln++) {
        canvas.drawLine(
          Offset(x + 17, y + h * 0.16 * ln),
          Offset(x + w - 6, y + h * 0.16 * ln),
          _sp(_strokeAlpha * 0.50),
        );
      }
    }

    // Katman 3: Yaprak / bitki şekilleri (daha fazla)
    for (int i = 0; i < 14; i++) {
      final cx = rng.nextDouble() * size.width;
      final cy = rng.nextDouble() * size.height;
      _drawLeaf(canvas, Offset(cx, cy), 20.0 + rng.nextDouble() * 45.0,
          rng.nextDouble() * 2 * pi);
    }

    // Katman 4: Nabız / EKG çizgisi
    for (int i = 0; i < 5; i++) {
      final sx = rng.nextDouble() * size.width * 0.42;
      final sy = size.height * (0.15 + rng.nextDouble() * 0.70);
      _drawPulse(canvas, Offset(sx, sy), 120.0 + rng.nextDouble() * 180.0);
    }

    // Katman 5: Arapça el yazması ifadeleri
    final scripts = ['الطب', 'القانون', 'الشفاء', 'Ibn Sina', 'Avicenna', 'Canon'];
    for (int i = 0; i < 8; i++) {
      final x = rng.nextDouble() * size.width * 0.78;
      final y = rng.nextDouble() * size.height * 0.78;
      _txt(canvas, scripts[rng.nextInt(scripts.length)], Offset(x, y),
          18.0 + rng.nextDouble() * 30.0,
          angle: (rng.nextDouble() - 0.5) * pi / 10,
          alpha: _textAlpha * 0.85);
    }
  }

  // ═══════════════════════════════════════════════════════════
  // ULUĞ BEY — Yıldız kataloğu, gök küresi, rasathane
  // ═══════════════════════════════════════════════════════════
  void _ulugBey(Canvas canvas, Size size, Random rng) {
    // === HERO: Merkezi büyük gök küresi ===
    final cx = size.width * 0.5;
    final cy = size.height * 0.5;
    final maxR = size.shortestSide * 0.46;
    for (int lat = 1; lat <= 7; lat++) {
      canvas.drawCircle(Offset(cx, cy), maxR * lat / 7,
          _sp(_strokeAlpha * (0.45 + lat * 0.10))..strokeWidth = lat == 7 ? 2.2 : 1.5);
    }
    for (int lon = 0; lon < 10; lon++) {
      final a = lon * pi / 10;
      canvas.drawLine(
        Offset(cx + cos(a) * maxR, cy + sin(a) * maxR),
        Offset(cx - cos(a) * maxR, cy - sin(a) * maxR),
        _sp(_strokeAlpha * 0.65)..strokeWidth = 1.2,
      );
    }

    // Katman 2: Yoğun yıldız sahası
    for (int i = 0; i < 75; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final r = 1.2 + rng.nextDouble() * 7.0;
      canvas.drawCircle(
          Offset(x, y), r, _fp(_fillAlpha * (0.50 + rng.nextDouble())));
    }

    // Katman 3: Takımyıldız bağlantıları
    final consPts = List.generate(20,
        (_) => Offset(rng.nextDouble() * size.width, rng.nextDouble() * size.height));
    for (int i = 0; i < consPts.length - 1; i += 3) {
      canvas.drawLine(consPts[i], consPts[i + 1],
          _sp(_strokeAlpha * 0.75)..strokeWidth = 1.2);
      if (i + 2 < consPts.length) {
        canvas.drawLine(consPts[i + 1], consPts[i + 2],
            _sp(_strokeAlpha * 0.75)..strokeWidth = 1.2);
      }
    }

    // Katman 4: Astrolab / kuadrant aleti — daha büyük
    for (int k = 0; k < 3; k++) {
      final ic = Offset(
        size.width * (0.12 + rng.nextDouble() * 0.76),
        size.height * (0.12 + rng.nextDouble() * 0.76),
      );
      final ir = 42.0 + rng.nextDouble() * 70.0;
      canvas.drawCircle(ic, ir, _sp(_strokeAlpha * 1.35)..strokeWidth = 2.0);
      canvas.drawCircle(ic, ir * 0.72, _sp(_strokeAlpha * 0.90));
      for (int d = 0; d < 12; d++) {
        final ang = d * pi / 6;
        canvas.drawLine(
          Offset(ic.dx + cos(ang) * ir * 0.72, ic.dy + sin(ang) * ir * 0.72),
          Offset(ic.dx + cos(ang) * ir, ic.dy + sin(ang) * ir),
          _sp(_strokeAlpha)..strokeWidth = 1.6,
        );
      }
    }

    // Katman 5: Koordinat ve açı metinleri
    final astroTxt = ['I', 'II', 'III', '0°', '30°', '60°', '90°', 'α', 'δ', 'RA', '☆', '✦'];
    for (int i = 0; i < 15; i++) {
      final x = rng.nextDouble() * size.width * 0.88;
      final y = rng.nextDouble() * size.height * 0.88;
      _txt(canvas, astroTxt[rng.nextInt(astroTxt.length)], Offset(x, y),
          14.0 + rng.nextDouble() * 26.0,
          alpha: _textAlpha * (0.60 + rng.nextDouble() * 0.50));
    }
  }

  // ═══════════════════════════════════════════════════════════
  // CAHİT ARF — Arf değişmezi, topoloji, cebirsel yapılar
  // ═══════════════════════════════════════════════════════════
  void _cahitArf(Canvas canvas, Size size, Random rng) {
    // === HERO: Köşede büyük Arf invariant formülü ===
    _txt(canvas, 'Arf(f)', Offset(size.width * 0.03, size.height * 0.03),
        size.width * 0.11,
        alpha: _textAlpha * 1.15);
    _txt(canvas, '∈ {0,1}', Offset(size.width * 0.03, size.height * 0.13),
        size.width * 0.08,
        alpha: _textAlpha * 0.95);

    // Katman 1: Arf formülleri (daha büyük ve belirgin)
    final formulas = [
      'Arf(f) ∈ {0,1}',
      'Arf(q) = 0',
      'Arf(q) = 1',
      'Z/2Z',
      'W(f) = Arf(f)',
      'q(x+y)−q(x)−q(y)',
      '∑ q(eᵢ)q(fᵢ)',
      'H²(M; Z/2)',
      'f: V → Z/2Z',
      'Arf İnvariantı',
    ];
    for (int i = 0; i < formulas.length; i++) {
      final x = rng.nextDouble() * size.width * 0.72;
      final y = rng.nextDouble() * size.height * 0.82;
      final fs = 17.0 + rng.nextDouble() * 32.0;
      final angle = (rng.nextDouble() - 0.5) * pi / 4;
      _txt(canvas, formulas[i], Offset(x, y), fs,
          angle: angle,
          alpha: _textAlpha * (0.70 + rng.nextDouble() * 0.45));
    }

    // Katman 2: Matematik sembolleri (daha fazla ve büyük)
    final syms = ['∈', '∑', '∏', '⊕', '⊗', '∧', '∨', '≡', '≃', '∂', '∇', 'λ', 'φ', 'ψ', '∞', 'Δ'];
    for (int i = 0; i < 28; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      _txt(canvas, syms[rng.nextInt(syms.length)], Offset(x, y),
          22.0 + rng.nextDouble() * 58.0,
          alpha: _textAlpha * (0.45 + rng.nextDouble() * 0.65));
    }

    // Katman 3: Topolojik eğriler (manifold hissi)
    for (int i = 0; i < 10; i++) {
      final path = Path();
      final x0 = rng.nextDouble() * size.width;
      final y0 = rng.nextDouble() * size.height;
      path.moveTo(x0, y0);
      path.cubicTo(
        x0 + rng.nextDouble() * 160 - 80,
        y0 + rng.nextDouble() * 160 - 80,
        x0 + rng.nextDouble() * 160 - 80,
        y0 + rng.nextDouble() * 160 - 80,
        x0 + rng.nextDouble() * 100 - 50,
        y0 + rng.nextDouble() * 100 - 50,
      );
      path.cubicTo(
        x0 + rng.nextDouble() * 160 - 80,
        y0 + rng.nextDouble() * 160 - 80,
        x0 + rng.nextDouble() * 160,
        y0 + rng.nextDouble() * 160 - 80,
        x0,
        y0,
      );
      canvas.drawPath(
          path, _sp(_strokeAlpha * (0.90 + rng.nextDouble() * 0.45))..strokeWidth = 2.2);
    }

    // Katman 4: İkili öğeler (Z/2Z bağlantısı)
    for (int i = 0; i < 22; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      _txt(canvas, rng.nextBool() ? '0' : '1', Offset(x, y),
          14.0 + rng.nextDouble() * 22.0,
          alpha: _textAlpha * 0.52);
    }

    // Katman 5: Halka şekilleri (cebirsel halkalar — daha büyük)
    for (int i = 0; i < 9; i++) {
      final cx = rng.nextDouble() * size.width;
      final cy = rng.nextDouble() * size.height;
      final r = 22.0 + rng.nextDouble() * 68.0;
      canvas.drawCircle(Offset(cx, cy), r, _sp()..strokeWidth = 2.0);
      canvas.drawCircle(Offset(cx, cy), r * 0.58, _sp(_strokeAlpha * 0.68));
    }
  }

  // ═══════════════════════════════════════════════════════════
  // VARSAYILAN
  // ═══════════════════════════════════════════════════════════
  void _defaultBg(Canvas canvas, Size size, Random rng) {
    for (int i = 0; i < 22; i++) {
      final cx = rng.nextDouble() * size.width;
      final cy = rng.nextDouble() * size.height;
      final r = 30.0 + rng.nextDouble() * 90.0;
      canvas.drawCircle(Offset(cx, cy), r, _sp());
    }
  }

  // ─────────── YARDIMCI: N köşeli yıldız çiz ───────────
  void _drawStar(Canvas canvas, Offset center, double outerR, double innerR,
      int points, Paint paint) {
    final path = Path();
    for (int i = 0; i < points * 2; i++) {
      final angle = i * pi / points - pi / 2;
      final r = i.isEven ? outerR : innerR;
      final x = center.dx + cos(angle) * r;
      final y = center.dy + sin(angle) * r;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  // ─────────── YARDIMCI: Yaprak şekli çiz ───────────
  void _drawLeaf(Canvas canvas, Offset center, double sz, double angle) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    final path = Path()
      ..moveTo(0, -sz)
      ..quadraticBezierTo(sz * 0.72, -sz * 0.5, 0, 0)
      ..quadraticBezierTo(-sz * 0.72, -sz * 0.5, 0, -sz);
    canvas.drawPath(path, _fp(_fillAlpha * 1.5));
    canvas.drawLine(
        Offset(0, -sz), Offset(0, 0), _sp(_strokeAlpha * 0.90)..strokeWidth = 1.2);
    canvas.restore();
  }

  // ─────────── YARDIMCI: Nabız çizgisi çiz ───────────
  void _drawPulse(Canvas canvas, Offset start, double width) {
    final paint = _sp(_strokeAlpha * 1.05)..strokeWidth = 2.2;
    final path = Path();
    final seg = width / 7;
    path.moveTo(start.dx, start.dy);
    path.lineTo(start.dx + seg, start.dy);
    path.lineTo(start.dx + seg * 2, start.dy - 26);
    path.lineTo(start.dx + seg * 2.5, start.dy + 38);
    path.lineTo(start.dx + seg * 3, start.dy - 18);
    path.lineTo(start.dx + seg * 3.5, start.dy);
    path.lineTo(start.dx + width, start.dy);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ═══════════════════════════════════════════════════════════════════════════
// ÖN-PLAN OVERLAY PAINTER — içeriğin ÜSTÜNDE ama IgnorePointer içinde
// Sadece köşelere / kenarlara hafif dekoratif vurgu yapar
// Metinlerin okunabilirliğini bozmaz
// ═══════════════════════════════════════════════════════════════════════════
class _OverlayPainter extends CustomPainter {
  final String name;
  final Color primaryColor;
  final bool isDark;

  _OverlayPainter(this.name, this.primaryColor, this.isDark);

  double get _alpha => isDark ? 0.13 : 0.08;

  Paint _sp(double a) => Paint()
    ..color = primaryColor.withValues(alpha: a)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5;

  @override
  void paint(Canvas canvas, Size size) {
    if (name.contains('Harezmi')) {
      // Köşelere cebirsel süsler
      _cornerDecoration(canvas, size, '∑', Offset(size.width - 50, 10));
      _cornerDecoration(canvas, size, '√', Offset(10, size.height - 40));
    } else if (name.contains('Ali Ku')) {
      // Köşelere yıldız süsleri
      _drawSmallStar(canvas, Offset(size.width - 30, 30), 14);
      _drawSmallStar(canvas, Offset(30, size.height - 30), 10);
      _drawSmallStar(canvas, Offset(size.width - 20, size.height - 50), 8);
    } else if (name.contains('bn-i Sina') || name.contains('İbn')) {
      // Köşelere tıp/bitki süsleri
      _cornerDecoration(canvas, size, '⚕', Offset(size.width - 40, 8));
    } else if (name.contains('Ulu')) {
      // Köşelere koordinat çizgileri
      canvas.drawLine(
        Offset(0, size.height * 0.05),
        Offset(size.width * 0.12, size.height * 0.05),
        _sp(_alpha * 0.8),
      );
      canvas.drawLine(
        Offset(size.width * 0.88, size.height * 0.95),
        Offset(size.width, size.height * 0.95),
        _sp(_alpha * 0.8),
      );
    } else if (name.contains('Cahit') || name.contains('Arf')) {
      // Köşelere halka/sembol
      canvas.drawCircle(Offset(size.width - 25, 25), 18, _sp(_alpha));
      canvas.drawCircle(Offset(25, size.height - 25), 12, _sp(_alpha * 0.7));
    }
  }

  void _cornerDecoration(Canvas canvas, Size size, String text, Offset pos) {
    final tp = TextPainter(textDirection: TextDirection.ltr)
      ..text = TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 28,
          color: primaryColor.withValues(alpha: _alpha),
          fontWeight: FontWeight.bold,
        ),
      )
      ..layout();
    tp.paint(canvas, pos);
  }

  void _drawSmallStar(Canvas canvas, Offset center, double outerR) {
    final path = Path();
    for (int i = 0; i < 10; i++) {
      final angle = i * pi / 5 - pi / 2;
      final r = i.isEven ? outerR : outerR * 0.4;
      final x = center.dx + cos(angle) * r;
      final y = center.dy + sin(angle) * r;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, _sp(_alpha));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
