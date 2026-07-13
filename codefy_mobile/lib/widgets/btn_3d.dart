import 'package:flutter/material.dart';

class Btn3D extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color shadowColor;
  final Color textColor;
  final Widget? icon;

  const Btn3D({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
    required this.shadowColor,
    this.textColor = Colors.white,
    this.icon,
  }) : super(key: key);

  @override
  State<Btn3D> createState() => _Btn3DState();
}

class _Btn3DState extends State<Btn3D> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        margin: EdgeInsets.only(top: _isPressed ? 4.0 : 0.0),
        padding: const EdgeInsets.only(bottom: 4.0),
        decoration: BoxDecoration(
          color: widget.shadowColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.transparent, width: 0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                widget.icon!,
                const SizedBox(width: 8),
              ],
              Text(
                widget.text.toUpperCase(),
                style: TextStyle(
                  color: widget.textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
