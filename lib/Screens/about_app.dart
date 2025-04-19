import 'package:flutter/material.dart';
import 'main_home_page.dart';

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
  State<AboutApp> createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            // Navigator.of(context).pop();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const MainHomePage(pageNumber: 1)),
                  (Route<dynamic> route) =>
              false, // This condition removes all routes
            );
          },
        ),
        backgroundColor: Color.fromARGB(255, 0, 31, 84),
        automaticallyImplyLeading: true,
        title: const Text("About App", style: TextStyle(color: Colors.white),),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Text(
              'Our app, "Mood Detector" is designed to recognize and interpret emotions from facial expressions. By simply capturing a photo, our app processes the image using advanced machine learning models to determine the emotion conveyed. Whether you\'re curious about how you or others might be feeling, or you\'re looking to incorporate emotional analysis into your routine, Mood Detector offers a seamless and engaging experience. The app features a clean and user-friendly interface, making it easy to navigate through different functionalities, such as taking photos, viewing results, and exploring additional resources.',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ),
      ),
    );
  }
}