import 'package:emotioneye/Screens/home_page_carousel/mood_booster_page.dart';
import 'package:flutter/material.dart';

import '/Screens/about_app.dart';
import '/Screens/about_us.dart';
import '/Screens/contact_us.dart';
import '/Screens/guide.dart';
import 'home_page_carousel/home_page.dart';

class MainHomePage extends StatefulWidget {
  final int pageNumber;

  const MainHomePage({super.key, required this.pageNumber});

  @override
  MainHomePageState createState() => MainHomePageState();
}


class MainHomePageState extends State<MainHomePage> {
  late PageController pageController ;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.pageNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(225, 0, 31, 84),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MainHomePage(pageNumber: 1)),
                      (route) => false,
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.emoji_emotions),
              title: Text('Mood Booster'),
              onTap: () {
                Navigator.of(context).pop();
                pageController.jumpToPage(2);
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('History'),
              onTap: () {
                Navigator.of(context).pop();
                pageController.jumpToPage(2);
              },
            ),
            ListTile(
              leading: Icon(Icons.mail_rounded),
              title: Text('Contact Us'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContactUs()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.group),
              title: Text('About Us'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutUs()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About App'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutApp()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Guide'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Guide()),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 0, 31, 84),
        title: Text(
          'Emotion Eye',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Proximal Nova',
            fontSize: 24.0,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
              children: [
                Placeholder(),
                HomePage(),
                MoodBooster(),
              ],
            ),
          ),
          Container(
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(5),
            ),
            child: Stack(
              children: [
                // Highlight slider
                AnimatedAlign(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  alignment: currentPage == 0
                      ? Alignment.centerLeft
                      : currentPage == 1
                      ? Alignment.center
                      : Alignment.centerRight,
                  child: FractionallySizedBox(
                    widthFactor: 1 / 3,
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 0, 31, 84),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),

                // Clickable labels
                Row(
                  children: List.generate(3, (index) {
                    final labels = ["History", "Home", "Mood"];
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          pageController.animateToPage(
                            index,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            labels[index],
                            style: TextStyle(
                              color: currentPage == index ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
