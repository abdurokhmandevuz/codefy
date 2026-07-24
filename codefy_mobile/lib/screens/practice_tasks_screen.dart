import 'package:flutter/material.dart';
import '../widgets/glass_container.dart';
import '../widgets/animated_background.dart';
import 'practice_solve_screen.dart';

class PracticeTasksScreen extends StatelessWidget {
  final Map<String, dynamic> cardData;

  const PracticeTasksScreen({super.key, required this.cardData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tasks = cardData['tasks'] as List<dynamic>? ?? [];

    return AnimatedBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            cardData['title'] ?? 'Amaliyot',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: tasks.isEmpty
            ? const Center(
                child: Text(
                  'Hozircha vazifalar yo\'q',
                  style: TextStyle(color: Color(0xFFE9D5FF), fontSize: 16),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  final bool isCompleted = task['is_completed'] == true;
                  final String diff = task['difficulty'] ?? 'easy';
                  
                  Color diffColor = Colors.green;
                  if (diff == 'medium') diffColor = Colors.orange;
                  if (diff == 'hard') diffColor = Colors.red;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PracticeSolveScreen(taskData: task),
                        ),
                      );
                    },
                    child: GlassContainer(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(20),
                      border: Border.all(
                        color: isCompleted 
                            ? Colors.green.withValues(alpha: 0.5) 
                            : const Color(0xFFA78BFA).withValues(alpha: 0.2),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: isCompleted ? Colors.green.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              isCompleted ? Icons.check_circle : Icons.code,
                              color: isCompleted ? Colors.green : Colors.white,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task['title'] ?? 'Vazifa',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: diffColor.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        diff.toUpperCase(),
                                        style: TextStyle(
                                          color: diffColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '+${task['xp_reward']} XP',
                                      style: const TextStyle(
                                        color: Color(0xFFFFDF92),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: Colors.white54,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
