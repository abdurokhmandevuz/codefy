import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/glass_container.dart';
import '../services/api_service.dart';
import 'settings_screen.dart';
import 'pro_paywall_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final data = await _apiService.getUserProfile();
    final user = Supabase.instance.client.auth.currentUser;
    if (mounted) {
      setState(() {
        final apiFirstName = data?['first_name']?.toString().isNotEmpty == true ? data!['first_name'] : null;
        final apiLastName = data?['last_name']?.toString().isNotEmpty == true ? data!['last_name'] : null;
        final apiAvatarUrl = data?['profile']?['avatar_url']?.toString().isNotEmpty == true ? data!['profile']!['avatar_url'] : null;
        
        final fallbackName = user?.userMetadata?['full_name'] ?? 'Codefy';
        final fallbackAvatar = user?.userMetadata?['avatar_url'];
        
        _userData = {
          'first_name': apiFirstName ?? '',
          'last_name': apiLastName ?? '',
          'display_first_name': apiFirstName ?? fallbackName,
          'display_last_name': apiLastName ?? (apiFirstName == null ? 'Talabasi' : ''),
          'username': data?['username'],
          'profile': {
             'is_pro': data?['profile']?['is_pro'] ?? false,
             'experience_level': data?['profile']?['experience_level'] ?? 'Boshlang\'ich',
             'league': data?['profile']?['league'] ?? 'Bronza',
             'streak_days': data?['profile']?['streak_days'] ?? 0,
             'total_xp': data?['profile']?['total_xp'] ?? 0,
             'coins': data?['profile']?['coins'] ?? 0,
             'hearts': data?['profile']?['hearts'] ?? 5,
             'avatar_url': apiAvatarUrl ?? fallbackAvatar
          }
        };
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    await _apiService.logout();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
          icon: Icon(Icons.logout, color: theme.colorScheme.onSurfaceVariant),
          onPressed: _logout,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: theme.colorScheme.onSurfaceVariant),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen(userData: _userData)),
              ).then((_) => _loadProfile());
            },
          ),
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : _userData == null 
          ? Center(child: Text("Ma'lumot topilmadi", style: TextStyle(color: theme.colorScheme.onSurface)))
          : SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadProfile,
          color: const Color(0xFFA78BFA),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 100),
            child: Column(
              children: [
              // Avatar
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    GlassContainer(
                      width: 120,
                      height: 120,
                      opacity: 0.15,
                      blur: 15,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 3),
                      borderRadius: BorderRadius.circular(60),
                      child: ClipOval(
                        child: _userData?['profile']?['avatar_url'] != null
                            ? Image.network(_userData!['profile']!['avatar_url'], fit: BoxFit.cover)
                            : Image.asset('assets/images/mascot.png', fit: BoxFit.cover),
                      ),
                    ),
                    if (_userData?['profile']?['is_pro'] == true)
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
                            BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2)),
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
                '${_userData?['display_first_name'] ?? _userData?['username']} ${_userData?['display_last_name'] ?? ''}'.trim(),
                style: theme.textTheme.headlineLarge,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _userData?['profile']?['experience_level'] ?? 'Codefy Talabasi',
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(width: 8),
                  Container(width: 4, height: 4, decoration: BoxDecoration(color: theme.colorScheme.outlineVariant, shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Text(
                    _userData?['profile']?['league'] ?? "Bronza",
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
                  _buildStatCard(context, '${_userData?['profile']?['streak_days'] ?? 0}', 'KUNLIK SERIYA', Icons.local_fire_department, theme.colorScheme.error, theme.colorScheme.errorContainer),
                  _buildStatCard(context, '${_userData?['profile']?['total_xp'] ?? 0}', 'UMUMIY XP', Icons.bolt, theme.colorScheme.tertiary, theme.colorScheme.tertiaryContainer),
                  _buildStatCard(context, '${_userData?['profile']?['coins'] ?? 0}', 'TANGALAR', Icons.monetization_on, Colors.orange, Colors.orange.shade100),
                  _buildStatCard(context, '${_userData?['profile']?['hearts'] ?? 5}', 'YURAKCHALAR', Icons.favorite, Colors.red, Colors.red.shade100),
                ],
              ),
              const SizedBox(height: 32),
              
              if (_userData?['profile']?['is_pro'] != true)
              // Pro Banner
              GlassContainer(
                opacity: 0.2,
                blur: 15,
                padding: const EdgeInsets.all(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  children: [
                    // Watermark Rocket
                    Positioned(
                      right: -20,
                      bottom: -20,
                      child: Icon(
                        Icons.rocket_launch,
                        size: 120,
                        color: Colors.white.withValues(alpha: 0.1),
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
                                color: theme.colorScheme.primary,
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
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
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
                            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.8),
                            foregroundColor: Colors.white,
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
              
              if (_userData?['profile']?['is_pro'] != true)
              const SizedBox(height: 32),
            ],
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String value, String label, IconData icon, Color iconColor, Color iconBgColor) {
    final theme = Theme.of(context);
    
    return GlassContainer(
      opacity: 0.15,
      blur: 15,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: BorderRadius.circular(16),
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
              color: iconBgColor.withValues(alpha: 0.5),
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
}
