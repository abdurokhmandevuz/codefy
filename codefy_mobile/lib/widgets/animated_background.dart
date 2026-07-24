import 'package:flutter/material.dart';
import 'dart:math';

class AnimatedBackground extends StatefulWidget {
  final Widget child;

  const AnimatedBackground({super.key, required this.child});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base Deep Violet Gradient Background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF1E1B4B), // #1E1B4B 0%
                Color(0xFF3B2A6B), // #3B2A6B 50%
                Color(0xFF5B21B6), // #5B21B6 100%
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        
        // Animated Orbs (Deep Violet variations)
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: OrbsPainter(_controller.value),
              size: Size.infinite,
            );
          },
        ),
        
        // Content
        widget.child,
      ],
    );
  }
}

class OrbsPainter extends CustomPainter {
  final double progress;
  OrbsPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = const Color(0xFFC084FC).withValues(alpha: 0.3) // #C084FC
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 120);
      
    final paint2 = Paint()
      ..color = const Color(0xFF8B5CF6).withValues(alpha: 0.4) // #8B5CF6
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 150);

    final paint3 = Paint()
      ..color = const Color(0xFFA78BFA).withValues(alpha: 0.2) // #A78BFA
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 100);

    // Orb 1
    final dx1 = size.width * 0.2 + sin(progress * 2 * pi) * 100;
    final dy1 = size.height * 0.2 + cos(progress * 2 * pi) * 100;
    canvas.drawCircle(Offset(dx1, dy1), 150, paint1);

    // Orb 2
    final dx2 = size.width * 0.8 + cos(progress * 2 * pi + pi / 4) * 120;
    final dy2 = size.height * 0.7 + sin(progress * 2 * pi + pi / 4) * 120;
    canvas.drawCircle(Offset(dx2, dy2), 180, paint2);

    // Orb 3
    final dx3 = size.width * 0.5 + sin(progress * 2 * pi + pi) * 80;
    final dy3 = size.height * 0.5 + cos(progress * 2 * pi + pi) * 150;
    canvas.drawCircle(Offset(dx3, dy3), 130, paint3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
