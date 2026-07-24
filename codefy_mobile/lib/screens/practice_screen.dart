import 'package:flutter/material.dart';
import '../widgets/glass_container.dart';
import '../services/api_service.dart';

import 'practice_tasks_screen.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic>? _practiceCards;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final cards = await _apiService.getPracticeCards();
    if (mounted) {
      setState(() {
        _practiceCards = cards;
        _isLoading = false;
      });
    }
  }

  void _navigateToTasks(Map<String, dynamic> cardData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PracticeTasksScreen(cardData: cardData),
      ),
    ).then((_) {
      // Reload when coming back to update completed tasks
      _loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SafeArea(
      child: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : RefreshIndicator(
              onRefresh: _loadData,
              color: const Color(0xFFA78BFA),
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 120),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Header
                        Text(
                          'Amaliyot',
                          style: theme.textTheme.headlineLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "O'z mahoratingizni sinab ko'ring va bilimlaringizni mustahkamlang!",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFFE9D5FF),
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        if (_practiceCards == null || _practiceCards!.isEmpty)
                          const Center(
                            child: Text(
                              "Hozircha amaliyotlar yo'q",
                              style: TextStyle(color: Color(0xFFE9D5FF)),
                            ),
                          )
                        else
                          ..._practiceCards!.map((card) => Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: _buildPracticeCard(
                              context,
                              cardData: card,
                            ),
                          )),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildPracticeCard(BuildContext context, {
    required Map<String, dynamic> cardData,
  }) {
    final theme = Theme.of(context);
    final title = cardData['title'] ?? 'Noma\'lum';
    final description = cardData['description'] ?? '';
    final emoji = cardData['icon_emoji'] ?? '🚀';
    
    return GestureDetector(
      onTap: () => _navigateToTasks(cardData),
      child: GlassContainer(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFA78BFA).withValues(alpha: 0.2)),
              ),
              child: Center(
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFFE9D5FF),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              color: const Color(0xFFA78BFA).withValues(alpha: 0.6),
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}
