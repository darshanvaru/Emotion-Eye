import 'package:flutter/material.dart';

import '../Screens/about_app.dart';
import '../Screens/about_us.dart';
import '../Screens/contact_us.dart';
import '../Screens/guide.dart';
import '../Screens/history_page.dart';
import '../Screens/main_camera.dart';
import '../Screens/mood_improvement_dashboard.dart';
import '../Screens/privacy_policy.dart';
import '../theme/app_theme.dart';

class AppDrawer extends StatelessWidget {
  final int currentPage;
  final Function(int) onPageSelected;
  final Function(int) navigateToPage;

  const AppDrawer({
    super.key,
    required this.currentPage,
    required this.onPageSelected,
    required this.navigateToPage
  });

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    bool isActive = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingS, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingM,
              vertical: AppTheme.spacingS,
            ),
            decoration: BoxDecoration(
              color: isActive
                  ? AppTheme.primaryMedium.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              border: isActive
                  ? Border.all(
                color: AppTheme.primaryMedium.withValues(alpha: 0.3),
                width: 1,
              )
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingS),
                  decoration: BoxDecoration(
                    color: (iconColor ?? AppTheme.primaryMedium)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor ??
                        (isActive
                            ? AppTheme.primaryMedium
                            : AppTheme.textSecondary),
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: Text(
                    title,
                    style: AppTheme.bodyLarge.copyWith(
                      fontWeight:
                      isActive ? FontWeight.w600 : FontWeight.normal,
                      color: isActive
                          ? AppTheme.primaryMedium
                          : AppTheme.textPrimary,
                    ),
                  ),
                ),
                if (isActive)
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: AppTheme.primaryMedium,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color.fromARGB(255, 0, 31, 84);

    return Drawer(
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
                  isActive: currentPage == 0,
                  onTap: () {
                    // 1. Remove ContactUs / other pushed screens
                    Navigator.of(context).popUntil((route) => route.isFirst);

                    // 2. Reset PageView to Home
                    onPageSelected(0);
                    navigateToPage(0);
                  },
                ),

                _buildDrawerItem(
                  icon: Icons.smart_toy,
                  title: "Chat With AI",
                  iconColor: Colors.deepPurple,
                  // Purple for AI/tech feel
                  isActive: currentPage == 1,
                  onTap: () {
                    onPageSelected(1);
                    Navigator.of(context).pop();
                    navigateToPage(1);
                  },
                ),

                _buildDrawerItem(
                  icon: Icons.camera_alt_rounded,
                  title: "Detect Mood",
                  iconColor: Colors.teal, // Already perfect
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainCamera()),
                    );
                  },
                ),

                _buildDrawerItem(
                  icon: Icons.fitness_center,
                  title: "Exercises",
                  iconColor: Colors.orange,
                  // Orange for energy/activity
                  isActive: currentPage == 2,
                  onTap: () {
                    onPageSelected(2);
                    Navigator.of(context).pop();
                    navigateToPage(2);
                  },
                ),

                _buildDrawerItem(
                  icon: Icons.local_activity,
                  title: "Activities",
                  iconColor: Colors.green,
                  // Green for wellness/growth
                  isActive: currentPage == 3,
                  onTap: () {
                    onPageSelected(3);
                    Navigator.of(context).pop();
                    navigateToPage(3);
                  },
                ),

                _buildDrawerItem(
                  icon: Icons.history,
                  title: "History",
                  iconColor: Colors.blue,
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HistoryPage()),
                    );
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
                      MaterialPageRoute(
                          builder: (context) => MoodImprovementDashboard(initialMood: "happy")),
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
                      MaterialPageRoute(builder: (context) => AboutUsPage()),
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
                      MaterialPageRoute(builder: (context) => GuidePage()),
                    );
                  },
                ),

                const Divider(),
                _buildDrawerItem(
                  icon: Icons.rule_sharp,
                  title: "Privacy Policy",
                  iconColor: Colors.purple,
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PrivacyPolicyPage()),
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
    );
  }
}
