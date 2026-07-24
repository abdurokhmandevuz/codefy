import 'package:flutter/material.dart';
import '../widgets/btn_3d.dart';
import 'main_screen.dart';

class LessonCompleteScreen extends StatelessWidget {
  final int gainedXp;
  final int gainedCoins;
  final Map<String, dynamic>? userStats;
  final int? nextLessonId;

  const LessonCompleteScreen({
    super.key,
    this.gainedXp = 10,
    this.gainedCoins = 5,
    this.userStats,
    this.nextLessonId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              
              // Mascot
              SizedBox(
                width: 200,
                height: 200,
                child: Image.asset(
                  'assets/images/mascot.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 32),
              
              // Headline
              Text(
                'Dars yakunlandi!',
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontSize: 32,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              
              // Motivational Text
              Text(
                'Ajoyib natija! Keyingi darsga tayyormisiz?',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              
              // Stats
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 32,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // XP Stat
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.star, color: theme.colorScheme.tertiaryContainer, size: 32),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '$gainedXp',
                            style: theme.textTheme.headlineMedium,
                          ),
                          Text(
                            'XP TOPLANDI',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    Container(
                      width: 1,
                      height: 80,
                      color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                    ),
                    
                    // Coins Stat
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD700).withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.monetization_on_rounded, color: Color(0xFFFFD700), size: 32),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '$gainedCoins',
                            style: theme.textTheme.headlineMedium,
                          ),
                          Text(
                            'TANGA QO\'SHILDI',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Action Button
              SizedBox(
                width: double.infinity,
                child: Btn3D(
                  text: 'Davom etish',
                  backgroundColor: theme.colorScheme.primary,
                  shadowColor: const Color(0xFF4F00D0),
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const MainScreen()),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
