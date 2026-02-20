import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  AIChatScreenState createState() => AIChatScreenState();
}

class AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  // App theme colors
  static const Color primaryColor = Color.fromARGB(255, 0, 31, 84);
  static const Color accentColor = Color(0xFF00BCD4);

  // Mood-based colors matching the carousel
  final Map<String, Color> moodColors = {
    'neutral': Color(0xFFF5F7FA),
    'sad': Color(0xFFE3F2FD),
    'happy': Color(0xFFFFF8E1),
    'angry': Color(0xFFFFEBEE),
    'anxious': Color(0xFFF3E5F5),
  };

  // Replace with your Gemini API endpoint & key
  final String apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent";
  final String apiKey = "AIzaSyA6K4K5dEMTM7TVyQHI0yJaE4sauEwh_V8";

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Load chat history from SharedPreferences
  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final String? messagesString = prefs.getString('chat_history');
    if (messagesString != null) {
      final List<dynamic> jsonList = jsonDecode(messagesString);
      setState(() {
        _messages.clear();
        _messages.addAll(jsonList.map((e) => Map<String, String>.from(e)));
      });
    }
  }

  // Save chat history to SharedPreferences
  Future<void> _saveMessagesToPreference() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('chat_history', jsonEncode(_messages));
  }

  void clearChatHistory() {
    setState(() {
      _messages.clear();
    });
    _saveMessagesToPreference();
    Navigator.pop(context);
  }

  // Scroll to bottom of chat
  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  // Send message to Gemini API with emotion context
  Future<void> _sendMessage({String detectedEmotion = "neutral"}) async {
    if (_messages.isNotEmpty) {
      _scrollToBottom();
    }
    final userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add({
        'role': 'user',
        'text': userMessage,
        'time': DateTime.now().toIso8601String()
      });
      _isLoading = true;
      _controller.clear();
    });
    await _saveMessagesToPreference();

    try {
      // Custom prompt for emotion-aware mood booster
      // The user’s detected emotion is: $detectedEmotion.
      String customPrompt = """
        You are a compassionate AI assistant for mood boosting.
        Respond in a supportive, empathetic, and uplifting way.
        Here is what the user said: "$userMessage".
        Use short, friendly, and encouraging language.
        """;

      final response = await http.post(
        Uri.parse('$apiUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": customPrompt}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final aiReply = data["candidates"]?[0]?["content"]?["parts"]?[0]
                ?["text"] ??
            "I'm here to listen. Tell me more about how you feel 💙";

        setState(() {
          _messages.add({
            'role': 'assistant',
            'text': aiReply,
            'time': DateTime.now().toIso8601String()
          });
        });
        await _saveMessagesToPreference();
      } else {
        setState(() {
          _messages.add({
            'role': 'assistant',
            'text': "We're having trouble processing your request. As a small team, we work with a monthly API limit that may have been reached, or there might be a network error. Please check for an app update to receive a fresh API key, or try again later. Thank you for your patience!.",
            'time': DateTime.now().toIso8601String()
          });
        });
        await _saveMessagesToPreference();
      }
    } catch (e) {
      setState(() {
        _messages.add({
          'role': 'assistant',
          'text': "Sorry! You are out of limit, we are working on removing the limit, for now you will not able to use chat again",
          'time': DateTime.now().toIso8601String()
        });
      });
      await _saveMessagesToPreference();
    } finally {
      setState(() => _isLoading = false);
      await Future.delayed(
        Duration(milliseconds: 250),
        () => _scrollToBottom(),
      );
    }
  }

  // Format timestamp for chat bubble
  String _formatTime(String isoString) {
    final dt = DateTime.parse(isoString);
    return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}, ${dt.day}/${dt.month}/${dt.year}";
  }

  @override
  Widget build(BuildContext context) {
    // Get keyboard height
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    // Check if keyboard is open
    final isKeyboardOpen = keyboardHeight > 0;
    final Color primaryColor = const Color.fromARGB(255, 0, 31, 84);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content Area - Chat Bubbles
            Positioned.fill(
              bottom: isKeyboardOpen ? 75 : 150,
              // Space for text field (70) + bottom nav bar (70)
              child: _messages.isEmpty
                  ? Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            primaryColor.withValues(alpha: 0.1),
                            accentColor.withValues(alpha: 0.1)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: primaryColor.withValues(alpha: 0.2)),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Icon(
                              Icons.psychology_outlined,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Welcome to your Mood Booster!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'I\'m here to listen, support, and help boost your mood. Share what\'s on your mind and let\'s chat!',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final msg = _messages[index];
                        final isUser = msg['role'] == 'user';
                        return _buildMessageBubble(msg, isUser, index);
                      },
                    ),
            ),

            //typing indicator
            if (_isLoading)
              Positioned(
                left: 16,
                right: 16,
                bottom: isKeyboardOpen ? 75 : 150,
                child: _buildTypingIndicator(primaryColor),
              ),

            // Chat TextField - Positioned above bottom nav bar
            Positioned(
              left: 16,
              right: 16,
              bottom: isKeyboardOpen ? 5 : 83, // Just above the bottom nav bar
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: TextField(
                            controller: _controller,
                            maxLines: null,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              hintText: "Tell me how you feel...",
                              hintStyle: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 16,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              prefixIcon: Icon(
                                Icons.mood_outlined,
                                color: Colors.grey.shade400,
                                size: 22,
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.4,
                            ),
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [primaryColor, accentColor],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(25),
                            onTap: _isLoading ? null : _sendMessage,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              child: Icon(
                                _isLoading
                                    ? Icons.hourglass_empty
                                    : Icons.send_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, String> msg, bool isUser, int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (index * 50)),
      curve: Curves.easeOutBack,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isUser) ...[
                Container(
                  padding: const EdgeInsets.all(6),
                  margin: const EdgeInsets.only(right: 8, bottom: 4),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.psychology_outlined,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
              Flexible(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    gradient: isUser
                        ? LinearGradient(
                            colors: [primaryColor, accentColor],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: isUser ? null : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(isUser ? 20 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isUser
                            ? primaryColor.withValues(alpha: 0.3)
                            : Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    border:
                        isUser ? null : Border.all(color: Colors.grey.shade200),
                  ),
                  child: Text(
                    msg['text']!,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black87,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
              if (isUser) ...[
                Container(
                  padding: const EdgeInsets.all(6),
                  margin: const EdgeInsets.only(left: 8, bottom: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.person_outline,
                    color: Colors.grey.shade600,
                    size: 16,
                  ),
                ),
              ],
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              left: isUser ? 0 : 40,
              right: isUser ? 40 : 0,
              top: 4,
            ),
            child: Text(
              _formatTime(msg['time']!),
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            margin: const EdgeInsets.only(right: 8, bottom: 4),
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.psychology_outlined,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                const SizedBox(width: 4),
                _buildTypingDot(1),
                const SizedBox(width: 4),
                _buildTypingDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return AnimatedBuilder(
      animation: AlwaysStoppedAnimation(0.0),
      builder: (context, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey.shade400,
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
