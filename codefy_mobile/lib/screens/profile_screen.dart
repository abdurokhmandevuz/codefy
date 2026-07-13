import 'package:flutter/material.dart';
import '../widgets/btn_3d.dart';
import 'settings_screen.dart';
import 'pro_paywall_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        title: Text(
          'Profil',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu, color: theme.colorScheme.onSurfaceVariant),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: theme.colorScheme.onSurfaceVariant),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 100),
          child: Column(
            children: [
              // Avatar
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerLowest,
                        shape: BoxShape.circle,
                        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.1), width: 4),
                        boxShadow: [
                          BoxShadow(color: theme.colorScheme.primary.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10)),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset('assets/images/mascot.png', fit: BoxFit.cover),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerLowest,
                          shape: BoxShape.circle,
                          border: Border.all(color: theme.colorScheme.outlineVariant),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2)),
                          ],
                        ),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.tertiary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.workspace_premium, color: theme.colorScheme.onTertiary, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Name and Info
              Text(
                'Jahongir Q.',
                style: theme.textTheme.headlineLarge,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Codefy Talabasi',
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(width: 8),
                  Container(width: 4, height: 4, decoration: BoxDecoration(color: theme.colorScheme.outlineVariant, shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Text(
                    "A'zo: 2023",
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // Stats Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2.2,
                children: [
                  _buildStatCard(context, '12', 'KUNLIK SERIYA', Icons.local_fire_department, theme.colorScheme.error, theme.colorScheme.errorContainer),
                  _buildStatCard(context, '4,520', 'UMUMIY XP', Icons.bolt, theme.colorScheme.tertiary, theme.colorScheme.tertiaryContainer),
                  _buildStatCard(context, '#3', 'ENG YAXSHI NATIJA', Icons.emoji_events, theme.colorScheme.primary, theme.colorScheme.surfaceContainerHigh),
                  _buildStatCard(context, '48', 'DARSLAR', Icons.school, theme.colorScheme.onSecondaryContainer, theme.colorScheme.secondaryContainer),
                ],
              ),
              const SizedBox(height: 32),
              
              // Pro Banner
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(24),
                  border: Border(bottom: BorderSide(color: theme.colorScheme.onPrimaryFixedVariant, width: 6)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10)),
                  ],
                ),
                child: Stack(
                  children: [
                    // Watermark Rocket
                    Positioned(
                      right: -20,
                      bottom: -20,
                      child: Icon(
                        Icons.rocket_launch,
                        size: 120,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.stars, color: theme.colorScheme.tertiaryFixed, size: 24),
                            const SizedBox(width: 8),
                            Text(
                              "Pro-ga o'tish",
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.only(right: 60),
                          child: Text(
                            "Cheksiz imkoniyatlar va reklamasiz o'rganish tajribasini oching.",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primaryFixedDim,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ProPaywallScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.surfaceContainerLowest,
                            foregroundColor: theme.colorScheme.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text('BATAFSIL', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Achievements Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Muvaffaqiyatlar',
                    style: theme.textTheme.headlineMedium?.copyWith(fontSize: 20),
                  ),
                  Text(
                    'BARCHASI',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                child: Row(
                  children: [
                    _buildAchievementCard(context, 'Olovli Boshlanish', '7 kun uzluksiz kirdingiz', Icons.local_fire_department, theme.colorScheme.errorContainer, theme.colorScheme.error, false),
                    const SizedBox(width: 16),
                    _buildAchievementCard(context, 'Kod Yozuvchi', '10 ta darsni tugatdingiz', Icons.code, theme.colorScheme.tertiaryContainer, theme.colorScheme.onTertiaryContainer, false),
                    const SizedBox(width: 16),
                    _buildAchievementCard(context, 'Tun Boyqushi', '0/1 Tunda dars o\'tish', Icons.lock, theme.colorScheme.surfaceVariant, theme.colorScheme.outline, true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String value, String label, IconData icon, Color iconColor, Color iconBgColor) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.surfaceVariant),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Watermark Icon
          Positioned(
            right: -10,
            bottom: -10,
            child: Icon(
              icon,
              size: 60,
              color: iconBgColor.withOpacity(0.5),
            ),
          ),
          // Content
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      value,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      label,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildAchievementCard(BuildContext context, String title, String subtitle, IconData icon, Color iconBgColor, Color iconColor, bool locked) {
    final theme = Theme.of(context);
    
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: locked ? theme.colorScheme.surfaceContainerLow : theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: locked ? theme.colorScheme.outlineVariant : theme.colorScheme.surfaceVariant,
        ),
        boxShadow: locked ? [] : [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
              border: locked ? Border.all(color: theme.colorScheme.outline, style: BorderStyle.solid) : null,
            ),
            child: Icon(icon, color: iconColor, size: 32),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
