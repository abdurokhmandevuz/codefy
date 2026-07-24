import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SettingsScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;
  const SettingsScreen({super.key, this.userData});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Map<String, dynamic>? _userData;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _userData = widget.userData;
  }

  void _showEditProfileDialog() {
    final firstNameController = TextEditingController(text: _userData?['first_name'] ?? '');
    final lastNameController = TextEditingController(text: _userData?['last_name'] ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: const Text('Profilni tahrirlash'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: 'Ism'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: 'Familiya'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Bekor qilish'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                // Update via API
                final success = await _apiService.updateUserProfile(
                  firstNameController.text,
                  lastNameController.text,
                );
                if (success && mounted) {
                  setState(() {
                    if (_userData == null) _userData = {};
                    _userData!['first_name'] = firstNameController.text;
                    _userData!['last_name'] = lastNameController.text;
                    _userData!['display_first_name'] = firstNameController.text.isEmpty ? 'Codefy' : firstNameController.text;
                    _userData!['display_last_name'] = lastNameController.text.isEmpty ? 'Talabasi' : lastNameController.text;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profil muvaffaqiyatli yangilandi!')),
                  );
                } else if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Xatolik yuz berdi. Iltimos qaytadan urining.')),
                  );
                }
              },
              child: const Text('Saqlash'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final avatarUrl = _userData?['profile']?['avatar_url'];
    final fullName = '${_userData?['display_first_name'] ?? ''} ${_userData?['display_last_name'] ?? ''}'.trim();
    final displayRole = _userData?['profile']?['experience_level'] ?? "O'quvchi";
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Sozlamalar',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: avatarUrl != null && avatarUrl.isNotEmpty
                            ? NetworkImage(avatarUrl)
                            : const AssetImage('assets/images/mascot.png') as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(color: theme.colorScheme.surfaceContainerHighest, width: 2),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fullName.isEmpty ? 'Foydalanuvchi' : fullName,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          displayRole,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: _showEditProfileDialog,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerLow,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.edit, color: theme.colorScheme.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // General Settings
              Text(
                'UMUMIY SOZLAMALAR',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  children: [
                    _buildSettingsItem(
                      context,
                      icon: Icons.notifications,
                      title: 'Bildirishnomalar',
                      trailing: Icon(Icons.chevron_right, color: theme.colorScheme.outline),
                    ),
                    Divider(height: 1, color: theme.colorScheme.surfaceContainerHighest),
                    _buildSettingsItem(
                      context,
                      icon: Icons.language,
                      title: 'Til',
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("O'zbek", style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                          Icon(Icons.chevron_right, color: theme.colorScheme.outline),
                        ],
                      ),
                    ),
                    Divider(height: 1, color: theme.colorScheme.surfaceContainerHighest),
                    _buildSettingsItem(
                      context,
                      icon: Icons.dark_mode,
                      title: 'Tungi rejim',
                      trailing: Switch(
                        value: false,
                        onChanged: (val) {},
                        activeThumbColor: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // Support Settings
              Text(
                "QO'LLAB-QUVVATLASH",
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: _buildSettingsItem(
                  context,
                  icon: Icons.help_center,
                  title: 'Yordam markazi',
                  trailing: Icon(Icons.chevron_right, color: theme.colorScheme.outline),
                ),
              ),
              const SizedBox(height: 32),
              
              // Logout Button
              GestureDetector(
                onTap: () async {
                  await _apiService.logout();
                  if (!context.mounted) return;
                  Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: theme.colorScheme.outlineVariant, width: 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, color: theme.colorScheme.error),
                      const SizedBox(width: 8),
                      Text(
                        'Tizimdan chiqish',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.error,
                          fontWeight: FontWeight.bold,
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
    );
  }

  Widget _buildSettingsItem(BuildContext context, {required IconData icon, required String title, required Widget trailing}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: theme.colorScheme.primary),
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
          trailing,
        ],
      ),
    );
  }
}
