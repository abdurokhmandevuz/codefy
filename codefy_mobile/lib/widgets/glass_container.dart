import 'dart:ui';
import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double? height;
  final BoxBorder? border;

  const GlassContainer({
    super.key,
    required this.child,
    this.blur = 12.0, // backdrop-filter: blur(12px)
    this.opacity = 0.06, // rgba(255, 255, 255, 0.06)
    this.padding,
    this.margin,
    this.borderRadius,
    this.width,
    this.height,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final defaultRadius = BorderRadius.circular(16); // border-radius: 16px
    
    return Container(
      margin: margin,
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? defaultRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            spreadRadius: 1,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? defaultRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: opacity),
              borderRadius: borderRadius ?? defaultRadius,
              border: border ?? Border.all(
                color: const Color(0xFFA78BFA).withValues(alpha: 0.25), // rgba(167, 139, 250, 0.25)
                width: 1.0,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
