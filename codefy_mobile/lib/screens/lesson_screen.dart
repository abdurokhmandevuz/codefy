import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../widgets/btn_3d.dart';
import '../widgets/glass_container.dart';
import '../widgets/animated_background.dart';
import '../services/api_service.dart';
import 'lesson_complete_screen.dart';

class LessonScreen extends StatefulWidget {
  final int lessonId;
  const LessonScreen({super.key, required this.lessonId});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? _lessonData;
  bool _isLoading = true;
  bool _isSubmitting = false;
  String? _error;
  String? _feedbackError;
  int _hearts = 5;

  String? _selectedOption;
  final TextEditingController _codeController = TextEditingController();
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _loadLesson();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _loadLesson() async {
    try {
      final data = await _apiService.getLessonDetail(widget.lessonId);
      final userProfile = await _apiService.getUserProfile();
      int hearts = 5;
      if (userProfile != null) {
        final profile = userProfile['profile'] ?? userProfile;
        hearts = profile['hearts'] ?? 5;
      }

      if (mounted) {
        setState(() {
          _lessonData = data;
          _hearts = hearts;
          _isLoading = false;
          if (data != null && data['initial_code'] != null) {
            _codeController.text = data['initial_code'].toString();
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _submitAnswer() async {
    if (_lessonData == null || _isSubmitting) return;

    final String type = _lessonData!['type'] ?? 'theory';
    dynamic userAnswer;

    if (type == 'test') {
      if (_selectedOption == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Iltimos, javoblardan birini tanlang!')),
        );
        return;
      }
      userAnswer = _selectedOption;
    } else if (type == 'code') {
      userAnswer = _codeController.text;
    } else {
      userAnswer = null;
    }

    setState(() {
      _isSubmitting = true;
      _feedbackError = null;
    });

    try {
      final response = await _apiService.completeLesson(widget.lessonId, answer: userAnswer);

      if (response != null && response['success'] != false) {
        if (mounted) {
          final gainedXp = (response['gained_xp'] as num?)?.toInt() ?? _lessonData!['xp_reward'] ?? 10;
          final gainedCoins = (response['gained_coins'] as num?)?.toInt() ?? _lessonData!['coins_reward'] ?? 5;
          final userStats = response['user_stats'] as Map<String, dynamic>?;
          final nextLessonId = response['next_lesson_id'] as int?;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LessonCompleteScreen(
                gainedXp: gainedXp,
                gainedCoins: gainedCoins,
                userStats: userStats,
                nextLessonId: nextLessonId,
              ),
            ),
          );
        }
      } else {
        // Incorrect answer
        final String errorMsg = response?['message'] ?? "Noto'g'ri javob! Qaytadan urinib ko'ring.";
        final newHearts = await _apiService.decreaseHeart();

        if (mounted) {
          setState(() {
            _isSubmitting = false;
            _feedbackError = errorMsg;
            if (newHearts != null) {
              _hearts = newHearts;
            } else if (_hearts > 0) {
              _hearts--;
            }
          });

          _shakeController.forward(from: 0.0);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMsg),
              backgroundColor: Colors.redAccent,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _feedbackError = e.toString();
        });
        _shakeController.forward(from: 0.0);
      }
    }
  }

  Widget _buildLessonBody(ThemeData theme) {
    final String type = _lessonData!['type'] ?? 'theory';
    final String title = _lessonData!['title'] ?? 'Dars';
    final String content = _lessonData!['content'] ?? _lessonData!['description'] ?? '';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.headlineLarge?.copyWith(fontSize: 28, color: Colors.white),
          ),
          const SizedBox(height: 24),

          // Content Glass Card with Shake Animation on Error
          AnimatedBuilder(
            animation: _shakeController,
            builder: (context, child) {
              final offset = math.sin(_shakeController.value * math.pi * 4) * 12.0;
              return Transform.translate(
                offset: Offset(offset, 0),
                child: child,
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlassContainer(
                  padding: const EdgeInsets.all(20),
                  opacity: 0.15,
                  blur: 15,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                  child: Text(
                    content.isNotEmpty ? content : 'Dars matni mavjud emas.',
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.white,
                    ),
                  ),
                ),

                if (_feedbackError != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.redAccent),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.redAccent),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _feedbackError!,
                            style: const TextStyle(color: Colors.redAccent, fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Dynamic UI based on lesson type
                if (type == 'theory') ...[
                  if (_lessonData!['initial_code'] != null && _lessonData!['initial_code'].toString().trim().isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text('Misol kod:', style: theme.textTheme.titleMedium?.copyWith(color: Colors.white70)),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF262E51),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      child: Text(
                        _lessonData!['initial_code'],
                        style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 14, color: Color(0xFFD1D8FF)),
                      ),
                    ),
                  ],
                ] else if (type == 'test') ...[
                  const SizedBox(height: 24),
                  Text('Javobingizni tanlang:', style: theme.textTheme.titleMedium?.copyWith(color: Colors.white70)),
                  const SizedBox(height: 12),
                  ...(_lessonData!['options'] is List ? (_lessonData!['options'] as List) : []).map((opt) {
                    final optString = opt.toString();
                    final isSelected = _selectedOption == optString;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedOption = optString;
                            _feedbackError = null;
                          });
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF6C5CE7).withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? const Color(0xFFA78BFA) : Colors.white.withValues(alpha: 0.2),
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                                color: isSelected ? const Color(0xFFA78BFA) : Colors.white70,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  optString,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ] else if (type == 'code') ...[
                  const SizedBox(height: 24),
                  Text('Kodni yozing:', style: theme.textTheme.titleMedium?.copyWith(color: Colors.white70)),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2438),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: _codeController,
                      maxLines: 8,
                      minLines: 4,
                      onChanged: (_) {
                        if (_feedbackError != null) {
                          setState(() => _feedbackError = null);
                        }
                      },
                      style: const TextStyle(
                        fontFamily: 'JetBrains Mono',
                        fontSize: 15,
                        color: Color(0xFFD1D8FF),
                        height: 1.4,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '# Kodingizni shu yerga yozing...',
                        hintStyle: TextStyle(color: Colors.white38),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 120), // Bottom action area padding
        ],
      ),
    );
  }

  String _getActionButtonText() {
    final String type = _lessonData?['type'] ?? 'theory';
    if (type == 'test') return 'Tekshirish';
    if (type == 'code') return 'Kodni tekshirish';
    return 'Tugatish';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                  ? Center(child: Text('Xatolik: $_error', style: const TextStyle(color: Colors.white)))
                  : _lessonData == null
                      ? const Center(child: Text('Dars topilmadi', style: TextStyle(color: Colors.white)))
                      : Column(
                          children: [
                            // Top App Bar
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.close, color: theme.colorScheme.onSurfaceVariant),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: LinearProgressIndicator(
                                        value: 0.5,
                                        minHeight: 12,
                                        backgroundColor: theme.colorScheme.surfaceContainerHighest,
                                        valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.secondaryContainer),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Hearts count badge
                                  GlassContainer(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    borderRadius: BorderRadius.circular(16),
                                    opacity: 0.2,
                                    blur: 10,
                                    child: Row(
                                      children: [
                                        const Icon(Icons.favorite, color: Color(0xFFFF4B4B), size: 20),
                                        const SizedBox(width: 4),
                                        Text(
                                          '$_hearts',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Expanded(
                              child: _buildLessonBody(theme),
                            ),

                            // Bottom Action Area
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: GlassContainer(
                                padding: const EdgeInsets.all(24),
                                opacity: 0.1,
                                blur: 20,
                                border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.5))),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Btn3D(
                                    text: _isSubmitting ? 'Tekshirilmoqda...' : _getActionButtonText(),
                                    backgroundColor: theme.colorScheme.primary,
                                    shadowColor: const Color(0xFF4F00D0),
                                    textColor: theme.colorScheme.onPrimary,
                                    onPressed: () {
                                      if (!_isSubmitting) {
                                        _submitAnswer();
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
        ),
      ),
    );
  }
}
