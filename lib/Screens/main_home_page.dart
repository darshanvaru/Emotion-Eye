import 'package:emotioneye/Screens/coming_soon.dart';
import 'package:emotioneye/Screens/main_camera.dart';
import 'package:emotioneye/Widgets/app_drawer.dart';
import 'package:flutter/material.dart';

import '../Widgets/streak_appbar_widget.dart';
import '../theme/app_theme.dart';
import 'HomePageCarousel/activities_screen.dart';
import 'HomePageCarousel/ai_chat_screen.dart.dart';
import 'HomePageCarousel/dashboard_page.dart';
import 'HomePageCarousel/exercises_screen.dart';

class MainHomePage extends StatefulWidget {
  final int pageNumber;

  const MainHomePage({super.key, required this.pageNumber});

  @override
  MainHomePageState createState() => MainHomePageState();
}

class MainHomePageState extends State<MainHomePage> with SingleTickerProviderStateMixin {
  final GlobalKey<MoodChatScreenState> chatKey = GlobalKey<MoodChatScreenState>();
  late PageController pageController;
  late AnimationController _animationController;
  int currentPage = 0;

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
  void navigateToPage(int index) {
    if (pageController.hasClients) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Helper method for navigation items
  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isActive = currentPage == index;

    return InkWell(
      onTap: () => navigateToPage(index),
      borderRadius: BorderRadius.circular(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? Colors.white : Color.fromRGBO(255, 255, 255, 0.6),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              color:
                  isActive ? Colors.white : Color.fromRGBO(255, 255, 255, 0.6),
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }


  void onPageSelected(int page) {
    setState(() {
      currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color.fromARGB(255, 0, 31, 84);

    return WillPopScope(
      onWillPop: () async {

        // for returning to home page, when not in homepage
        if (currentPage != 0) {
          setState(() {
            navigateToPage(0);
            currentPage = 0;
          });
          return false;
        }

        // else exit directly
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: AppDrawer(currentPage: currentPage, onPageSelected: onPageSelected, navigateToPage: navigateToPage),
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
          actions: [
      
            //Streak Widget
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: const StreakAppBarWidget(),
            ),
      
            //AI Chat Refresh Button
            if (currentPage == 1)
              IconButton(
                icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: const Text('Clear Chat History'),
                      content: const Text('Are you sure you want to clear all messages?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () =>
                              chatKey.currentState?.clearChatHistory(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Clear'),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
        body: SafeArea(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // PageView for main content
              Positioned(
                child: PageView(
                  controller: pageController,
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  children: [
                    const HomePage(),
                    // ComingSoonPage(),
                    MoodChatScreen(key: chatKey),
                    const ExercisePage(),
                    ActivitiesPage(),
                  ],
                ),
              ),
                
              // The bottom bar
              Positioned(
                left: AppTheme.spacingM,
                right: AppTheme.spacingM,
                bottom: AppTheme.spacingS,
                child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(35),
                      boxShadow: AppTheme.elevatedShadow,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                            child: _buildNavItem(Icons.home_rounded, "Home", 0)
                        ),
                        Expanded(
                            child: _buildNavItem(Icons.smart_toy_rounded, "AI Chat", 1)
                        ),
                        const SizedBox(width: 72), // Space for the floating action button,
                        Expanded(
                            child: _buildNavItem(Icons.fitness_center_rounded, "Exercise", 2)
                        ),
                        Expanded(
                            child: _buildNavItem(Icons.local_activity_rounded, "Activities", 3)
                        ),
                      ],
                    )),
              ),
                
              // The floating button
              AnimatedPositioned(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                bottom: currentPage == 1 ? 9 : 30,
                // Slide down when on 2nd page
                left: MediaQuery.of(context).size.width / 2 - 34,
                // Center FAB
                child: Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    gradient: AppTheme.accentGradient,
                    shape: BoxShape.circle,
                    boxShadow: AppTheme.elevatedShadow,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainCamera(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(34),
                      child: const Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
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
