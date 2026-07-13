import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 100),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Header
                  Text(
                    'Haftalik Reyting',
                    style: theme.textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Eng faol o\'quvchilar',
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  
                  // Top 3 Podium
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Rank 2
                      _buildPodium(context, 2, 'Dilnoza', '1180 XP', 100, theme.colorScheme.outlineVariant),
                      const SizedBox(width: 8),
                      // Rank 1
                      _buildPodium(context, 1, 'Azizbek', '1250 XP', 140, theme.colorScheme.tertiaryContainer),
                      const SizedBox(width: 8),
                      // Rank 3
                      _buildPodium(context, 3, 'Rustam', '1050 XP', 80, theme.colorScheme.tertiary),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // Separator
                  Center(
                    child: Icon(Icons.more_vert, color: theme.colorScheme.outlineVariant, size: 20),
                  ),
                  const SizedBox(height: 16),
                  
                  // Current User
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.colorScheme.primary),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Row(
                      children: [
                        Text(
                          '14',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: theme.colorScheme.onPrimaryContainer, width: 2),
                            image: const DecorationImage(
                              image: NetworkImage('https://i.pravatar.cc/150?img=11'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Siz',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Yana 50 XP yuqoriga chiqish uchun',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.primaryFixedDim,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '820 XP',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  // Separator
                  Center(
                    child: Icon(Icons.more_vert, color: theme.colorScheme.outlineVariant, size: 20),
                  ),
                  const SizedBox(height: 16),
                  
                  // Rank 15
                  _buildRankItem(context, 15, 'Gulnoza', '790 XP', false),
                  
                  const SizedBox(height: 24),
                  // Promotion Zone Warning
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.colorScheme.surfaceVariant),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.errorContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.warning_amber_rounded, color: theme.colorScheme.error),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pastroq ligaga tushish xavfi',
                                style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Siz xavfli hududdasiz. O'rningizni saqlab qolish uchun bugun darslarni yakunlang!",
                                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPodium(BuildContext context, int rank, String name, String xp, double height, Color color) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 3),
            image: DecorationImage(
              image: NetworkImage('https://i.pravatar.cc/150?img=${rank * 10}'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(name, style: theme.textTheme.labelMedium),
        Text(xp, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.primary)),
        const SizedBox(height: 8),
        Container(
          width: 80,
          height: height,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            border: Border(
              top: BorderSide(color: color, width: 4),
            ),
          ),
          child: Center(
            child: Text(
              rank.toString(),
              style: theme.textTheme.headlineMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRankItem(BuildContext context, int rank, String name, String xp, bool isCurrentUser) {
    final theme = Theme.of(context);
    return Container(
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
            width: 32,
            child: Text(
              rank.toString(),
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.surfaceVariant,
              image: DecorationImage(
                image: NetworkImage('https://i.pravatar.cc/150?img=${rank * 5}'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              name,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            xp,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.outline,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
