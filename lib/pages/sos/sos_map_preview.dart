import 'package:flutter/material.dart';

import './sos_page.dart' show SosColors;

class SosMapPreview extends StatelessWidget {
  final String centerLabel;

  const SosMapPreview({super.key, required this.centerLabel});

  @override
  Widget build(BuildContext context) {
    final c = SosColors.of(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: c.mapBackground),
        CustomPaint(painter: _GridPainter(lineColor: c.mapLine)),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _PulsingPin(),
              const SizedBox(height: 6),
              Text(
                centerLabel,
                style: TextStyle(
                  color: c.textPrimary,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 12,
          bottom: 12,
          child: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.55),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24),
            ),
            child: const Icon(Icons.my_location, color: Colors.white, size: 18),
          ),
        ),
      ],
    );
  }
}

class _PulsingPin extends StatefulWidget {
  const _PulsingPin();

  @override
  State<_PulsingPin> createState() => _PulsingPinState();
}

class _PulsingPinState extends State<_PulsingPin>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = SosColors.of(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final scale = 1 + (_controller.value * 0.6);
        final opacity = (1 - _controller.value).clamp(0.0, 1.0);
        return SizedBox(
          width: 70,
          height: 70,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: c.red.withValues(alpha: 0.35),
                    ),
                  ),
                ),
              ),
              child!,
            ],
          ),
        );
      },
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(color: c.red, shape: BoxShape.circle),
        child: const Icon(Icons.location_on, color: Colors.white, size: 20),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  final Color lineColor;

  const _GridPainter({required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 1;

    // A handful of diagonal-ish "streets" for visual texture.
    canvas.drawLine(Offset(0, size.height * 0.2), Offset(size.width, size.height * 0.35), linePaint);
    canvas.drawLine(Offset(0, size.height * 0.7), Offset(size.width, size.height * 0.55), linePaint);
    canvas.drawLine(Offset(size.width * 0.25, 0), Offset(size.width * 0.15, size.height), linePaint);
    canvas.drawLine(Offset(size.width * 0.7, 0), Offset(size.width * 0.85, size.height), linePaint);
    canvas.drawLine(Offset(0, size.height * 0.5), Offset(size.width, size.height * 0.5), linePaint);
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) =>
      oldDelegate.lineColor != lineColor;
}
