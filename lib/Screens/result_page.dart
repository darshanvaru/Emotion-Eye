import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../Services/emotion_api_service.dart';
import 'main_camera.dart';

class ResultPage extends StatefulWidget {
  final XFile imageFile;

  const ResultPage({super.key, required this.imageFile});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  String mood = 'Detecting...';
  bool isLoading = true;
  TextEditingController responseController = TextEditingController();

  // Map emotions to emojis and colors
  final Map<String, Map<String, dynamic>> emotionData = {
    'happy': {'emoji': '😄', 'color': Colors.yellow.shade300, 'message': 'Looking cheerful today!'},
    'sad': {'emoji': '😢', 'color': Colors.blue.shade200, 'message': 'Feeling blue? That\'s okay too.'},
    'angry': {'emoji': '😠', 'color': Colors.red.shade300, 'message': 'Someone\'s fired up!'},
    'surprised': {'emoji': '😲', 'color': Colors.purple.shade200, 'message': 'Wow! That\'s unexpected!'},
    'neutral': {'emoji': '😐', 'color': Colors.grey.shade300, 'message': 'Keeping it cool and calm.'},
    'fear': {'emoji': '😨', 'color': Colors.indigo.shade200, 'message': 'It\'s okay to be scared sometimes.'},
    'disgust': {'emoji': '🤢', 'color': Colors.green.shade300, 'message': 'Not your cup of tea?'},
    'contempt': {'emoji': '😏', 'color': Colors.orange.shade300, 'message': 'Feeling superior, are we?'},
    'detecting...': {'emoji': '🔍', 'color': Colors.grey.shade200, 'message': 'Analyzing your expression...'},
    'error': {'emoji': '⚠️', 'color': Colors.red.shade100, 'message': 'Oops! Something went wrong.'},
  };

  @override
  void initState() {
    super.initState();
    _analyzeAndSave();
  }

  Future<void> _analyzeAndSave() async {
    try {
      // Get mood label from API
      final label = await EmotionApiService.getEmotion(widget.imageFile);

      setState(() {
        mood = label.toLowerCase();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        mood = 'error';
        isLoading = false;
      });
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final emotionInfo = emotionData[mood.toLowerCase()] ??
        {'emoji': '❓', 'color': Colors.grey.shade200, 'message': 'Interesting expression!'};

    return Scaffold(
      backgroundColor: emotionInfo['color'],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: emotionInfo['color'],
        title: Text('Your Mood Result',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87
            )
        ),
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedOpacity(
                opacity: isLoading ? 0.7 : 1.0,
                duration: const Duration(milliseconds: 500),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(
                          File(widget.imageFile.path),
                          height: 280,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    if (isLoading)
                      Container(
                        height: 280,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.black38,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                            SizedBox(height: 15),
                            Text(
                              'Analyzing your expression...',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Result container
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          emotionInfo['emoji'],
                          style: TextStyle(fontSize: 50),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Mood',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              Text(
                                isLoading ? 'Detecting...' : mood[0].toUpperCase() + mood.substring(1),
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      emotionInfo['message'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Save notes if entered
                              if (responseController.text.isNotEmpty) {
                                // Logic to save response
                              }

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const MainCamera()),
                              );
                            },
                            icon: Icon(Icons.camera_alt),
                            label: Text("Try Another Photo"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    TextButton.icon(
                      onPressed: () async {
                        // Get the image path from the widget
                        final String imagePath = widget.imageFile.path;

                        // Create a personalized message with the detected mood
                        final String emotionText = "I'm feeling ${mood[0].toUpperCase() + mood.substring(1)} today! ${emotionData[mood.toLowerCase()]?['emoji'] ?? ''}";

                        // Create a list of XFiles for sharing
                        final List<XFile> files = [XFile(imagePath)];

                        // Share both text and image
                        try {
                          await Share.shareXFiles(
                            files,
                            text: emotionText,
                            subject: 'My Current Mood',
                          );
                        } catch (e) {
                          debugPrint('Error sharing: $e');
                          // Show a snackbar or dialog to inform the user
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Could not share. Please try again.')),
                          );
                        }
                      },
                      icon: Icon(Icons.share),
                      label: Text("Share My Mood"),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Tips or suggestions based on mood
              if (!isLoading)
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Mood Tips 💡",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _getMoodTip(mood),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMoodTip(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
        return "Spread your joy! Research shows sharing positive emotions can boost your happiness even more.";
      case 'sad':
        return "It's okay to feel down sometimes. Consider gentle activities like a walk or calling a friend.";
      case 'angry':
        return "Try deep breathing for 2 minutes. Counting to 10 before reacting can help manage intense emotions.";
      case 'surprised':
        return "Unexpected moments can lead to new discoveries! Take a moment to process what surprised you.";
      case 'fear':
        return "Remember that courage isn't absence of fear, but moving forward despite it. You're stronger than you think!";
      case 'disgust':
        return "Our reactions can tell us about our boundaries. Consider what this feeling might be protecting you from.";
      case 'neutral':
        return "A calm mind is a powerful one. This balanced state is perfect for making decisions or meditation.";
      default:
        return "Every emotion gives us valuable information about ourselves and our needs.";
    }
  }
}