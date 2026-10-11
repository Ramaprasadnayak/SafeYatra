import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:safeyatra/providers/sos_animation_provider.dart';
import './sos_page.dart' show SosColors;

class SosAlertBanner extends StatefulWidget {
  final bool active;

  const SosAlertBanner({super.key, required this.active});

  @override
  State<SosAlertBanner> createState() => _SosAlertBannerState();
} 

class _SosAlertBannerState extends State<SosAlertBanner>
    with SingleTickerProviderStateMixin {
  static const _fade = Duration(milliseconds: 400);

  late final AnimationController _ctrl;
  late final SosAnimationProvider _provider;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _provider = context.read<SosAnimationProvider>();
    _provider.addListener(_onProviderChanged);
  }

  void _onProviderChanged() {
    if (_provider.playing && !_ctrl.isAnimating) {
      _ctrl.forward(from: 0).whenComplete(() {
        if (mounted) _provider.finish();
      });
    }
  }

  @override
  void dispose() {
    _provider.removeListener(_onProviderChanged);
    _ctrl.dispose();
    super.dispose();
  }

  Widget _content(SosColors c) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: c.red.withValues(alpha: 0.15),
          ),
          child: Icon(Icons.notifications_active, color: c.red, size: 34),
        ),
        const SizedBox(height: 14),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
            children: [
              TextSpan(text: "EMERGENCY ", style: TextStyle(color: c.textPrimary)),
              TextSpan(text: "SOS", style: TextStyle(color: c.red)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Your location and details will be shared\nwith emergency services.",
          textAlign: TextAlign.center,
          style: TextStyle(color: c.textSecondary, fontSize: 13, height: 1.4),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = SosColors.of(context);
    final playing = context.watch<SosAnimationProvider>().playing;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 1.4,
          colors: [c.red.withValues(alpha: 0.28), c.redDark],
        ),
        border: Border.all(color: c.red.withValues(alpha: 0.35)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedOpacity(
            opacity: playing ? 0.0 : 1.0,
            duration: _fade,
            curve: Curves.easeInOut,
            child: _content(c),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedOpacity(
                opacity: playing ? 1.0 : 0.0,
                duration: _fade,
                curve: Curves.easeInOut,
                child: Lottie.asset(
                  'assets/animations/email_animation.json',
                  controller: _ctrl,
                  fit: BoxFit.contain,
                  repeat: false,
                  onLoaded: (composition) {
                    _ctrl.duration = composition.duration;
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}