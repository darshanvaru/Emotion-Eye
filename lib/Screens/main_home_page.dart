import 'package:emotioneye/Screens/mood_improvement_dashboard.dart';
import 'package:emotioneye/Screens/home_page_carousel/mood_booster_page.dart';
import 'package:emotioneye/Screens/main_camera.dart';
import 'package:flutter/material.dart';

import '/Screens/about_app.dart';
import '/Screens/about_us.dart';
import '/Screens/contact_us.dart';
import '/Screens/guide.dart';
import 'home_page_carousel/history_page.dart';
import 'home_page_carousel/home_page.dart';

class MainHomePage extends StatefulWidget {
  final int pageNumber;

  const MainHomePage({super.key, required this.pageNumber});

  @override
  MainHomePageState createState() => MainHomePageState();
}

class MainHomePageState extends State<MainHomePage> with SingleTickerProviderStateMixin {
  late PageController pageController;
  late AnimationController _animationController;
  int currentPage = 1;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.pageNumber);
    currentPage = widget.pageNumber;

    // Setup animation for hamburger/drawer icon
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Method to handle navigation and state updates
  void _navigateToPage(int index) {
    if (pageController.hasClients) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Drawer item widget for consistency
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    bool isActive = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? (isActive ? Theme.of(context).primaryColor : Colors.black87)),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          color: isActive ? Theme.of(context).primaryColor : Colors.black87,
        ),
      ),
      tileColor: isActive ? Colors.blue.withValues(alpha: 0.1) : null,
      shape: isActive
          ? RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      )
          : null,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color.fromARGB(255, 0, 31, 84);

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        elevation: 10,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.visibility,
                      color: Colors.white,
                      size: 40,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Emotion Eye',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Detect and analyze emotions',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                children: <Widget>[
                  _buildDrawerItem(
                    icon: Icons.home,
                    title: "Home",
                    isActive: currentPage == 1,
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => MainHomePage(pageNumber: 1)),
                            (route) => false,
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.camera_alt_rounded,
                    title: "Detect Mood",
                    iconColor: Colors.teal,
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainCamera()),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.history,
                    title: "History",
                    isActive: currentPage == 0,
                    onTap: () {
                      Navigator.of(context).pop();
                      _navigateToPage(0);
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.mood,
                    title: "Mood Booster",
                    isActive: currentPage == 2,
                    iconColor: Colors.amber,
                    onTap: () {
                      Navigator.of(context).pop();
                      _navigateToPage(2);
                    },
                  ),
                  const Divider(),
                  _buildDrawerItem(
                    icon: Icons.dashboard,
                    title: "Mood Improvement Dashboard",
                    iconColor: Colors.purple,
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MoodImprovementDashboard(initialMood: "happy")),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.mail_rounded,
                    title: "Contact Us",
                    iconColor: Colors.blue,
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ContactUs()),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.group,
                    title: "About Us",
                    iconColor: Colors.indigo,
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AboutUs()),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.info_outline,
                    title: "About App",
                    iconColor: Colors.deepPurple,
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AboutApp()),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.help_outline,
                    title: "Guide",
                    iconColor: Colors.green,
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
            // Footer for drawer
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border(
                  top: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'v1.0.0',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: primaryColor,
        title: const Text(
          'Emotion Eye',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
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
              children: const [
                HistoryPage(),
                HomePage(),
                MoodBooster(),
              ],
            ),
          ),
          // Bottom navigation bar
          Container(
            height: 65,
            margin: const EdgeInsets.fromLTRB(12, 5, 12, 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Animated indicator
                AnimatedAlign(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  alignment: currentPage == 0
                      ? Alignment.centerLeft
                      : currentPage == 1
                      ? Alignment.center
                      : Alignment.centerRight,
                  child: FractionallySizedBox(
                    widthFactor: 1 / 3,
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                // Navigation items
                Row(
                  children: [
                    _buildNavItem(Icons.history, "History", 0),
                    _buildNavItem(Icons.home, "Home", 1),
                    _buildNavItem(Icons.mood, "Mood", 2),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // Helper method for navigation items
  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isActive = currentPage == index;

    return Expanded(
      child: InkWell(
        onTap: () => _navigateToPage(index),
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive
                  ? const Color.fromARGB(255, 0, 31, 84)
                  : Colors.grey.shade600,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive
                    ? const Color.fromARGB(255, 0, 31, 84)
                    : Colors.grey.shade600,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}