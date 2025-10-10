import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'Screens/main_home_page.dart';
import 'Services/notification_service.dart';
import 'Services/request_notification_permission.dart';

void main() async{
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  //
  // requestExactAlarmPermission();
  //
  // // Initialize notification service
  // await NotificationService().init();

  // Run the app
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Emotion Detection',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _fadeController;
  late final Animation<double> fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controllers
    _controller = AnimationController(vsync: this);
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Fade duration
    );

    fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    // fade animation after the splash screen duration
    Future.delayed(const Duration(seconds: 3), () {
      _fadeController.forward().then((_) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const MainHomePage(pageNumber: 0),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 180), // Transition duration
          ),
        );
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset(
          'assets/animation.json',
          controller: _controller,
          onLoaded: (composition) {
            _controller
              ..duration = composition.duration
              ..forward();
          },
          width: 200,
          height: 200,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}