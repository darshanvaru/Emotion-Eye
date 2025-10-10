import 'package:flutter/material.dart';

class ActivityCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const ActivityCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.0),
          color: Color.fromARGB(255, 249, 249, 249),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 211, 217, 225),
              offset: Offset(1, 3),
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: screenWidth>600 ? screenWidth/31 : screenWidth/16,
              color: Colors.black
            ),
            const SizedBox(height: 12),
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black,
                fontSize: screenWidth>600 ? screenWidth/34 : screenWidth/20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
