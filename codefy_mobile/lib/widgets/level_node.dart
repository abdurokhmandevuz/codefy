import 'package:flutter/material.dart';

enum LevelState { locked, active, completed }

class LevelNode extends StatefulWidget {
  final LevelState state;
  final String label;
  final VoidCallback? onTap;
  final IconData icon;
  final bool showTooltip;
  final String? tooltipMessage;

  const LevelNode({
    Key? key,
    required this.state,
    required this.label,
    required this.icon,
    this.onTap,
    this.showTooltip = false,
    this.tooltipMessage,
  }) : super(key: key);

  @override
  State<LevelNode> createState() => _LevelNodeState();
}

class _LevelNodeState extends State<LevelNode> with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _bounceAnimation = Tween<double>(begin: 0, end: -8).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color shadowColor;
    Color iconColor;
    double nodeSize;

    switch (widget.state) {
      case LevelState.completed:
        bgColor = const Color(0xFF58CC02);
        shadowColor = Colors.transparent;
        iconColor = Colors.white;
        nodeSize = 70.0;
        break;
      case LevelState.active:
        bgColor = const Color(0xFF7C4DFF);
        shadowColor = const Color(0xFF5A2ABF); 
        iconColor = Colors.white;
        nodeSize = 80.0;
        break;
      case LevelState.locked:
      default:
        bgColor = const Color(0xFFD8D8E8);
        shadowColor = const Color(0xFFB0B0C0);
        iconColor = const Color(0xFF8B8B9E);
        nodeSize = 70.0;
        break;
    }

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // The node button
        GestureDetector(
          onTapDown: widget.state != LevelState.locked ? (_) => setState(() => _isPressed = true) : null,
          onTapUp: widget.state != LevelState.locked ? (_) {
            setState(() => _isPressed = false);
            if (widget.onTap != null) widget.onTap!();
          } : null,
          onTapCancel: () => setState(() => _isPressed = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            margin: EdgeInsets.only(top: _isPressed || widget.state == LevelState.completed ? 6.0 : 0.0),
            width: nodeSize,
            height: nodeSize,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
              boxShadow: [
                if (!_isPressed && widget.state != LevelState.completed)
                  BoxShadow(
                    color: shadowColor,
                    offset: const Offset(0, 6),
                  ),
              ],
            ),
            child: Center(
              child: Icon(
                widget.icon,
                color: iconColor,
                size: widget.state == LevelState.active ? 40 : 32,
              ),
            ),
          ),
        ),
        
        // Tooltip (combined with Mascot if desired, or just the bubble)
        if (widget.showTooltip)
          Positioned(
            left: -120, // Next to the node
            top: -20,
            child: AnimatedBuilder(
              animation: _bounceAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _bounceAnimation.value),
                  child: child,
                );
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Mascot Image
                  Image.asset(
                    'assets/images/mascot.png',
                    width: 60,
                    height: 60,
                  ),
                  // Tooltip Bubble
                  Positioned(
                    left: 50,
                    top: -10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.tooltipMessage != null)
                            Text(
                              widget.tooltipMessage!,
                              style: const TextStyle(
                                color: Color(0xFF1E2749),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          const SizedBox(height: 2),
                          Text(
                            widget.label,
                            style: const TextStyle(
                              color: Color(0xFF8B8B9E),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
