import 'package:flutter/material.dart';
import './sos_page.dart' show SosColors;

class SosMapPreview extends StatelessWidget {
  final String centerLabel;

  const SosMapPreview({
    super.key,
    required this.centerLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Light map background
        Container(
          color: const Color(0xFFEFF3F8),
        ),

        // Simple street/grid design
        CustomPaint(
          painter: _GridPainter(),
        ),

        // Current location
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _PulsingPin(),

              const SizedBox(height: 6),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  centerLabel,
                  style: const TextStyle(
                    color: SosColors.textPrimary,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Current location button
        Positioned(
          right: 12,
          bottom: 12,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black.withValues(alpha: 0.08),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.10),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.my_location,
              color: SosColors.blue,
              size: 18,
            ),
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final scale = 1 + (_controller.value * 0.6);

        final opacity =
            (1 - _controller.value).clamp(0.0, 1.0);

        return SizedBox(
          width: 70,
          height: 70,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Pulsing outer circle
              Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: SosColors.red.withValues(
                        alpha: 0.25,
                      ),
                    ),
                  ),
                ),
              ),

              // Main location pin
              child!,
            ],
          ),
        );
      },
      child: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          color: SosColors.red,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.location_on,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;

    final roadLinePaint = Paint()
      ..color = const Color(0xFFD5DCE6)
      ..strokeWidth = 1.5;

    // Main roads
    canvas.drawLine(
      Offset(0, size.height * 0.22),
      Offset(size.width, size.height * 0.38),
      roadPaint,
    );

    canvas.drawLine(
      Offset(0, size.height * 0.72),
      Offset(size.width, size.height * 0.55),
      roadPaint,
    );

    canvas.drawLine(
      Offset(size.width * 0.25, 0),
      Offset(size.width * 0.15, size.height),
      roadPaint,
    );

    canvas.drawLine(
      Offset(size.width * 0.70, 0),
      Offset(size.width * 0.85, size.height),
      roadPaint,
    );

    // Road center/detail lines
    canvas.drawLine(
      Offset(0, size.height * 0.22),
      Offset(size.width, size.height * 0.38),
      roadLinePaint,
    );

    canvas.drawLine(
      Offset(0, size.height * 0.72),
      Offset(size.width, size.height * 0.55),
      roadLinePaint,
    );

    canvas.drawLine(
      Offset(size.width * 0.25, 0),
      Offset(size.width * 0.15, size.height),
      roadLinePaint,
    );

    canvas.drawLine(
      Offset(size.width * 0.70, 0),
      Offset(size.width * 0.85, size.height),
      roadLinePaint,
    );

    // Smaller street lines
    canvas.drawLine(
      Offset(0, size.height * 0.50),
      Offset(size.width, size.height * 0.50),
      roadLinePaint,
    );

    canvas.drawLine(
      Offset(size.width * 0.45, 0),
      Offset(size.width * 0.55, size.height),
      roadLinePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

