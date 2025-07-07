import 'package:flutter/material.dart';

void main() => runApp(BreathingApp());

class BreathingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BreathingCircle(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BreathingCircle extends StatefulWidget {
  @override
  _BreathingCircleState createState() => _BreathingCircleState();
}

class _BreathingCircleState extends State<BreathingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final int inhaleDuration = 4000; // ms
  final int holdDuration = 2000;
  final int exhaleDuration = 4000;

  @override
  void initState() {
    super.initState();

    final totalDuration = inhaleDuration + holdDuration + exhaleDuration;

    _controller = AnimationController(
      duration: Duration(milliseconds: totalDuration),
      vsync: this,
    )..repeat();

    _animation = TweenSequence([
      TweenSequenceItem<double>(
        tween: Tween(begin: 0.5, end: 1.0).chain(CurveTween(curve: Curves.easeInOut)),
        weight: inhaleDuration.toDouble(),
      ),
      TweenSequenceItem<double>(
        tween: ConstantTween(1.0),
        weight: holdDuration.toDouble(),
      ),
      TweenSequenceItem<double>(
        tween: Tween(begin: 1.0, end: 0.5).chain(CurveTween(curve: Curves.easeInOut)),
        weight: exhaleDuration.toDouble(),
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getBreathingPhase() {
    final total = inhaleDuration + holdDuration + exhaleDuration;
    final currentTime = (_controller.value * total).toInt();

    if (currentTime < inhaleDuration) return "Breathe In";
    if (currentTime < inhaleDuration + holdDuration) return "Hold";
    return "Breathe Out";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _getBreathingPhase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  width: 200 * _animation.value,
                  height: 200 * _animation.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.withOpacity(0.6),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
