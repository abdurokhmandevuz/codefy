import 'package:flutter/material.dart';
import '../widgets/btn_3d.dart';
import 'lesson_complete_screen.dart';

class LessonScreen extends StatefulWidget {
  const LessonScreen({Key? key}) : super(key: key);

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  int _selectedOption = -1;
  bool _isAnswerChecked = false;
  bool _isCorrect = false;

  void _checkAnswer() {
    if (_selectedOption != -1) {
      setState(() {
        _isAnswerChecked = true;
        _isCorrect = _selectedOption == 1; // Option B is correct (15)
      });
    }
  }

  void _next() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LessonCompleteScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Top App Bar / Progress
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
                            value: 0.6,
                            minHeight: 12,
                            backgroundColor: theme.colorScheme.surfaceVariant,
                            valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.secondaryContainer),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.errorContainer.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.favorite, color: theme.colorScheme.error, size: 20),
                            const SizedBox(width: 4),
                            Text(
                              '4',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.error,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ushbu kod nima natija beradi?',
                          style: theme.textTheme.headlineLarge?.copyWith(fontSize: 28),
                        ),
                        const SizedBox(height: 24),
                        
                        // Code Block
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF262E51), // inverseSurface
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Mac window dots
                              Row(
                                children: [
                                  Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFFBA1A1A), shape: BoxShape.circle)),
                                  const SizedBox(width: 6),
                                  Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFFF4BF00), shape: BoxShape.circle)),
                                  const SizedBox(width: 6),
                                  Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFF84FB42), shape: BoxShape.circle)),
                                ],
                              ),
                              const SizedBox(height: 16),
                              RichText(
                                text: const TextSpan(
                                  style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 14, height: 1.5, color: Color(0xFFD1D8FF)),
                                  children: [
                                    TextSpan(text: 'let ', style: TextStyle(color: Color(0xFFCDBDFF))),
                                    TextSpan(text: 'x = '),
                                    TextSpan(text: '5', style: TextStyle(color: Color(0xFF87FE45))),
                                    TextSpan(text: ';\n'),
                                    
                                    TextSpan(text: 'let ', style: TextStyle(color: Color(0xFFCDBDFF))),
                                    TextSpan(text: 'y = '),
                                    TextSpan(text: '10', style: TextStyle(color: Color(0xFF87FE45))),
                                    TextSpan(text: ';\n'),
                                    
                                    TextSpan(text: 'console', style: TextStyle(color: Color(0xFFFFDF92))),
                                    TextSpan(text: '.'),
                                    TextSpan(text: 'log', style: TextStyle(color: Color(0xFFF4BF00))),
                                    TextSpan(text: '(x + y);'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        // Options
                        _buildOption(context, 0, 'A', '510'),
                        _buildOption(context, 1, 'B', '15'),
                        _buildOption(context, 2, 'C', 'Undefined'),
                        _buildOption(context, 3, 'D', 'Xato (Error)'),
                        const SizedBox(height: 120), // Bottom padding
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            // Bottom Action Area
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  border: Border(top: BorderSide(color: theme.colorScheme.outlineVariant)),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Btn3D(
                    text: 'Tekshirish',
                    backgroundColor: _selectedOption != -1 ? theme.colorScheme.primary : theme.colorScheme.surfaceVariant,
                    shadowColor: _selectedOption != -1 ? const Color(0xFF4F00D0) : theme.colorScheme.outlineVariant,
                    textColor: _selectedOption != -1 ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
                    onPressed: _selectedOption != -1 ? _checkAnswer : () {},
                  ),
                ),
              ),
            ),
            
            // Success Panel
            if (_isAnswerChecked)
              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 32),
                  decoration: BoxDecoration(
                    color: _isCorrect ? theme.colorScheme.secondaryContainer : theme.colorScheme.errorContainer,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 40, offset: const Offset(0, -10)),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(color: Colors.white30, shape: BoxShape.circle),
                                    child: Icon(
                                      _isCorrect ? Icons.check : Icons.close,
                                      color: _isCorrect ? theme.colorScheme.onSecondaryContainer : theme.colorScheme.onErrorContainer,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _isCorrect ? 'Ajoyib!' : 'Xato',
                                    style: theme.textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.w900,
                                      color: _isCorrect ? theme.colorScheme.onSecondaryContainer : theme.colorScheme.onErrorContainer,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _isCorrect ? "To'g'ri javob: 15" : "To'g'ri javob: 15",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: _isCorrect ? theme.colorScheme.onSecondaryContainer : theme.colorScheme.onErrorContainer,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: Btn3D(
                          text: 'Keyingisi',
                          backgroundColor: Colors.white,
                          shadowColor: _isCorrect ? const Color(0xFFA3E635) : theme.colorScheme.onErrorContainer.withOpacity(0.5),
                          textColor: _isCorrect ? theme.colorScheme.secondary : theme.colorScheme.error,
                          onPressed: _next,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context, int index, String letter, String text) {
    final theme = Theme.of(context);
    final isSelected = _selectedOption == index;
    
    return GestureDetector(
      onTap: () {
        if (!_isAnswerChecked) {
          setState(() {
            _selectedOption = index;
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primaryContainer.withOpacity(0.1) : theme.colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surfaceVariant,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? theme.colorScheme.primary.withOpacity(0.2) : theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  letter,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
