import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/level_node.dart';
import '../widgets/glass_container.dart';
import '../services/api_service.dart';
import 'lesson_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic>? _courses;
  Map<String, dynamic>? _userProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final profile = await _apiService.getUserProfile();
    final courses = await _apiService.getCourses();
    
    if (mounted) {
      setState(() {
        _userProfile = profile ?? {
          'profile': {
             'streak_days': 0,
             'total_xp': 0,
             'coins': 0,
             'hearts': 5,
          }
        };
        _courses = courses;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : Stack(
        children: [
          // Removed DotGridPainter to make it cleaner with AnimatedBackground
          
          RefreshIndicator(
            onRefresh: _loadData,
            color: const Color(0xFFA78BFA),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 80, 
                    left: 24, 
                    right: 24, 
                    bottom: 120
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildHeader(),
                      const SizedBox(height: 16),
                      _buildDynamicSnakePath(context),
                    ]),
                  ),
                ),
              ],
            ),
          ),
          
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildTopBar(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final profile = _userProfile?['profile'] ?? _userProfile ?? {};
    final streak = profile['streak_days'] ?? _userProfile?['streak_days'] ?? 0;
    final xp = profile['total_xp'] ?? _userProfile?['total_xp'] ?? 0;
    final coins = profile['coins'] ?? _userProfile?['coins'] ?? 0;
    final hearts = profile['hearts'] ?? _userProfile?['hearts'] ?? 5;

    final user = Supabase.instance.client.auth.currentUser;
    String displayName = 'Foydalanuvchi';
    String? avatarUrl = profile['avatar_url'];
    
    if (user != null) {
      if (user.userMetadata != null && user.userMetadata!['full_name'] != null) {
        displayName = user.userMetadata!['full_name'];
      } else if (user.email != null) {
        displayName = user.email!.split('@')[0];
      }
      if (avatarUrl == null || avatarUrl.isEmpty) {
        avatarUrl = user.userMetadata?['avatar_url'];
      }
    }

    return GlassContainer(
      blur: 15,
      opacity: 0.1,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16, 
        bottom: 16, 
        left: 12, 
        right: 12
      ),
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(24),
        bottomRight: Radius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: avatarUrl != null && avatarUrl.isNotEmpty
                        ? NetworkImage(avatarUrl)
                        : const AssetImage('assets/images/mascot.png') as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 2),
                ),
              ),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Salom,',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    displayName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              _buildStatBadge(Icons.local_fire_department_rounded, '$streak', Colors.orange),
              const SizedBox(width: 4),
              _buildStatBadge(Icons.star_rounded, '$xp', const Color(0xFFFFC107)),
              const SizedBox(width: 4),
              _buildStatBadge(Icons.monetization_on_rounded, '$coins', const Color(0xFFFFD700)),
              const SizedBox(width: 4),
              _buildStatBadge(Icons.favorite, '$hearts', const Color(0xFFFF4B4B)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBadge(IconData icon, String value, Color iconColor) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      borderRadius: BorderRadius.circular(20),
      opacity: 0.3,
      blur: 10,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 18),
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF1E2749),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    if (_courses == null || _courses!.isEmpty) {
      return const Text("Hozircha kurslar yo'q", style: TextStyle(fontSize: 20));
    }
    
    final firstCourse = _courses![0];
    final firstModule = (firstCourse['modules'] != null && firstCourse['modules'].isNotEmpty) 
        ? firstCourse['modules'][0] 
        : {'title': 'Boshlanish'};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          firstCourse['title'] ?? "Kurs",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w900,
            fontSize: 28,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          firstModule['title'] ?? "Modul",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildDynamicSnakePath(BuildContext context) {
    if (_courses == null || _courses!.isEmpty) return const SizedBox();
    
    final firstCourse = _courses![0];
    if (firstCourse['modules'] == null || firstCourse['modules'].isEmpty) return const SizedBox();
    
    final lessons = firstCourse['modules'][0]['lessons'] as List<dynamic>? ?? [];
    
    return SizedBox(
      height: 150.0 * lessons.length + 100,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Background Snake Line
          Positioned.fill(
            child: CustomPaint(
              painter: DynamicSnakePathPainter(
                color: Colors.white.withValues(alpha: 0.5),
                nodeCount: lessons.length,
              ),
            ),
          ),
          
          ...List.generate(lessons.length, (index) {
            final lesson = lessons[index];
            final isCompleted = lesson['is_completed'] == true;
            final isNext = index == 0 || (index > 0 && lessons[index-1]['is_completed'] == true && !isCompleted);
            final isLocked = !isCompleted && !isNext;
            
            final state = isCompleted ? LevelState.completed : (isNext ? LevelState.active : LevelState.locked);
            
            // Calculate zig-zag positions
            double leftOffset = MediaQuery.of(context).size.width / 2;
            if (index % 2 == 0) {
              leftOffset += 20;
            } else {
              leftOffset -= 100;
            }

            return Positioned(
              top: 20.0 + (index * 150.0),
              left: leftOffset,
              child: LevelNode(
                state: state,
                label: isNext ? lesson['title'] : '',
                icon: isCompleted ? Icons.star_rounded : (isNext ? Icons.code_rounded : Icons.lock_rounded),
                showTooltip: isNext,
                tooltipMessage: isNext ? "Davom etamiz!" : null,
                onTap: isLocked ? null : () {
                  // Wait for the lesson screen to pop, then refresh data
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LessonScreen(lessonId: lesson['id']),
                    ),
                  ).then((_) => _loadData());
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

class DynamicSnakePathPainter extends CustomPainter {
  final Color color;
  final int nodeCount;

  DynamicSnakePathPainter({required this.color, required this.nodeCount});

  @override
  void paint(Canvas canvas, Size size) {
    if (nodeCount == 0) return;
    
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 40
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(size.width / 2 + 50, 60);
    
    for (int i = 0; i < nodeCount - 1; i++) {
      if (i % 2 == 0) {
        path.cubicTo(
          size.width / 2 - 200, 150.0 + (i * 150), 
          size.width / 2 - 100, 200.0 + (i * 150), 
          size.width / 2 - 60, 210.0 + (i * 150)
        );
      } else {
        path.cubicTo(
          size.width / 2 + 200, 150.0 + (i * 150), 
          size.width / 2 + 100, 200.0 + (i * 150), 
          size.width / 2 + 50, 210.0 + (i * 150)
        );
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE5E0F5)
      ..style = PaintingStyle.fill;
      
    const spacing = 30.0;
    const radius = 1.5;
    
    for (double i = 0; i < size.width; i += spacing) {
      for (double j = 0; j < size.height; j += spacing) {
        canvas.drawCircle(Offset(i, j), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
