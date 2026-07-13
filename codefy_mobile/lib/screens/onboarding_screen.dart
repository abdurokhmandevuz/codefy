import 'package:flutter/material.dart';
import '../widgets/btn_3d.dart';
import 'main_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _selectedIndex = -1;

  void _selectOption(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _continue() {
    if (_selectedIndex != -1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header with Progress
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurfaceVariant),
                        onPressed: () {},
                      ),
                      Text(
                        '1 / 1',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: 1.0,
                      minHeight: 12,
                      backgroundColor: theme.colorScheme.surfaceVariant,
                      valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 64),
                    // Mascot and Question
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: theme.colorScheme.surfaceVariant),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 0),
                              )
                            ],
                          ),
                          child: Text(
                            'Dasturlash tajribangiz qanday?',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineLarge?.copyWith(
                              fontSize: 28,
                              color: theme.colorScheme.onBackground,
                            ),
                          ),
                        ),
                        Positioned(
                          top: -64,
                          right: -10,
                          child: SizedBox(
                            width: 96,
                            height: 96,
                            child: Image.asset(
                              'assets/images/mascot.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    
                    // Options
                    _buildOption(
                      index: 0,
                      icon: Icons.child_care,
                      title: 'Yangi boshlovchi',
                      theme: theme,
                    ),
                    const SizedBox(height: 16),
                    _buildOption(
                      index: 1,
                      icon: Icons.school,
                      title: 'Asosiy bilimlarga ega',
                      theme: theme,
                    ),
                    const SizedBox(height: 16),
                    _buildOption(
                      index: 2,
                      icon: Icons.laptop_mac,
                      title: 'Tajribali',
                      theme: theme,
                    ),
                  ],
                ),
              ),
            ),
            
            // Bottom Button
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(top: BorderSide(color: theme.colorScheme.surfaceVariant)),
              ),
              child: SizedBox(
                width: double.infinity,
                child: Btn3D(
                  text: 'Davom etish',
                  backgroundColor: _selectedIndex != -1 ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
                  shadowColor: _selectedIndex != -1 ? const Color(0xFF4F00D0) : theme.colorScheme.outline,
                  onPressed: _selectedIndex != -1 ? _continue : () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required int index,
    required IconData icon,
    required String title,
    required ThemeData theme,
  }) {
    final isSelected = _selectedIndex == index;
    
    return GestureDetector(
      onTap: () => _selectOption(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.surfaceContainer : theme.colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border(
                  bottom: BorderSide(color: theme.colorScheme.primary, width: 6),
                  top: BorderSide(color: theme.colorScheme.primary, width: 2),
                  left: BorderSide(color: theme.colorScheme.primary, width: 2),
                  right: BorderSide(color: theme.colorScheme.primary, width: 2),
                )
              : Border(
                  bottom: BorderSide(color: theme.colorScheme.surfaceVariant, width: 6),
                  top: BorderSide(color: theme.colorScheme.surfaceVariant, width: 2),
                  left: BorderSide(color: theme.colorScheme.surfaceVariant, width: 2),
                  right: BorderSide(color: theme.colorScheme.surfaceVariant, width: 2),
                ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected ? theme.colorScheme.primaryContainer : theme.colorScheme.surfaceContainerHigh,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
                  width: 2,
                ),
              ),
              child: Center(
                child: isSelected
                    ? Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
