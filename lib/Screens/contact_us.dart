import 'dart:convert'; // For JSON encoding

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // For making HTTP requests

import '../Widgets/success_dialog.dart';
import 'home_page_carousel/home_page.dart';
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
      home: HomePage(),
    );
  }
}

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  // Controllers for the text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();


  Future<void> _sendEmail() async {
    final String name = _nameController.text;
    final String subject = _subjectController.text;
    final String message = _messageController.text;

    final Uri emailUri = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    try {
      final response = await http.post(
        emailUri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'service_id': 'service_fpeqneh',
          'template_id': 'template_x2y5k84',
          'user_id': 'NYLx1xbXXe8jZ62U6',
          'template_params': {
            'name': name,
            'subject': subject,
            'message': message,
          },
        }),
      );

      if (!mounted) return; // Check if the widget is still mounted

      if (response.statusCode == 200) {
        showDialog(
          context: context, // Now it’s safe to use BuildContext
          builder: (context) => const SuccessDialog(),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Failed to send email',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return; // Check if the widget is still mounted

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Exception occurred',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 31, 84),
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
        title: const Text("Contact Us", style: TextStyle(color: Colors.white),),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name Field
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Enter Your Name',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _nameController,
                        enableInteractiveSelection: false,
                        style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          hintText: 'Your Name',
                        ),
                      ),
                    ],
                  ),
                ),
                // Subject Field
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Enter Subject',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _subjectController,
                        enableInteractiveSelection: false,
                        style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          hintText: 'Subject of Mail',
                        ),
                      ),
                    ],
                  ),
                ),
                // Message Field
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Enter Your Message',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _messageController,
                        enableInteractiveSelection: false,
                        style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                        ),
                        maxLines: 10,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          hintText: 'Message',
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: _sendEmail,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white70,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: const BorderSide(
                            color: Colors.black12,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30.0,
                          vertical: 15.0,
                        ),
                      ),
                      child: const Text('Send'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
