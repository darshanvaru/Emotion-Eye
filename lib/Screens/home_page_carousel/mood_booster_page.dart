import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class MoodBooster extends StatefulWidget {
  const MoodBooster({super.key});

  @override
  MoodBoosterState createState() => MoodBoosterState();
}

class MoodBoosterState extends State<MoodBooster> {
  final ConfettiController _confettiController = ConfettiController(duration: const Duration(seconds: 10));
  int _currentTipIndex = 0;

  final List<String> _moodTips = [
    "Take 3 deep breaths - inhale for 4 seconds, hold for 4, exhale for 6",
    "Write down 3 things you're grateful for today",
    "Stand up and stretch for 30 seconds",
    "Drink a glass of water - dehydration affects mood",
    "Think of a happy memory and relive it in your mind",
    "Name 5 things you can see around you right now",
    "Send a nice message to someone you care about",
    "Do 10 jumping jacks to get your blood flowing",
    "Listen to your favorite song and sing along",
    "Plan something fun to look forward to this week"
  ];

  final List<Map<String, dynamic>> _happyContent = [
    {
      'type': 'quote',
      'content': '"Happiness is not something ready made. It comes from your own actions." - Dalai Lama'
    },
    {
      'type': 'joke',
      'content': 'Why don\'t skeletons fight each other?\nThey don\'t have the guts!'
    },
    {
      'type': 'fact',
      'content': 'Smiling can trick your brain into happiness—even when you\'re not feeling it.'
    },
    {
      'type': 'activity',
      'content': 'Try the 5-4-3-2-1 grounding technique:\n5 things you see\n4 things you feel\n3 things you hear\n2 things you smell\n1 thing you taste'
    },
  ];

  @override
  void initState() {
    super.initState();
    // No audio player initialization
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _nextTip() {
    setState(() {
      _currentTipIndex = (_currentTipIndex + 1) % _moodTips.length;
    });
  }

  void _showHappyContent() {
    final content = _happyContent[_currentTipIndex % _happyContent.length];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(content['type'].toString().toUpperCase()),
        content: Text(content['content']),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mood Booster'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Confetti animation
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: true,
                  colors: const [
                    Colors.green,
                    Colors.blue,
                    Colors.pink,
                    Colors.orange,
                    Colors.purple
                  ],
                ),
              ),

              // Header
              _buildHeader(),
              SizedBox(height: 20),

              // Mood tip card
              _buildMoodTipCard(),
              SizedBox(height: 30),

              // Quick mood boosters section
              _buildQuickBoosters(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Icon(
          Icons.emoji_emotions,
          size: 60,
          color: const Color.fromARGB(255, 2, 64, 166),
        ),
        Text(
          'Need a Mood Boost?',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 2, 64, 166),
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Try these activities to lift your spirits!',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildMoodTipCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mood Tip',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 2, 64, 166),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: _nextTip,
                  color: const Color.fromARGB(255, 2, 64, 166),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              _moodTips[_currentTipIndex],
              style: TextStyle(
                fontSize: 16,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: _showHappyContent,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text('Show me something happy', style: TextStyle(color: const Color.fromARGB(255, 2, 64, 166)),),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickBoosters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Mood Boosters',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 2, 64, 166),
          ),
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildQuickBoosterChip('Watch funny videos'),
            _buildQuickBoosterChip('Dance for 1 minute'),
            _buildQuickBoosterChip('Pet an animal'),
            _buildQuickBoosterChip('Eat a healthy snack'),
            _buildQuickBoosterChip('Call a friend'),
            _buildQuickBoosterChip('Write in a journal'),
            _buildQuickBoosterChip('Look at old photos'),
            _buildQuickBoosterChip('Do a good deed'),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickBoosterChip(String text) {
    return ActionChip(
      label: Text(text),
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Great choice! $text')),
        );
      },
      backgroundColor: const Color.fromARGB(86, 2, 64, 166),
      labelStyle: TextStyle(color: const Color.fromARGB(255, 2, 64, 166),),
    );
  }
}