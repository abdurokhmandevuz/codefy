import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/glass_container.dart';
import '../services/api_service.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic>? _leaderboardData;
  bool _isLoading = true;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    final user = Supabase.instance.client.auth.currentUser;
    _currentUserId = user?.id;
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final data = await _apiService.getLeaderboard();
    if (mounted) {
      setState(() {
        _leaderboardData = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : RefreshIndicator(
                onRefresh: _loadData,
                color: const Color(0xFFA78BFA),
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 100),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          // Header
                          Text(
                            'Reyting',
                            style: theme.textTheme.headlineLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Eng faol o\'quvchilar',
                            style: theme.textTheme.bodyMedium?.copyWith(color: const Color(0xFFE9D5FF)),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          
                          if (_leaderboardData != null && _leaderboardData!.isNotEmpty) ...[
                            // Top 3 Podium
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Rank 2
                                if (_leaderboardData!.length > 1)
                                  _buildPodium(context, 2, _leaderboardData![1], 100, theme.colorScheme.outlineVariant),
                                if (_leaderboardData!.length > 1)
                                  const SizedBox(width: 8),
                                  
                                // Rank 1
                                _buildPodium(context, 1, _leaderboardData![0], 140, theme.colorScheme.tertiaryContainer),
                                
                                if (_leaderboardData!.length > 2)
                                  const SizedBox(width: 8),
                                // Rank 3
                                if (_leaderboardData!.length > 2)
                                  _buildPodium(context, 3, _leaderboardData![2], 80, theme.colorScheme.tertiary),
                              ],
                            ),
                            const SizedBox(height: 32),
                            
                            // Separator
                            Center(
                              child: Icon(Icons.more_vert, color: theme.colorScheme.outlineVariant, size: 20),
                            ),
                            const SizedBox(height: 16),
                            
                            // Build the rest of the list
                            ...List.generate(_leaderboardData!.length, (index) {
                              if (index < 3) return const SizedBox.shrink(); // Already in podium
                              final item = _leaderboardData![index];
                              final isCurrentUser = item['user']['id'].toString() == _currentUserId; // Need to handle ID match based on supabase logic
                              // Temporary simple match if using email or similar:
                              final bool currentUserMatch = isCurrentUser;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: _buildRankItem(context, index + 1, item, currentUserMatch),
                              );
                            }),
                          ] else
                            const Center(
                              child: Text(
                                "Hozircha ma'lumot yo'q",
                                style: TextStyle(color: Color(0xFFE9D5FF)),
                              ),
                            ),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildPodium(BuildContext context, int rank, dynamic item, double height, Color color) {
    final theme = Theme.of(context);
    final user = item['user'] ?? {};
    String name = user['first_name'] ?? user['username'] ?? 'Foydalanuvchi';
    if (name.isEmpty) name = 'Foydalanuvchi';
    final xp = item['total_xp'] ?? 0;
    
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 3),
            image: DecorationImage(
              image: NetworkImage(item['avatar_url'] ?? 'https://i.pravatar.cc/150?img=${rank * 10}'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(name, style: theme.textTheme.labelMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
        Text('$xp XP', style: theme.textTheme.labelSmall?.copyWith(color: const Color(0xFFE9D5FF))),
        const SizedBox(height: 8),
        Container(
          width: 80,
          height: height,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
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

  Widget _buildRankItem(BuildContext context, int rank, dynamic item, bool isCurrentUser) {
    final theme = Theme.of(context);
    final user = item['user'] ?? {};
    String name = user['first_name'] ?? user['username'] ?? 'Foydalanuvchi';
    if (name.isEmpty) name = 'Foydalanuvchi';
    final xp = item['total_xp'] ?? 0;

    return GlassContainer(
      padding: const EdgeInsets.all(16),
      opacity: isCurrentUser ? 0.9 : 0.15,
      border: isCurrentUser ? Border.all(color: Colors.white.withValues(alpha: 0.2)) : null,
      child: Container(
        decoration: isCurrentUser 
            ? BoxDecoration(
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(16),
              )
            : null,
        padding: isCurrentUser ? const EdgeInsets.all(16) : EdgeInsets.zero,
        child: Row(
          children: [
            SizedBox(
              width: 32,
              child: Text(
                rank.toString(),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
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
                color: theme.colorScheme.surfaceContainerHighest,
                image: DecorationImage(
                  image: NetworkImage(item['avatar_url'] ?? 'https://i.pravatar.cc/150?img=${rank * 5}'),
                  fit: BoxFit.cover,
                ),
                border: isCurrentUser ? Border.all(color: Colors.white, width: 2) : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isCurrentUser)
                    Text(
                      'Siz',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                ],
              ),
            ),
            Text(
              '$xp XP',
              style: theme.textTheme.titleMedium?.copyWith(
                color: isCurrentUser ? Colors.white : const Color(0xFFE9D5FF),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
