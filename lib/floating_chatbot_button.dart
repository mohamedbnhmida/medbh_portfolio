import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:medbh_portfolio/constants/app_colors.dart';

class FloatingChatBotButton extends StatefulWidget {
  @override
  _FloatingChatBotButtonState createState() => _FloatingChatBotButtonState();
}

class _FloatingChatBotButtonState extends State<FloatingChatBotButton>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  bool _isMaximized = false;
  List<Map<String, dynamic>> _chatMessages = [];
  TextEditingController _textController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  void _toggleChat() {
    setState(() {
      _isOpen = !_isOpen;
      _isOpen ? _animationController.forward() : _animationController.reverse();
    });
  }

  void _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _chatMessages.add({"sender": "user", "message": text});
      _textController.clear();
      _chatMessages.add({"sender": "bot", "message": "typing"});
    });

    try {
      // Check for custom response first
      final lowerText = text.toLowerCase();
      String reply;

      if (lowerText.contains("your name") ||
          lowerText.contains("who are you")) {
        reply = "My name is Mohamed Ben Hmida ";
      } else if (lowerText.contains("hello") || lowerText.contains("hi")) {
        reply = "Hello! I'm  your assistant. How can I help you today?";
      } else if (lowerText.contains("how are you")) {
        reply = "I'm doing great! I'am always ready to help 💪";
      } else {
        // Otherwise send to Gemini
        reply = await sendToGemini(text);
      }

      setState(() {
        _chatMessages.removeLast(); // remove "typing"
        _chatMessages.add({"sender": "bot", "message": reply});
      });
    } catch (e) {
      setState(() {
        _chatMessages.removeLast(); // remove "typing"
        _chatMessages.add({
          "sender": "bot",
          "message": "Sorry, something went wrong.",
        });
      });
    }
  }

  Future<String> sendToGemini(String userMessage) async {
    const apiKey = 'AIzaSyBPWTX1I4Qbc4Tr_25hALPs6kRGSGXULg8';
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey',
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": userMessage},
            ],
          },
        ],
      }),
    );

    final json = jsonDecode(response.body);

    if (response.statusCode != 200 || json['candidates'] == null) {
      final error = json['error']?['message'] ?? 'Unknown error';
      throw Exception('Gemini API Error: $error');
    }

    return json['candidates'][0]['content']['parts'][0]['text'];
  }

  Widget _buildTypingIndicator() {
    return TweenAnimationBuilder(
      duration: Duration(seconds: 1),
      tween: Tween<double>(begin: 0, end: 2 * pi),
      builder: (context, double angle, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (index) {
              final yOffset = sin(angle + (index * pi / 3)) * 4;
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 2),
                width: 6,
                height: 6,
                transform: Matrix4.translationValues(0, yOffset, 0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isUser = message["sender"] == "user";
    final isTyping = message["message"] == "typing";
    final bubbleColor = isUser ? Colors.blue : Colors.grey[700];
    final alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final icon = isUser ? Icons.person : Icons.smart_toy;
    final borderRadius = BorderRadius.only(
      topLeft: Radius.circular(12),
      topRight: Radius.circular(12),
      bottomLeft: isUser ? Radius.circular(12) : Radius.zero,
      bottomRight: isUser ? Radius.zero : Radius.circular(12),
    );

    return Align(
      alignment: alignment,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isUser)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(icon, color: Colors.grey[700]),
              ),
            ),
          Flexible(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: borderRadius,
              ),
              child: isTyping
                  ? _buildTypingIndicator()
                  : SelectableText(
                      message["message"],
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          ),
          if (isUser)
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(icon, color: Colors.blue),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_isOpen)
          Positioned(
            bottom: 10,
            right: 10,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: _isMaximized
                      ? MediaQuery.of(context).size.width * 0.9
                      : min(400, MediaQuery.of(context).size.width * 0.9),
                  height: _isMaximized
                      ? MediaQuery.of(context).size.height * 0.8
                      : 600,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Chat Bot',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(
                              _isMaximized
                                  ? Icons.fullscreen_exit
                                  : Icons.fullscreen,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _isMaximized = !_isMaximized;
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.white),
                            onPressed: _toggleChat,
                          ),
                        ],
                      ),
                      Divider(color: Colors.white24),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _chatMessages.length,
                          itemBuilder: (context, index) {
                            return _buildMessageBubble(_chatMessages[index]);
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _textController,
                              onSubmitted: (_) => _sendMessage(),
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: "Type your message...",
                                hintStyle: const TextStyle(
                                  color: Colors.white70,
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.1),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: AppColors.borderSubtle,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: AppColors.borderSubtle,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                    color: AppColors.accent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.send, color: Colors.blue),
                            onPressed: _sendMessage,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        if (!_isOpen)
          Positioned(
            bottom: 30,
            right: 20,
            child: FloatingActionButton(
              onPressed: _toggleChat,
              backgroundColor: AppColors.floatingButtonBackground,
              child: Icon(Icons.chat),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
