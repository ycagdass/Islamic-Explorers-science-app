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
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: _BackgroundPainter(
              scientistName,
              Theme.of(context).colorScheme.primary,
              isDark,
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  final String name;
  final Color primaryColor;
  final bool isDark;

  _BackgroundPainter(this.name, this.primaryColor, this.isDark);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor.withValues(alpha: isDark ? 0.05 : 0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final fillPaint = Paint()
      ..color = primaryColor.withValues(alpha: isDark ? 0.03 : 0.02)
      ..style = PaintingStyle.fill;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    void drawText(
      String text,
      Offset offset,
      double fontSize, {
      double angle = 0,
    }) {
      canvas.save();
      canvas.translate(offset.dx, offset.dy);
      canvas.rotate(angle);
      textPainter.text = TextSpan(
        text: text,
        style: TextStyle(
          fontSize: fontSize,
          color: primaryColor.withValues(alpha: isDark ? 0.06 : 0.04),
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset.zero);
      canvas.restore();
    }

    final random = Random(name.hashCode); // Consistent random based on name

    if (name.contains('Harezmi')) {
      // Numbers, algebra
      for (int i = 0; i < 20; i++) {
        final x = random.nextDouble() * size.width;
        final y = random.nextDouble() * size.height;
        final val = random.nextBool()
            ? "x = y² + ${random.nextInt(10)}"
            : "${random.nextInt(100)}";
        drawText(
          val,
          Offset(x, y),
          24 + random.nextDouble() * 40,
          angle: random.nextDouble() * pi,
        );
      }
      for (int i = 0; i < 10; i++) {
        final x = random.nextDouble() * size.width;
        final y = random.nextDouble() * size.height;
        final w = 50 + random.nextDouble() * 100;
        canvas.drawRect(Rect.fromLTWH(x, y, w, w), paint);
      }
    } else if (name.contains('Ali Kuşçu') || name.contains('Uluğ Bey')) {
      // Astronomy, stars, orbits
      for (int i = 0; i < 15; i++) {
        final center = Offset(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
        );
        final radius = 30 + random.nextDouble() * 120;
        canvas.drawCircle(center, radius, paint);
        if (random.nextBool()) {
          canvas.drawCircle(center, radius / 3, fillPaint);
        }
        // Draw some stars
        final starPath = Path();
        final starCenter = Offset(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
        );
        canvas.drawCircle(starCenter, 4 + random.nextDouble() * 8, fillPaint);
      }
    } else if (name.contains('İbn-i Sina')) {
      // Medicine, books, leaf-like shapes
      for (int i = 0; i < 12; i++) {
        final x = random.nextDouble() * size.width;
        final y = random.nextDouble() * size.height;
        drawText(
          "⚕",
          Offset(x, y),
          60 + random.nextDouble() * 80,
          angle: random.nextDouble() * pi / 4,
        );
      }
      for (int i = 0; i < 10; i++) {
        final x = random.nextDouble() * size.width;
        final y = random.nextDouble() * size.height;
        final width = 60 + random.nextDouble() * 80;
        final height = 40 + random.nextDouble() * 40;
        canvas.drawRect(Rect.fromLTWH(x, y, width, height), paint);
        canvas.drawLine(
          Offset(x, y + height / 2),
          Offset(x + width, y + height / 2),
          paint,
        );
      }
    } else if (name.contains('Cahit Arf')) {
      // Arf invariant, topology, manifolds
      for (int i = 0; i < 15; i++) {
        final x = random.nextDouble() * size.width;
        final y = random.nextDouble() * size.height;
        drawText(
          "Arf(q)",
          Offset(x, y),
          30 + random.nextDouble() * 50,
          angle: random.nextDouble() * pi,
        );
      }
      for (int i = 0; i < 8; i++) {
        final path = Path();
        path.moveTo(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
        );
        path.quadraticBezierTo(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
        );
        path.quadraticBezierTo(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
        );
        canvas.drawPath(path, paint);
      }
    } else {
      // Default abstract shapes
      for (int i = 0; i < 15; i++) {
        final x = random.nextDouble() * size.width;
        final y = random.nextDouble() * size.height;
        final rect = Rect.fromCenter(
          center: Offset(x, y),
          width: 50 + random.nextDouble() * 100,
          height: 50 + random.nextDouble() * 100,
        );
        canvas.drawOval(rect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
