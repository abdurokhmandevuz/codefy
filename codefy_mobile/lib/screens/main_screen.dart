import 'dart:ui';
import 'package:flutter/material.dart';
import '../widgets/animated_background.dart';
import 'home_screen.dart';
import 'practice_screen.dart';
import 'games_screen.dart';
import 'leaderboard_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    PracticeScreen(),
    GamesScreen(),
    LeaderboardScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
            child: _buildBottomNav(context),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1B4B).withValues(alpha: 0.85), // rgba(30, 27, 75, 0.85)
        borderRadius: BorderRadius.circular(32),
        border: Border(
          top: BorderSide(
            color: const Color(0xFFA78BFA).withValues(alpha: 0.15), // rgba(167, 139, 250, 0.15)
            width: 1.0,
          ),
          left: BorderSide(color: const Color(0xFFA78BFA).withValues(alpha: 0.15)),
          right: BorderSide(color: const Color(0xFFA78BFA).withValues(alpha: 0.15)),
          bottom: BorderSide(color: const Color(0xFFA78BFA).withValues(alpha: 0.15)),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(context, Icons.school_rounded, 'O\'rganish', 0),
                _buildNavItem(context, Icons.bolt_rounded, 'Amaliyot', 1),
                _buildNavItem(context, Icons.sports_esports_rounded, 'O\'yinlar', 2),
                _buildNavItem(context, Icons.emoji_events_rounded, 'Reyting', 3),
                _buildNavItem(context, Icons.person_rounded, 'Profil', 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, int index) {
    final isActive = _currentIndex == index;
    final iconColor = isActive ? const Color(0xFFC084FC) : const Color(0xFF6B7280);
    final bgColor = isActive ? const Color(0xFFC084FC).withValues(alpha: 0.15) : Colors.transparent;
    final textColor = isActive ? const Color(0xFFC084FC) : const Color(0xFF6B7280);
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 8),
          height: 56, // Fixed height for all items
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 9,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
