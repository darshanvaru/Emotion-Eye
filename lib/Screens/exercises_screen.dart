import 'package:flutter/material.dart';
import 'dart:ui';
import '../model/exercise_model.dart';
import 'exercise_detail_screen.dart';

class ExercisePage extends StatelessWidget {
  const ExercisePage({super.key});

  // Helper to capitalize emotion titles
  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 70.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: exercise.entries.map((entry) {
                return _buildEmotionSection(
                  context,
                  emotion: entry.key,
                  exercises: entry.value,
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmotionSection(
      BuildContext context, {
        required String emotion,
        required List<Exercise> exercises,
      }) {
    Color emotionColor = Color.fromARGB(255, 0, 31, 84);

    return Container(
      margin: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Emotion Header with blur effect
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 179, 201, 239),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: emotionColor.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getEmotionIcon(emotion),
                      color: emotionColor,
                      size: 28,
                    ),
                    SizedBox(width: 12),
                    Text(
                      _capitalize(emotion),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: emotionColor.withValues(alpha: 0.9),
                        letterSpacing: 0.5,
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: emotionColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${exercises.length} ${exercises.length == 1 ? 'Exercise' : 'Exercises'}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: emotionColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 12),
          // Exercises List
          ...exercises.map((ex) {
            return _buildExerciseCard(
              context,
              exercise: ex,
              emotionColor: emotionColor,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(
      BuildContext context, {
        required Exercise exercise,
        required Color emotionColor,
      }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ExerciseDetailScreen(exercise: exercise),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.shade200,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Exercise Image
                Container(
                  decoration: BoxDecoration(
                    color: emotionColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      exercise.image,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                // Exercise Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        exercise.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Assign icons per emotion
  IconData _getEmotionIcon(String emotion) {
    switch (emotion) {
      case "happy":
        return Icons.sentiment_satisfied_alt;
      case "sad":
        return Icons.sentiment_dissatisfied;
      case "angry":
        return Icons.mood_bad;
      case "neutral":
        return Icons.sentiment_neutral;
      case "anxious":
        return Icons.sentiment_very_dissatisfied;
      default:
        return Icons.sentiment_neutral;
    }
  }
}
