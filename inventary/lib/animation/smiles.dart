import 'dart:math' as math;
import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';

class SawCurveIntro extends StatefulWidget {
  const SawCurveIntro({
    super.key,
    this.duration = const Duration(milliseconds: 1600),
    this.sawSize = 84,
    this.strokeWidth = 16,
    this.color = const Color(0xFFF27A07), // naranja
    this.onFinished,
  });

  final Duration duration;
  final double sawSize;
  final double strokeWidth;
  final Color color;
  final VoidCallback? onFinished;

  @override
  State<SawCurveIntro> createState() => _SawCurveIntroState();
}

class _SawCurveIntroState extends State<SawCurveIntro>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _t; // 0..1 progreso

  Path? _cachedPath;

  Path _buildPath(Size size) {
    // === Ajusta estos puntos para calcar tu curva exacta ===
    final w = size.width;
    final h = size.height;

    // Inicio cerca de la sierra (izquierda)
    final start = Offset(w * 0.18, h * 0.55);

    // Primer tramo curvo
    final c1 = Offset(w * 0.28, h * 0.70);
    final c2 = Offset(w * 0.48, h * 0.48);
    final p1 = Offset(w * 0.38, h * 0.58);

    // Segundo tramo curvo
    final c3 = Offset(w * 0.58, h * 0.75);
    final c4 = Offset(w * 0.78, h * 0.52);
    final p2 = Offset(w * 0.68, h * 0.60);

    // Final suave
    final end = Offset(w * 0.88, h * 0.62);

    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, p1.dx, p1.dy)
      ..cubicTo(c3.dx, c3.dy, c4.dx, c4.dy, p2.dx, p2.dy)
      ..quadraticBezierTo(
        lerpDouble(p2.dx, end.dx, 0.5)!,
        lerpDouble(p2.dy, end.dy, 0.2)!,
        end.dx,
        end.dy,
      );

    return path;
  }

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: widget.duration);
    _t = CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);
    _c.forward().whenComplete(() => widget.onFinished?.call());
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final size = Size(constraints.maxWidth, constraints.maxHeight);
      _cachedPath ??= _buildPath(size);
      final path = _cachedPath!;

      return AnimatedBuilder(
        animation: _t,
        builder: (_, __) {
          final metric = path.computeMetrics().first;
          final distance = metric.length * _t.value;
          final tangent = metric.getTangentForOffset(distance)!;

          // Giro adicional como sierra (ajusta si quieres más/menos vueltas)
          final circumference = math.pi * widget.sawSize;
          final extraSpin = (distance / circumference) * 2 * math.pi;
          final angle = tangent.angle + extraSpin;

          final pos = tangent.position;
          final left = pos.dx - widget.sawSize / 2;
          final top = pos.dy - widget.sawSize / 2;

          return Stack(
            fit: StackFit.expand,
            children: [
              CustomPaint(
                painter: _LinePainter(path, widget.color, widget.strokeWidth),
              ),
              Positioned(
                left: left,
                top: top,
                child: Transform.rotate(
                  angle: angle,
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/saw2.png',
                    width: widget.sawSize,
                    height: widget.sawSize,
                  ),
                ),
              ),
            ],
          );
        },
      );
    });
  }
}

class _LinePainter extends CustomPainter {
  _LinePainter(this.path, this.color, this.strokeWidth);
  final Path path;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _LinePainter old) =>
      old.path != path ||
      old.color != color ||
      old.strokeWidth != strokeWidth;
}
