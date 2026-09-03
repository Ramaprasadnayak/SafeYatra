import 'package:flutter/material.dart';

class NoticeMenu extends StatefulWidget {
  final String district;

  const NoticeMenu({super.key, required this.district});

  @override
  State<NoticeMenu> createState() => _NoticeMenuState();
}

class _NoticeMenuState extends State<NoticeMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF101726),
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF101726),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.temple_hindu_outlined,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.district,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: const [
                        Icon(
                          Icons.location_on_outlined,
                          color: Colors.white70,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          " India",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24),
                ),
                child: const Icon(Icons.bookmark_border, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
