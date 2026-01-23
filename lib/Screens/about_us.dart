import 'package:flutter/material.dart';

import 'main_home_page.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('About Us', style: TextStyle(color: Colors.white),),
        backgroundColor: const Color(0xFF001F54),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionTitle(title: 'Core Team'),
              DeveloperTile(
                imagePath: 'assets/team/darshan.png',
                name: 'Darshan Varu - Flutter Developer',
                mail: 'darshanvaru2003@gmail.com',
                description:
                'Designed and developed the complete app including UI, flow, architecture, and core features.',
              ),
              DeveloperTile(
                imagePath: 'assets/team/smit.png',
                name: 'Smit Thaker - AI Expert',
                mail: 'smitthaker5151@gmail.com',
                description:
                'Designed and built the AI model responsible for emotion detection.',
              ),
              DeveloperTile(
                imagePath: 'assets/team/parv.png',
                name: 'Parv Ravasiya - Backend Developer',
                mail: 'parv.ravasiya.1210@gmail.com',
                description:
                'Handled backend APIs and supporting server-side logic.',
              ),
              SizedBox(height: 10),
              SectionTitle(title: 'Contributors'),
              DeveloperTile(
                imagePath: 'assets/team/tushir.png',
                name: 'Tushir Varu',
                mail: 'tushirprajapati@gmail.com',
                description:
                'Provided significant help and support during development.',
              ),
              DeveloperTile(
                imagePath: 'assets/team/yash.png',
                name: 'Yash Bhatti',
                mail: 'yashbhattti@gmail.com',
                description:
                'Assisted in development and testing phase',
              ),
              DeveloperTile(
                imagePath: 'assets/team/himanshu.png',
                name: 'Himanshu Karangiya',
                mail: 'karangiyahimanshu7@gmail.com',
                description:
                'Supported the team with valuable inputs and help.',
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withValues(alpha: 0.08),
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        color: Color(0xFFE3F2FD),
                        child: Padding(
                          padding: EdgeInsets.all(14.0),
                          child: Text(
                            '"Emotion Eye" exemplifies our mission: merging technology with human emotions, making it accessible and impactful for everyone.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(height: 18),
                      Text(
                        "As we continue to grow, our focus remains on pushing boundaries and making a positive impact through our work.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.blueGrey,
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
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF001F54),
        ),
      ),
    );
  }
}

class DeveloperTile extends StatelessWidget {
  final String imagePath;
  final String name;
  final String mail;
  final String description;

  const DeveloperTile({
    super.key,
    required this.imagePath,
    required this.name,
    required this.mail,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // 🔹 Background doodle
            Positioned.fill(
              child: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  'assets/patterns/doodle.png',
                  repeat: ImageRepeat.repeat,
                ),
              ),
            ),

            // 🔹 Foreground content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: AssetImage(imagePath),
                    backgroundColor: Color.fromRGBO(194, 200, 215, 1),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          mail,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueGrey.shade700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                            height: 1.4,
                          ),
                        ),
                      ],
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
