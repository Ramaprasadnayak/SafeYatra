import 'package:flutter/material.dart';
import './sos_page.dart' show SosColors;

class SosMapPreview extends StatelessWidget {
  final String centerLabel;
  const SosMapPreview({super.key, required this.centerLabel});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: const Color(0xFF0D1424)),
        CustomPaint(painter: _GridPainter()),
        // const Positioned(top: 24, right: 20, child: _AreaLabel("HSR Layout")),
        // const Positioned(bottom: 30, left: 16, child: _AreaLabel("BTM Layout")),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _PulsingPin(),
              const SizedBox(height: 6),
              Text(
                centerLabel,
                style: const TextStyle(
                  color: SosColors.textPrimary,
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
              color: Colors.black.withOpacity(0.55),
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

class _AreaLabel extends StatelessWidget {
  final String text;
  const _AreaLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: SosColors.textSecondary, fontSize: 12),
    );
  }
}

class _PulsingPin extends StatefulWidget {
  @override
  State<_PulsingPin> createState() => _PulsingPinState();
}

class _PulsingPinState extends State<_PulsingPin> with SingleTickerProviderStateMixin {
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
                      color: SosColors.red.withOpacity(0.35),
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
        decoration: const BoxDecoration(color: SosColors.red, shape: BoxShape.circle),
        child: const Icon(Icons.location_on, color: Colors.white, size: 20),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.06)
      ..strokeWidth = 1;

    // A handful of diagonal-ish "streets" for visual texture.
    canvas.drawLine(Offset(0, size.height * 0.2), Offset(size.width, size.height * 0.35), linePaint);
    canvas.drawLine(Offset(0, size.height * 0.7), Offset(size.width, size.height * 0.55), linePaint);
    canvas.drawLine(Offset(size.width * 0.25, 0), Offset(size.width * 0.15, size.height), linePaint);
    canvas.drawLine(Offset(size.width * 0.7, 0), Offset(size.width * 0.85, size.height), linePaint);
    canvas.drawLine(Offset(0, size.height * 0.5), Offset(size.width, size.height * 0.5), linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
