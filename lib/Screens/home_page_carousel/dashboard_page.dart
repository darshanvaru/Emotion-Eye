import 'package:emotioneye/Screens/exercise_detail_screen.dart';
import 'package:emotioneye/Widgets/MoodBoosterWidgets/angry/breathing_exercise_widget.dart';
import 'package:emotioneye/Widgets/activity_card.dart';
import 'package:emotioneye/Widgets/emotion_circular_carousel.dart';
import 'package:flutter/material.dart';

import '../../Widgets/MoodBoosterWidgets/sad/gratitude_journal_widget.dart';
import '../../model/exercise_model.dart';
import '../games_page.dart';
import '../goal_setting.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedEmotion = 2;

  String _findEmotion(emotionIndex) {
    switch (emotionIndex) {
      case 0:
        return "Neutral";
      case 1:
        return "Sad";
      case 2:
        return "Happy";
      case 3:
        return "Angry";
      case 4:
        return "Anxious";
      default:
        return "Happy";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300, // very light background
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05), // soft shadow (blur effect)
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: EmotionCircularCarousel(
                onSelected: (index) {
                  setState(() {
                    debugPrint("Selected Emotion: ${_findEmotion(index)} and Index: $index");
                    _selectedEmotion = index;
                  });
                },
              ),
            ),

            //Activities Section
            _activitiesBuilder(_findEmotion(_selectedEmotion)),

            //Exercise Section
            _exerciseBuilder(_findEmotion(_selectedEmotion)),

            //Quotes Section
            // _quotesBuilder()

            // Extra space at the bottom for better scrolling
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _activitiesBuilder(String emotion) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
      padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Activities For You',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
            crossAxisSpacing: 12, // Space between columns
            mainAxisSpacing: 12,  // Space between rows
            childAspectRatio: 1.5,  // Square tiles
            physics: const NeverScrollableScrollPhysics(), // Prevents scroll
            shrinkWrap: true, // Ensures it fits content height
            children: [
              ActivityCard(title: 'Games', icon: Icons.games, onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => GamesPage()));
              }),
              ActivityCard(title: 'Goal Setting', icon: Icons.track_changes, onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => GoalSettingPage()));
              }),
              ActivityCard(title: 'Breathing', icon: Icons.air, onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        Scaffold(
                            appBar: AppBar(title: Text("Breathing Exercise")),
                            body: Container(
                                padding: EdgeInsets.all(12.0),
                                margin: EdgeInsets.all(12.0),
                                child: BreathingExerciseWidget(
                                    colorScheme: ColorScheme(
                                        primary: Color(0xFF2196F3),
                                        secondary: Color(0xFF64B5F6),
                                        surface: Colors.white,
                                        error: Colors.red,
                                        onPrimary: Colors.white,
                                        onSecondary: Colors.white,
                                        onSurface: Colors.black,
                                        onError: Colors.white,
                                        brightness: Brightness.light
                                    )
                                )
                            )
                        )
                ));
              }),
              ActivityCard(title: 'Journaling', icon: Icons.book, onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        Scaffold(
                            appBar: AppBar(title: Text("Gratitude Journal")),
                            body: Container(
                                padding: EdgeInsets.all(12.0),
                                margin: EdgeInsets.all(12.0),
                                child: GratitudeJournalWidget(
                                    colorScheme: ColorScheme(
                                        primary: Color(0xFF2196F3),
                                        secondary: Color(0xFF64B5F6),
                                        surface: Colors.white,
                                        error: Colors.red,
                                        onPrimary: Colors.white,
                                        onSecondary: Colors.white,
                                        onSurface: Colors.black,
                                        onError: Colors.white,
                                        brightness: Brightness.light
                                    )
                                )
                            )
                        )
                ));
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _exerciseBuilder(String emotion) {
    final List<Exercise> exerciseList = exercise[emotion.toLowerCase()] ?? [];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical:5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recommended Exercises For You',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: exerciseList.length,
              itemBuilder: (context, index) {
                final Exercise ex = exerciseList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ExerciseDetailScreen(exercise: ex),
                    ));
                  },

                  // Exercise Card
                  child: Container(
                    width: 160,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [Color.fromARGB(255, 0, 31, 84), Colors.blueAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(2, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              ex.image,
                              height: 110,
                              width: 140,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            ex.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
