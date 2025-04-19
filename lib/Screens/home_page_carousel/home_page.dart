import 'dart:math';
import 'package:flutter/material.dart';

import '../main_camera.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  bool _photoClicked = false;
  final Random _random = Random();

  late AnimationController _outerCircleController;
  late AnimationController _middleCircleController;

  late Animation<double> _outerCircleAnimation;
  late Animation<double> _middleCircleAnimation;

  @override
  void initState() {
    super.initState();
    _initOuterCircleAnimation();
    _initMiddleCircleAnimation();
  }

  void _initOuterCircleAnimation() {
    _outerCircleController = AnimationController(
      duration: Duration(seconds: _random.nextInt(2) + 3),
      vsync: this,
    )..repeat(reverse: true);

    _outerCircleAnimation = Tween<double>(
      begin: 1.0,
      end: _random.nextDouble() * 0.08 + 1.06,
    ).animate(
      CurvedAnimation(parent: _outerCircleController, curve: Curves.easeInOut),
    );
  }
  void _initMiddleCircleAnimation() {
    _middleCircleController = AnimationController(
      duration: Duration(seconds: _random.nextInt(2) + 3),
      vsync: this,
    )..repeat(reverse: true);

    _middleCircleAnimation = Tween<double>(
      begin: 1.0,
      end: _random.nextDouble() * 0.0699 + 1.07,
    ).animate(
      CurvedAnimation(parent: _middleCircleController, curve: Curves.easeInOut),
    );
  }
  @override
  void dispose() {
    _outerCircleController.dispose();
    _middleCircleController.dispose();
    super.dispose();
  }

  void _togglePhotoClicked() {
    setState(() {
      _photoClicked = !_photoClicked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                        //Outer Circle
                  AnimatedBuilder(
                    animation: _outerCircleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _outerCircleAnimation.value,
                        child: Container(
                          width: 240,
                          height: 240,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color.fromARGB(255, 153, 171, 201),//Colors.blue[100],
                          ),
                        ),
                      );
                    },
                  ),
                        //Middle Circle
                  AnimatedBuilder(
                    animation: _middleCircleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _middleCircleAnimation.value,
                        child: Container(
                          width: 175,
                          height: 175,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color.fromARGB(255, 102, 127, 178),//Colors.blue[300],
                          ),
                        ),
                      );
                    },
                  ),
                        //Main Button
                  SizedBox(
                    width: 110,
                    height: 110,
                    child: FloatingActionButton(
                      onPressed: () {
                        _togglePhotoClicked();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainCamera()));
                      },
                      shape: const CircleBorder(),
                      backgroundColor: const Color.fromARGB(255, 0, 31, 84),
                      foregroundColor: Colors.white,
                      heroTag: null,
                      child: const Icon(Icons.camera_alt, size: 50),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
