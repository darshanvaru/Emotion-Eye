import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// A widget that responds to detected emotional states with appropriate UI
/// and therapeutic interventions based on psychological principles.
class MoodResponseWidget extends StatefulWidget {
  final String detectedMood;
  final ValueChanged<String> onMoodImproved;

  const MoodResponseWidget({
    Key? key,
    required this.detectedMood,
    required this.onMoodImproved,
  }) : super(key: key);

  @override
  _MoodResponseWidgetState createState() => _MoodResponseWidgetState();
}

class _MoodResponseWidgetState extends State<MoodResponseWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Mood-specific color schemes based on color psychology
  final Map<String, ColorScheme> _moodColorSchemes = {
    'sad': ColorScheme(
      primary: Color(0xFF5DADE2),
      secondary: Color(0xFFF7DC6F),
      surface: Colors.white, // Very light blue
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.black,
      onError: Colors.white,
      brightness: Brightness.light,
    ),
    'angry': ColorScheme(
      primary: Color(0xFFE74C3C),
      secondary: Color(0xFF58D68D),
      surface: Colors.white, // Soft red
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.black,
      onError: Colors.white,
      brightness: Brightness.light,
    ),
    'anxious': ColorScheme(
      primary: Color(0xFF48C9B0),
      secondary: Color(0xFFAF7AC5),
      surface: Colors.white, // Very light teal
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.black,
      onError: Colors.white,
      brightness: Brightness.light,
    ),
    'happy': ColorScheme(
      primary: Color(0xFF2ECC71),
      secondary: Color(0xFFF39C12),
      surface: Colors.white, // Very light green
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.black,
      onError: Colors.white,
      brightness: Brightness.light,
    ),
  };

  // Evidence-based therapeutic messages and activities
  final Map<String, Map<String, dynamic>> _moodInterventions = {
    'sad': {
      'message': 'It\'s okay to feel sad sometimes. Let\'s try something to help.',
      'activity': 'Gratitude Journaling',
      'description': 'Write down three things you\'re grateful for today. Gratitude practice has been shown to improve mood.',
      'icon': Icons.import_contacts,
    },
    'angry': {
      'message': 'Take a deep breath. Let\'s calm your mind together.',
      'activity': 'Breathing Exercise',
      'description': 'Follow the circle to regulate your breathing. Deep breathing activates the parasympathetic nervous system.',
      'icon': Icons.air,
    },
    'anxious': {
      'message': 'You\'re safe right now. Let\'s ground yourself in the present.',
      'activity': '5-4-3-2-1 Grounding',
      'description': 'Name 5 things you see, 4 you feel, 3 you hear, 2 you smell, and 1 you taste. Grounding techniques reduce anxiety.',
      'icon': Icons.anchor,
    },
    'happy': {
      'message': 'Your happiness is contagious! Let\'s build on this positive energy.',
      'activity': 'Positive Reinforcement',
      'description': 'Write down what made you happy today to reinforce positive neural pathways.',
      'icon': Icons.emoji_emotions,
    },
  };

  @override
  void initState() {
    super.initState();

    // Animation setup for smooth entrance
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    // Start animation after build
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = _moodColorSchemes[widget.detectedMood.toLowerCase()] ??
        _moodColorSchemes['happy']!;
    final intervention = _moodInterventions[widget.detectedMood.toLowerCase()] ??
        _moodInterventions['happy']!;

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),

          // 1st Card
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Mood header with icon
              Row(
                children: [
                  Icon(
                    intervention['icon'],
                    color: colorScheme.primary,
                    size: 28,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'You seem ${widget.detectedMood.toLowerCase()}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Emotional validation message
              Text(
                intervention['message'],
                style: TextStyle(
                  fontSize: 16,
                  height: 1.4,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// /// Custom animated button for activities with built-in micro-interactions
// class _ActivityButton extends StatefulWidget {
//   final ColorScheme colorScheme;
//   final VoidCallback onPressed;
//
//   const _ActivityButton({
//     required this.colorScheme,
//     required this.onPressed,
//   });
//
//   @override
//   ActivityButtonState createState() => ActivityButtonState();
// }
//
// class ActivityButtonState extends State<_ActivityButton> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _scaleAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: Duration(milliseconds: 150),
//       vsync: this,
//     );
//     _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTapDown: (_) => _controller.forward(),
//       onTapUp: (_) {
//         _controller.reverse();
//         widget.onPressed();
//       },
//       onTapCancel: () => _controller.reverse(),
//       child: ScaleTransition(
//         scale: _scaleAnimation,
//         child: Container(
//           padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//           decoration: BoxDecoration(
//             color: widget.colorScheme.primary,
//             borderRadius: BorderRadius.circular(30),
//             boxShadow: [
//               BoxShadow(
//                 color: widget.colorScheme.primary.withValues(alpha: 0.3),
//                 blurRadius: 10,
//                 offset: Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Center(
//             child: Text(
//               'Start Activity',
//               style: TextStyle(
//                 color: widget.colorScheme.onPrimary,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }