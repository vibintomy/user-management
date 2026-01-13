
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

class CustomDotted extends StatelessWidget {
  const CustomDotted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: CustomPaint(
       
        painter: DottedBackground(),
      ),
    );
  }
}

class DottedBackground extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = AppColors.lightGreyBackground
      ..style = PaintingStyle.fill;

    const double dotRadius = 4.0;
    const double spacing = 35.0;

    const int rowCount = 4;
    const int columnCount = 4;

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
class CustomWaveBackground extends StatelessWidget {
  const CustomWaveBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(MediaQuery.of(context).size.width, 200),
      painter: WaveBackgroundPainter(),
    );
  }
}
class WaveBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.pink.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Start from bottom left
    path.moveTo(0, size.height * 1);
    
    // First wave - going up
    path.lineTo(size.width * 0.15, size.height * 0.6);
    
    // Second wave - going down then up
    path.lineTo(size.width * 0.3, size.height * 0.8);
    path.lineTo(size.width * 0.45, size.height * 0.4);
    
    // Third wave - going down then up
    path.lineTo(size.width * 0.6, size.height * 0.65);
    path.lineTo(size.width * 0.75, size.height * 0.25);
    
    // Final wave - going to top right
    path.lineTo(size.width, size.height * 0.3);
    
    // Complete the path to fill the bottom
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
class CustomColorSplash extends StatelessWidget {
  const CustomColorSplash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 200,
      child: CustomPaint(
        painter: ColorSplashPainter(),
      ),
    );
  }
}

class ColorSplashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.white
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final mainRadius = size.width * 0.35;

    // Draw main central blob with irregular edges
    final mainPath = Path();
    const int edgePoints = 60;
    
    for (int i = 0; i < edgePoints; i++) {
      final angle = (i / edgePoints) * 2 * math.pi;
      final nextAngle = ((i + 1) / edgePoints) * 2 * math.pi;
      
      // Add some randomness to the radius for irregular edges
      final random = math.Random(i);
      final radiusVariation = mainRadius * (0.9 + random.nextDouble() * 0.2);
      
      final x = center.dx + math.cos(angle) * radiusVariation;
      final y = center.dy + math.sin(angle) * radiusVariation;
      
      if (i == 0) {
        mainPath.moveTo(x, y);
      } else {
        // Use quadratic bezier for smooth curves
        final prevAngle = ((i - 1) / edgePoints) * 2 * math.pi;
        final controlAngle = (prevAngle + angle) / 2;
        final controlRadius = radiusVariation * 1.05;
        
        mainPath.quadraticBezierTo(
          center.dx + math.cos(controlAngle) * controlRadius,
          center.dy + math.sin(controlAngle) * controlRadius,
          x,
          y,
        );
      }
    }
    mainPath.close();
    canvas.drawPath(mainPath, paint);

    // Draw softer, more organic splashes
    final random = math.Random(42);
    
    // Large splashes
    _drawSoftSplash(canvas, paint, center, mainRadius, 0, 0.8, 12, 15, random);
    _drawSoftSplash(canvas, paint, center, mainRadius, math.pi / 3.5, 0.6, 10, 12, random);
    _drawSoftSplash(canvas, paint, center, mainRadius, math.pi / 2.2, 0.9, 14, 18, random);
    _drawSoftSplash(canvas, paint, center, mainRadius, math.pi / 1.3, 0.7, 11, 14, random);
    _drawSoftSplash(canvas, paint, center, mainRadius, math.pi, 0.85, 13, 16, random);
    _drawSoftSplash(canvas, paint, center, mainRadius, 4.3 * math.pi / 4, 0.65, 10, 13, random);
    _drawSoftSplash(canvas, paint, center, mainRadius, 3 * math.pi / 2, 0.75, 12, 15, random);
    _drawSoftSplash(canvas, paint, center, mainRadius, 1.85 * math.pi, 0.7, 11, 14, random);

    // Medium splashes
    _drawSoftSplash(canvas, paint, center, mainRadius, math.pi / 6, 0.5, 8, 10, random);
    _drawSoftSplash(canvas, paint, center, mainRadius, math.pi / 2.8, 0.55, 9, 11, random);
    _drawSoftSplash(canvas, paint, center, mainRadius, 2.3 * math.pi / 4, 0.5, 8, 10, random);
    _drawSoftSplash(canvas, paint, center, mainRadius, 3.2 * math.pi / 3, 0.6, 9, 12, random);
    _drawSoftSplash(canvas, paint, center, mainRadius, 5 * math.pi / 4, 0.55, 8, 11, random);
    _drawSoftSplash(canvas, paint, center, mainRadius, 1.65 * math.pi, 0.5, 8, 10, random);

    // Small droplets scattered around
    for (int i = 0; i < 10; i++) {
      final angle = (i * math.pi / 5) + (math.pi / 16) + (random.nextDouble() * 0.3);
      final distance = mainRadius * (1.6 + random.nextDouble() * 0.6);
      final dropletSize = 2.0 + random.nextDouble() * 3.5;
      
      final dropletPos = Offset(
        center.dx + math.cos(angle) * distance,
        center.dy + math.sin(angle) * distance,
      );
      
      canvas.drawCircle(dropletPos, dropletSize, paint);
    }

    // Extra tiny droplets
    for (int i = 0; i < 8; i++) {
      final angle = random.nextDouble() * 2 * math.pi;
      final distance = mainRadius * (2.0 + random.nextDouble() * 0.8);
      final dropletSize = 1.0 + random.nextDouble() * 2.5;
      
      final dropletPos = Offset(
        center.dx + math.cos(angle) * distance,
        center.dy + math.sin(angle) * distance,
      );
      
      canvas.drawCircle(dropletPos, dropletSize, paint);
    }
  }

  void _drawSoftSplash(Canvas canvas, Paint paint, Offset center, double mainRadius,
      double angle, double lengthFactor, double width, double height, math.Random random) {
    final distance = mainRadius * (1 + lengthFactor);
    
    final splashPath = Path();
    
    // Calculate positions
    final baseX = center.dx + math.cos(angle) * mainRadius * 0.85;
    final baseY = center.dy + math.sin(angle) * mainRadius * 0.85;
    
    final tipX = center.dx + math.cos(angle) * distance;
    final tipY = center.dy + math.sin(angle) * distance;
    
    final perpAngle = angle + math.pi / 2;
    
    // Create smooth, organic splash shape
    splashPath.moveTo(
      baseX + math.cos(perpAngle) * (width / 2),
      baseY + math.sin(perpAngle) * (width / 2),
    );
    
    // Left side curve to tip - smoother with multiple control points
    splashPath.cubicTo(
      baseX + math.cos(angle) * (distance * 0.3) + math.cos(perpAngle) * (width * 0.4),
      baseY + math.sin(angle) * (distance * 0.3) + math.sin(perpAngle) * (width * 0.4),
      tipX - math.cos(angle) * (height * 0.3) + math.cos(perpAngle) * (width * 0.15),
      tipY - math.sin(angle) * (height * 0.3) + math.sin(perpAngle) * (width * 0.15),
      tipX,
      tipY,
    );
    
    // Right side curve back to base - smoother
    splashPath.cubicTo(
      tipX - math.cos(angle) * (height * 0.3) - math.cos(perpAngle) * (width * 0.15),
      tipY - math.sin(angle) * (height * 0.3) - math.sin(perpAngle) * (width * 0.15),
      baseX + math.cos(angle) * (distance * 0.3) - math.cos(perpAngle) * (width * 0.4),
      baseY + math.sin(angle) * (distance * 0.3) - math.sin(perpAngle) * (width * 0.4),
      baseX - math.cos(perpAngle) * (width / 2),
      baseY - math.sin(perpAngle) * (width / 2),
    );
    
    splashPath.close();
    
    canvas.drawPath(splashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}