import 'package:flutter/material.dart';
import 'main_home_page.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});
  @override
  State createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => const MainHomePage(pageNumber: 1)),
                    (Route route) => false);
          },
        ),
        backgroundColor: const Color.fromARGB(255, 0, 31, 84),
        automaticallyImplyLeading: true,
        title: const Text(
          "About Us",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 24.0),
          child: Container(
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
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 44,
                    backgroundImage: AssetImage("assets/team.jpg"), // Replace with a real team image
                  ),
                  SizedBox(height: 14),
                  Text(
                    "We are a passionate and dynamic team of three — Darshan Varu, Smit Thakker, and Parv Ravasiya, students of final year BE in Computer Engineering.",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color.fromARGB(255, 0, 31, 84)),
                    textAlign: TextAlign.center,
                  ),
                  Divider(height: 28, thickness: 1, color: Colors.grey[300]),
                  Text(
                    "Our journey in technology is driven by a shared love for innovation and a deep interest in enhancing daily life. We combine unique strengths to tackle challenges from multiple perspectives, creating comprehensive solutions.",
                    style: TextStyle(fontSize: 15.0, color: Colors.black87),
                  ),
                  SizedBox(height: 16),
                  ListTile(
                    leading: Icon(Icons.phone_android, color: Colors.blue[700]),
                    title: Text("Android & Flutter Development"),
                  ),
                  ListTile(
                    leading: Icon(Icons.design_services, color: Colors.blue[700]),
                    title: Text("Design & User Experience Focus"),
                  ),
                  ListTile(
                    leading: Icon(Icons.insert_chart, color: Colors.blue[700]),
                    title: Text("Robust Backend Systems and UI Design"),
                  ),
                  SizedBox(height: 20),
                  Card(
                    color: Colors.blue[50],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        children: [
                          Text(
                            "Current Project",
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 31, 84)),
                          ),
                          SizedBox(height: 6),
                          Text(
                            '"Mood Detector" exemplifies our mission: merging technology with human emotions, making it accessible and impactful for everyone. We aim to make technology more empathetic and connected to the world.',
                            style: TextStyle(fontSize: 15, color: Colors.black87),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 18),
                  Text(
                    "As we continue to grow, our focus remains on pushing boundaries and making a positive impact through our work.",
                    style: TextStyle(fontStyle: FontStyle.italic, color: Colors.blueGrey),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
