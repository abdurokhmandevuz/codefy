import 'package:flutter/material.dart';
import '../widgets/level_node.dart';
import 'lesson_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F0FB), // bg-primary
      body: Stack(
        children: [
          // Dot Grid Pattern Background
          Positioned.fill(
            child: CustomPaint(
              painter: DotGridPainter(),
            ),
          ),
          
          // Main content
          CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 80, 
                  left: 24, 
                  right: 24, 
                  bottom: 120
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildHeader(),
                    const SizedBox(height: 16),
                    _buildSnakePath(context),
                  ]),
                ),
              ),
            ],
          ),
          
          // Top Stats Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildTopBar(context),
          ),

        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      color: const Color(0xFFF3F0FB).withOpacity(0.95),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16, 
        bottom: 16, 
        left: 16, 
        right: 16
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStatBadge(Icons.local_fire_department, '12', const Color(0xFFFF9500)),
          const SizedBox(width: 12),
          _buildStatBadge(Icons.emoji_events, '450', const Color(0xFF4A90E2)),
          const SizedBox(width: 12),
          _buildStatBadge(Icons.favorite, '5', const Color(0xFFFF4B4B)),
        ],
      ),
    );
  }

  Widget _buildStatBadge(IconData icon, String value, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 6),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF1E2749),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "1-Bo'lim",
          style: TextStyle(
            color: Color(0xFF7C4DFF),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        SizedBox(height: 4),
        Text(
          "Dasturlash asoslari",
          style: TextStyle(
            color: Color(0xFF8B8B9E),
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildSnakePath(BuildContext context) {
    return SizedBox(
      height: 650,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Background Snake Line
          Positioned.fill(
            child: CustomPaint(
              painter: SnakePathPainter(
                color: const Color(0xFFD8D8E8),
              ),
            ),
          ),
          
          // Nodes from top to bottom
          Positioned(
            top: 20,
            left: MediaQuery.of(context).size.width / 2 + 30,
            child: const LevelNode(
              state: LevelState.completed,
              label: '',
              icon: Icons.star_rounded,
            ),
          ),
          
          Positioned(
            top: 150,
            left: MediaQuery.of(context).size.width / 2 - 120,
            child: const LevelNode(
              state: LevelState.completed,
              label: '',
              icon: Icons.star_rounded,
            ),
          ),

          // Bonus side activity node
          Positioned(
            top: 230,
            left: 20,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFD8D8E8), width: 3),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))
                ],
              ),
              child: const Icon(Icons.map_rounded, color: Color(0xFF4A90E2), size: 24),
            ),
          ),
          
          Positioned(
            top: 300,
            left: MediaQuery.of(context).size.width / 2 + 20,
            child: LevelNode(
              state: LevelState.active,
              label: "O'zgaruvchilar",
              icon: Icons.code_rounded,
              showTooltip: true,
              tooltipMessage: "Davom etamiz!",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LessonScreen()),
                );
              },
            ),
          ),
          
          Positioned(
            top: 450,
            left: MediaQuery.of(context).size.width / 2 - 100,
            child: const LevelNode(
              state: LevelState.locked,
              label: '',
              icon: Icons.lock_rounded,
            ),
          ),

          Positioned(
            top: 580,
            left: MediaQuery.of(context).size.width / 2 + 10,
            child: const LevelNode(
              state: LevelState.locked,
              label: '',
              icon: Icons.lock_rounded,
            ),
          ),
        ],
      ),
    );
  }


}

class SnakePathPainter extends CustomPainter {
  final Color color;

  SnakePathPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 40 // Thick rounded line
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(size.width / 2 + 60, 60);
    path.cubicTo(
      size.width / 2 - 250, 200, 
      size.width / 2 + 250, 400, 
      size.width / 2 - 60, 600
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE5E0F5)
      ..style = PaintingStyle.fill;
      
    const spacing = 30.0;
    const radius = 1.5;
    
    for (double i = 0; i < size.width; i += spacing) {
      for (double j = 0; j < size.height; j += spacing) {
        canvas.drawCircle(Offset(i, j), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
