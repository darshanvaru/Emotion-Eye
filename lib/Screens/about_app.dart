import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Emotion Detection',
      debugShowCheckedModeBanner: false,
      home: AboutApp(),
    );
  }
}

class AboutApp extends StatefulWidget {
  const AboutApp({super.key});
  @override
  State createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 0, 31, 84),
        automaticallyImplyLeading: true,
        title: const Text(
          "About App",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withValues(alpha: 0.08),
                blurRadius: 8,
                spreadRadius: 1,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ListView(
            children: [
              SizedBox(height: 18),
              Center(
                child: Icon(Icons.mood, size: 68, color: Colors.blueAccent),
              ),
              SizedBox(height: 10),
              Text(
                'Emotion Eye',
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 31, 84),
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Version: 4.0.1',
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 31, 84)),
                textAlign: TextAlign.center,
              ),
              Divider(height: 28, thickness: 1, color: Colors.grey[300]),
              Text(
                "Our app is designed to recognize and interpret emotions from facial expressions and boost it accordingly. Just capture a photo and our advanced machine learning model analysis the image to determine the emotion displayed and suggest activities to boost your mood.",
                style: TextStyle(fontSize: 16.0, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 14),
              ListTile(
                leading: Icon(Icons.photo_camera, color: Colors.blue[700]),
                title: Text("Simple photo capture for analysis"),
              ),
              ListTile(
                leading: Icon(Icons.insights, color: Colors.blue[700]),
                title: Text("Get instant emotional insights"),
              ),
              ListTile(
                leading: Icon(Icons.dashboard, color: Colors.blue[700]),
                title: Text("User-friendly, clean interface"),
              ),
              SizedBox(height: 20),
              Card(
                color: Colors.blue[50],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Emotion Eye brings emotion awareness to your fingertips, helping you understand feelings and enabling emotional analysis in daily routines.",
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
