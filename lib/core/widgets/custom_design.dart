
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:manage_x/core/constants/app_colors.dart';

class CustomTopDesign extends StatelessWidget {
  const CustomTopDesign({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(MediaQuery.of(context).size.width, 200),
      painter: TopDesignPainter(),
    );
  }
}

class TopDesignPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Left green circle
    final greenPaint = Paint()
      ..color = AppColors.green
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.08, size.height * 0.35),
      size.width * 0.12,
      greenPaint,
    );

    // Left blue-purple circle (behind green)
    final bluePurplePaint = Paint()
      ..color = AppColors.bluePurple
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.08, size.height * 0.65),
      size.width * 0.11,
      bluePurplePaint,
    );

    // Left cyan circle
    final cyanPaint = Paint()
      ..color = AppColors.cyan
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.18, size.height * 0.4),
      size.width * 0.13,
      cyanPaint,
    );

    // Right magenta circle
    final magentaPaint = Paint()
      ..color = AppColors.magenta
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.88, size.height * 0.35),
      size.width * 0.13,
      magentaPaint,
    );

    // Right dark blue circle (overlapping magenta)
    final darkBluePaint = Paint()
      ..color = AppColors.darkBlue
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.80, size.height * 0.65),
      size.width * 0.09,
      darkBluePaint,
    );
     final darkVioletPaint = Paint()
      ..color =AppColors.purple
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.92, size.height * 0.63),
      size.width * 0.12,
      darkVioletPaint,
    );

    // Draw geometric shapes with different colors and sizes
    final shapePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Purple Squares (Largest - size 12)
    shapePaint.color = AppColors.purple;
    _drawRotatedSquare(canvas, Offset(size.width * 0.35, size.height * 0.2), 12, shapePaint);
    _drawRotatedSquare(canvas, Offset(size.width * 0.52, size.height * 0.6), 12, shapePaint);
    _drawRotatedSquare(canvas, Offset(size.width * 0.65, size.height * 0.8), 12, shapePaint);
    _drawRotatedSquare(canvas, Offset(size.width * 0.85, size.height * 0.88), 11, shapePaint);

    // Blue Circles (Medium - radius 5)
    shapePaint.color = AppColors.blue;
    canvas.drawCircle(Offset(size.width * 0.42, size.height * 0.35), 5, shapePaint);
    canvas.drawCircle(Offset(size.width * 0.48, size.height * 0.75), 5, shapePaint);
    canvas.drawCircle(Offset(size.width * 0.58, size.height * 0.25), 5, shapePaint);
    canvas.drawCircle(Offset(size.width * 0.38, size.height * 0.65), 5, shapePaint);
    canvas.drawCircle(Offset(size.width * 0.12, size.height * 1), 5, shapePaint);

    // Gold Triangles (Smallest - size 8)
    shapePaint.color = AppColors.gold;
    _drawTriangle(canvas, Offset(size.width * 0.45, size.height * 0.15), 8, shapePaint);
    _drawTriangle(canvas, Offset(size.width * 0.55, size.height * 0.5), 8, shapePaint);
    _drawTriangle(canvas, Offset(size.width * 0.62, size.height * 0.85), 8, shapePaint);
    _drawTriangle(canvas, Offset(size.width * 0.36, size.height * 0.48), 8, shapePaint);
    _drawTriangle(canvas, Offset(size.width * 0.24, size.height * 0.88), 8, shapePaint);
  }

  void _drawRotatedSquare(Canvas canvas, Offset center, double size, Paint paint) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(math.pi / 4);
    canvas.drawRect(
      Rect.fromCenter(center: Offset.zero, width: size, height: size),
      paint,
    );
    canvas.restore();
  }

  void _drawTriangle(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    path.moveTo(center.dx, center.dy - size / 2); // Top point
    path.lineTo(center.dx - size / 2, center.dy + size / 2); // Bottom left
    path.lineTo(center.dx + size / 2, center.dy + size / 2); // Bottom right
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
class CustomTopRightCircles extends StatelessWidget {
  const CustomTopRightCircles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(150, 150),
      painter: TopRightCirclesPainter(),
    );
  }
}

class TopRightCirclesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Green circle (top left)
    final greenPaint = Paint()
      ..color = AppColors.lightGreen
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.35, size.height * 0.25),
      size.width * 0.25,
      greenPaint,
    );

    // Blue-purple circle (bottom left)
    final bluePurplePaint = Paint()
      ..color = AppColors.bluePurple
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.35, size.height * 0.55),
      size.width * 0.28,
      bluePurplePaint,
    );

    // Cyan circle (right side, partially cut off)
    final cyanPaint = Paint()
      ..color = AppColors.cyan
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.75, size.height * 0.4),
      size.width * 0.32,
      cyanPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
class CustomBottomRightDesign extends StatelessWidget {
  const CustomBottomRightDesign({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(200, 200), // ✅ fixed paint area
      painter: BottomRightDesignPainter(),
    );
  }
}

class BottomRightDesignPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.darkTeal
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width, size.height), // bottom-right corner
      size.width * 0.35,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
class CustomTopRightDesign extends StatelessWidget {
  const CustomTopRightDesign({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      width: 220,
      height: 160, 
      child: CustomPaint(
        painter: TopRightDesignPainter(),
        
      ),
    );
  }
}

class TopRightDesignPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.lightGreyBackground
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(
        size.width * 0.9,   // ➡ more horizontal push
        size.height * 0.5,  // ⬆ small vertical offset
      ),
      size.width * 1,    // radius based on width
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
class CustomBottomLeftDesign extends StatelessWidget {
  const CustomBottomLeftDesign({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      width: 220,
      height: 160,
      child: CustomPaint(
        painter: BottomLeftDesignPainter(),
      ),
    );
  }
}

class BottomLeftDesignPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.lightGreyBackground
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(
        size.width * 0.1,   // ⬅ more horizontal push
        size.height * 0.5,   // ⬇ subtle vertical offset
      ),
      size.width * 1,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}



class CustomDottedBackground extends StatelessWidget {
  const CustomDottedBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      width: 220,
      child: CustomPaint(
       
        painter: DottedBackgroundPainter(),
      ),
    );
  }
}

class DottedBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = AppColors.dottedGrey
      ..style = PaintingStyle.fill;

    const double dotRadius = 4.0;
    const double spacing = 35.0;

    const int rowCount = 6;
    const int columnCount = 6;

    // Starting offset (adjust if needed)
    const double startX = 20.0;
    const double startY = 20.0;

    for (int row = 0; row < rowCount; row++) {
      for (int col = 0; col < columnCount; col++) {
        final double x = startX + col * spacing;
        final double y = startY + row * spacing;

        canvas.drawCircle(Offset(x, y), dotRadius, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
