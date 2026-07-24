import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/btn_3d.dart';
import '../widgets/glass_container.dart';
import '../widgets/animated_background.dart';
import '../services/api_service.dart';
import 'package:lottie/lottie.dart';

class PracticeSolveScreen extends StatefulWidget {
  final Map<String, dynamic> taskData;

  const PracticeSolveScreen({super.key, required this.taskData});

  @override
  State<PracticeSolveScreen> createState() => _PracticeSolveScreenState();
}

class _PracticeSolveScreenState extends State<PracticeSolveScreen> with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  final TextEditingController _codeController = TextEditingController();
  
  bool _isChecking = false;
  bool _isAnswerChecked = false;
  bool _isCorrect = false;
  int _currentHearts = 5;
  int _coins = 0;
  bool _isLoadingHearts = true;

  // Quiz state
  String? _selectedOption;
  
  // Animations
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _codeController.text = widget.taskData['initial_code'] ?? '';
    _loadHearts();
    
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10, end: -10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -10, end: 10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10, end: -10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -10, end: 0), weight: 1),
    ]).animate(_shakeController);
  }

  Future<void> _loadHearts() async {
    final profile = await _apiService.getUserProfile();
    if (mounted) {
      setState(() {
        _currentHearts = profile?['hearts'] ?? 5;
        _coins = profile?['coins'] ?? 0;
        _isLoadingHearts = false;
      });
    }
  }

  void _shakeScreen() {
    HapticFeedback.heavyImpact();
    _shakeController.forward(from: 0);
  }

  void _showNoHeartsDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1B4B),
        title: const Text('Jonlar qolmadi!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text(
          'Jonlaringiz (??) tugadi. Ularni tiklash uchun 20 tanga sarflaysizmi? Sizda  tanga bor.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Keyinroq', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              setState(() {
                _isLoadingHearts = true;
              });
              final result = await _apiService.refillHearts();
              if (result != null && result['status'] == 'success') {
                setState(() {
                  _currentHearts = result['hearts'];
                  _coins = result['coins'];
                  _isLoadingHearts = false;
                });
                if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Jonlar muvaffaqiyatli tiklandi!'), backgroundColor: Colors.green),
                    );
                }
              } else {
                setState(() {
                  _isLoadingHearts = false;
                });
                if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tangalar yetarli emas yoki xatolik yuz berdi!'), backgroundColor: Colors.red),
                    );
                }
              }
            },
            child: const Text('20 Tanga sarflash', style: TextStyle(color: Color(0xFF84FB42), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _checkAnswer() async {
    final taskType = widget.taskData['task_type'] ?? 'code';

    if (taskType == 'theory') {
      await _apiService.completePracticeTask(widget.taskData['id']);
      if (mounted) Navigator.pop(context);
      return;
    }

    if (_currentHearts <= 0) {
      _showNoHeartsDialog();
      return;
    }

    setState(() {
      _isChecking = true;
    });

    bool correct = false;

    if (taskType == 'quiz') {
      final correctOption = widget.taskData['correct_option']?.toString().toUpperCase();
      correct = (_selectedOption == correctOption);
      await Future.delayed(const Duration(milliseconds: 500));
    } else {
      final userInput = _codeController.text.trim();
      final expectedOutput = widget.taskData['expected_output']?.toString().trim();
      correct = (userInput == expectedOutput);
      await Future.delayed(const Duration(seconds: 1));
    }
    
    if (correct && widget.taskData['is_completed'] != true) {
      await _apiService.completePracticeTask(widget.taskData['id']);
      widget.taskData['is_completed'] = true;
    } else if (!correct) {
      _shakeScreen();
      final newHearts = await _apiService.decreaseHeart();
      if (newHearts != null && mounted) {
        setState(() {
          _currentHearts = newHearts;
        });
      }
    }

    if (mounted) {
      setState(() {
        _isChecking = false;
        _isAnswerChecked = true;
        _isCorrect = correct;
      });
      
      if (!correct && _currentHearts <= 0) {
        Future.delayed(const Duration(milliseconds: 500), _showNoHeartsDialog);
      }
    }
  }

  Widget _buildTheoryContent(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Nazariya:",
          style: theme.textTheme.titleMedium?.copyWith(
            color: const Color(0xFFA78BFA),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GlassContainer(
          padding: const EdgeInsets.all(24),
          border: Border.all(color: const Color(0xFFA78BFA).withOpacity(0.3)),
          child: Text(
            widget.taskData["description"] ?? '',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white,
              height: 1.6,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuizContent(ThemeData theme) {
    final options = widget.taskData['options'] as Map<String, dynamic>? ?? {};
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Savol:',
          style: theme.textTheme.titleMedium?.copyWith(
            color: const Color(0xFFA78BFA),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.taskData['description'] ?? '',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: Colors.white,
            height: 1.5,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 32),
        ...options.entries.map((entry) {
          final isSelected = _selectedOption == entry.key;
          return GestureDetector(
            onTap: () {
              if (!_isAnswerChecked || !_isCorrect) {
                setState(() {
                  _selectedOption = entry.key;
                });
              }
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFA78BFA).withOpacity(0.3) : const Color(0xFF1E1B4B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? const Color(0xFFA78BFA) : Colors.white12,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFA78BFA) : Colors.white10,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        entry.key,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      entry.value.toString(),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildCodeContent(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shart:',
          style: theme.textTheme.titleMedium?.copyWith(
            color: const Color(0xFFA78BFA),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.taskData['description'] ?? '',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: Colors.white,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF1E1B4B),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFA78BFA).withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFFBA1A1A), shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFFF4BF00), shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFF84FB42), shape: BoxShape.circle)),
                    const Spacer(),
                    const Text(
                      'main.py',
                      style: TextStyle(color: Colors.white38, fontSize: 12, fontFamily: 'JetBrains Mono'),
                    ),
                  ],
                ),
              ),
              Container(height: 1, color: Colors.white10),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _codeController,
                  maxLines: 8,
                  style: const TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 14,
                    height: 1.5,
                    color: Color(0xFFD1D8FF),
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "// Kodingizni yozing...",
                    hintStyle: TextStyle(color: Colors.white24),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taskType = widget.taskData['task_type'] ?? 'code';
    
    bool isBtnEnabled = false;
    if (taskType == 'theory') isBtnEnabled = true;
    if (taskType == 'quiz') isBtnEnabled = _selectedOption != null;
    if (taskType == 'code') isBtnEnabled = _codeController.text.isNotEmpty;
    if (_currentHearts <= 0 && taskType != 'theory') isBtnEnabled = false;
    if (_isChecking || _isLoadingHearts) isBtnEnabled = false;

    String btnText = 'Tekshirish';
    if (_isLoadingHearts) btnText = 'Yuklanmoqda...';
    else if (_currentHearts <= 0 && taskType != 'theory') btnText = 'Jonlar qolmadi';
    else if (_isChecking) btnText = 'Tekshirilmoqda...';
    else if (taskType == 'theory') btnText = 'Tushunarli, Davom etish';
    
    return AnimatedBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.taskData['title'] ?? 'Dars',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(width: 12),
              if (!_isLoadingHearts)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.favorite, color: Colors.red, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '',
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        body: SafeArea(
          child: AnimatedBuilder(
            animation: _shakeAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_shakeAnimation.value, 0),
                child: child,
              );
            },
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (taskType == 'theory') _buildTheoryContent(theme),
                      if (taskType == 'quiz') _buildQuizContent(theme),
                      if (taskType == 'code') _buildCodeContent(theme),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
                
                Align(
                  alignment: Alignment.bottomCenter,
                  child: GlassContainer(
                    padding: const EdgeInsets.all(24),
                    opacity: 0.1,
                    blur: 20,
                    border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
                    child: SizedBox(
                      width: double.infinity,
                      child: Btn3D(
                        text: btnText,
                        backgroundColor: !isBtnEnabled ? Colors.grey : theme.colorScheme.primary,
                        shadowColor: !isBtnEnabled ? Colors.grey.shade700 : const Color(0xFF4F00D0),
                        textColor: !isBtnEnabled ? Colors.white54 : theme.colorScheme.onPrimary,
                        onPressed: !isBtnEnabled ? () {} : _checkAnswer,
                      ),
                    ),
                  ),
                ),
                
                if (_isAnswerChecked)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 32),
                      decoration: BoxDecoration(
                        color: _isCorrect ? theme.colorScheme.secondaryContainer : const Color(0xFFBA1A1A),
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 40, offset: const Offset(0, -10)),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: const BoxDecoration(color: Colors.white30, shape: BoxShape.circle),
                                          child: Icon(
                                            _isCorrect ? Icons.check : Icons.close,
                                            color: _isCorrect ? theme.colorScheme.onSecondaryContainer : Colors.white,
                                            size: 28,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          _isCorrect ? 'Ajoyib!' : "Noto'g'ri javob!",
                                          style: theme.textTheme.headlineMedium?.copyWith(
                                            fontWeight: FontWeight.w900,
                                            color: _isCorrect ? theme.colorScheme.onSecondaryContainer : Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      _isCorrect ? "+${widget.taskData['xp_reward']} XP ga ega bo'ldingiz!" : "Xato qildingiz! -1 ❤️ jon ayrildi.",
                                      style: theme.textTheme.bodyLarge?.copyWith(
                                        color: _isCorrect ? theme.colorScheme.onSecondaryContainer : Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 80,
                                height: 80,
                                child: Lottie.network(
                                  _isCorrect
                                      ? 'https://assets9.lottiefiles.com/packages/lf20_u4yrau.json' // Confetti
                                      : 'https://assets9.lottiefiles.com/packages/lf20_q7uarxsb.json', // Broken heart or sad animation
                                  repeat: false,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            child: Btn3D(
                              text: _isCorrect ? 'Davom etish' : 'Tushundim',
                              backgroundColor: Colors.white,
                              shadowColor: _isCorrect ? const Color(0xFFA3E635) : Colors.grey.shade400,
                              textColor: _isCorrect ? theme.colorScheme.secondary : Colors.red.shade900,
                              onPressed: () {
                                if (_isCorrect) {
                                  Navigator.pop(context);
                                } else {
                                  setState(() {
                                    _isAnswerChecked = false;
                                  });
                                }
                              },
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
      ),
    );
  }
}
