import 'dart:math' as math;
import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import '../utils/color_palette.dart';

class SawCurveIntro extends StatefulWidget {
  const SawCurveIntro({
    super.key,
    this.duration = const Duration(milliseconds: 1600),
    this.sawSize = 150,
    this.strokeWidth = 21,
    this.color = AserraderoColorPalette.orange,
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
  Size? _lastSize;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: widget.duration);
    _t = CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);
    // Nota: NO arrancamos aquí. Lo haremos en didChangeDependencies
    // después de precargar la imagen y del primer frame.
  }

@override
void didChangeDependencies() {
  super.didChangeDependencies();
  precacheImage(const AssetImage('assets/saw2.png'), context).then((_) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted && !_c.isAnimating && _c.value == 0.0) {
        // 👇 Espera 200 ms antes de iniciar
        await Future.delayed(const Duration(milliseconds: 105));
        _c.forward().whenComplete(() => widget.onFinished?.call());
      }
    });
  });
}


  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Path _buildPath(Size size) {
    // === Ajusta estos puntos para calcar tu curva exacta ===
    final w = size.width;
    final h = size.height;

    final start = Offset(w * 0.20, h * 0.48);

    // Tramo 1 correcto (tal cual)
    final c1 = Offset(w * 0.30, h * 0.80);
    final c2 = Offset(w * 0.46, h * 0.84);
    final p1 = Offset(w * 0.48, h * 0.86);

    // Tramo 2 (igualado pero con p2 alto)
    final c3 = Offset(w * 0.55, h * 0.88); // espejo de c2 respecto a p1 (aprox)
    final c4 = Offset(w * 0.62, h * 0.86); // llegada parecida en “peso”
    final p2 = Offset(w * 0.68, h * 0.80);

    // Final
    final end = Offset(w * 0.85, h * 0.48);

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

  Path _buildOrUpdatePath(Size size) {
    if (_cachedPath == null || _lastSize != size) {
      _lastSize = size;
      _cachedPath = _buildPath(size);
    }
    return _cachedPath!;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final size = Size(constraints.maxWidth, constraints.maxHeight);
      final path = _buildOrUpdatePath(size);

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
            clipBehavior: Clip.none, // evita que se recorte la sierra grande
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
