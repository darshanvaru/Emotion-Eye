import 'package:flutter/material.dart';

class GuidePage extends StatelessWidget {
  const GuidePage({super.key});

  static const Color primaryBlue = Color(0xFF001F54);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryBlue,
        title: const Text(
          'How Emotion Eye Works',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _introCard(),
            const SizedBox(height: 20),

            _sectionTitle('Getting Started'),
            _guideCard(
              icon: Icons.home_rounded,
              title: 'Home Screen',
              description:
              'When you launch Emotion Eye, you land on the Home screen. '
                  'From here, you can start emotion detection or explore features.',
            ),

            _guideCard(
              icon: Icons.camera_alt_rounded,
              title: 'Camera Permission',
              description:
              'Emotion Eye requires camera access to detect emotions. '
                  'Please allow camera permission when prompted. '
                  'If permission is denied permanently, enable it from system settings.',
            ),

            const SizedBox(height: 20),
            _sectionTitle('Detecting Your Emotion'),

            _guideCard(
              icon: Icons.face_retouching_natural,
              title: 'Open Camera',
              description:
              'Tap the camera option to open the Camera screen. '
                  'Make sure your face is clearly visible and well-lit.',
            ),

            _guideCard(
              icon: Icons.center_focus_strong,
              title: 'Capture Image',
              description:
              'Hold your phone steady and keep your face centered. '
                  'Use the capture button to take a photo for emotion detection.',
            ),

            _guideCard(
              icon: Icons.visibility_rounded,
              title: 'Best Results Tips',
              description:
              '• Ensure good lighting\n'
                  '• Avoid extreme angles\n'
                  '• Keep your face unobstructed\n'
                  '• Stay still while capturing',
            ),

            const SizedBox(height: 20),
            _sectionTitle('After Detection'),

            _guideCard(
              icon: Icons.analytics_rounded,
              title: 'View Detected Emotion',
              description:
              'After analysis, Emotion Eye shows your detected emotion along with confidence. '
                  'This helps you understand your current emotional state.',
            ),

            _guideCard(
              icon: Icons.refresh_rounded,
              title: 'Re-Analyze or Continue',
              description:
              'You can re-capture an image if needed or continue exploring suggestions and features.',
            ),

            const SizedBox(height: 20),
            _sectionTitle('Mood Boosters & Features'),

            _guideCard(
              icon: Icons.emoji_emotions_rounded,
              title: 'Mood Boosters',
              description:
              'Based on your detected emotion, Emotion Eye suggests mood-boosting features '
                  'to help you relax, focus, or uplift your mood.',
            ),

            _guideCard(
              icon: Icons.explore_rounded,
              title: 'Explore Features',
              description:
              'Use the suggested tools and features thoughtfully. '
                  'They are designed to improve emotional awareness and well-being.',
            ),

            const SizedBox(height: 20),
            _sectionTitle('Helpful Notes'),

            _guideCard(
              icon: Icons.info_outline_rounded,
              title: 'Important Tips',
              description:
              '• Emotion detection works best with clear facial visibility\n'
                  '• Results are indicative, not medical advice\n'
                  '• Use features regularly for better experience',
            ),

            const SizedBox(height: 28),
            Center(
              child: Text(
                'Thank you for using Emotion Eye 💙',
                style: TextStyle(
                  color: Colors.blueGrey.shade700,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _introCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Emotion Eye helps you understand your emotions using facial analysis '
              'and provides meaningful suggestions to improve your well-being. '
              'This guide will walk you through how to use the app effectively.',
          style: TextStyle(
            fontSize: 15,
            color: Colors.black.withValues(alpha: 0.75),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: primaryBlue,
        ),
      ),
    );
  }

  Widget _guideCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: primaryBlue.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: primaryBlue),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14.5,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
