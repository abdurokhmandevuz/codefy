import 'package:flutter/material.dart';
import '../widgets/btn_3d.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Mashq qilish',
                style: theme.textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                "O'z mahoratingizni sinab ko'ring va yangi bosqichlarga chiqing!",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              
              // Mascot Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.colorScheme.surfaceVariant),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 64,
                      height: 64,
                      child: Image.asset('assets/images/mascot.png', fit: BoxFit.contain),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Tayyormisiz?',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // Practice Cards
              _buildPracticeCard(
                context,
                title: 'Tezkor savollar',
                description: "Qisqa vaqt ichida ko'p savollarga javob berib, tezligingizni oshiring.",
                icon: Icons.timer,
                iconColor: theme.colorScheme.onTertiaryContainer,
                iconBgColor: theme.colorScheme.tertiaryContainer,
                badge: 'OSON',
                badgeColor: theme.colorScheme.secondaryContainer,
                badgeTextColor: theme.colorScheme.onSecondaryContainer,
              ),
              const SizedBox(height: 16),
              _buildPracticeCard(
                context,
                title: 'Xatolarni toping',
                description: "Kodda yashiringan xatolarni toping va ularni to'g'irlang.",
                icon: Icons.bug_report,
                iconColor: theme.colorScheme.onErrorContainer,
                iconBgColor: theme.colorScheme.errorContainer,
                badge: "O'RTACHA",
                badgeColor: theme.colorScheme.tertiaryContainer.withOpacity(0.5),
                badgeTextColor: theme.colorScheme.onTertiaryContainer,
              ),
              const SizedBox(height: 16),
              _buildPracticeCard(
                context,
                title: 'Algoritmlar',
                description: "Murakkab masalalarni yeching va mantiqiy fikrlashni rivojlantiring.",
                icon: Icons.psychology,
                iconColor: theme.colorScheme.onPrimaryContainer,
                iconBgColor: theme.colorScheme.primaryContainer,
                badge: 'QIYIN',
                badgeColor: theme.colorScheme.errorContainer,
                badgeTextColor: theme.colorScheme.onErrorContainer,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPracticeCard(BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String badge,
    required Color badgeColor,
    required Color badgeTextColor,
  }) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.surfaceVariant),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: iconColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.headlineMedium?.copyWith(fontSize: 20)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(16)),
                      child: Text(
                        badge,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: badgeTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(description, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: Btn3D(
              text: 'Boshlash',
              backgroundColor: theme.colorScheme.primary,
              shadowColor: const Color(0xFF4F00D0),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
