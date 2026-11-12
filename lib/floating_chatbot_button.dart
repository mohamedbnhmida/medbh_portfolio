import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medbh_portfolio/chatbot/knowledge_base.dart';
import 'package:medbh_portfolio/constants/app_colors.dart';
import 'package:medbh_portfolio/services/worker_api.dart';

/// Portfolio assistant: instant ready answers from [KnowledgeBase] (CV + portfolio data);
/// anything else goes to the chat worker (chat_worker/), which asks Claude using the profile
/// as context. No API key in the client.

class FloatingChatBotButton extends StatefulWidget {
  const FloatingChatBotButton({super.key});

  @override
  State<FloatingChatBotButton> createState() => _FloatingChatBotButtonState();
}

class _FloatingChatBotButtonState extends State<FloatingChatBotButton>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  final _messages = <({bool isUser, String text})>[
    (isUser: false, text: KnowledgeBase.greeting),
  ];
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  bool _typing = false;
  final _session = DateTime.now().microsecondsSinceEpoch.toRadixString(
    36,
  ); // groups one visitor's chat
  late final AnimationController _anim = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  );

  void _toggle() {
    setState(() => _isOpen = !_isOpen);
    _isOpen ? _anim.forward() : _anim.reverse();
  }

  Future<void> _ask(String raw) async {
    final text = raw.trim();
    if (text.isEmpty || _typing) return;
    _textController.clear();
    setState(() {
      _messages.add((isUser: true, text: text));
      _typing = true;
    });
    _scrollToEnd();
    // Gemini (via the worker) understands any phrasing; ready answers are the offline fallback.
    final reply =
        await _askModel() ??
        KnowledgeBase.answer(text) ??
        KnowledgeBase.fallback;
    _logChat(text, reply);
    if (!mounted) return;
    setState(() {
      _typing = false;
      _messages.add((isUser: false, text: reply));
    });
    _scrollToEnd();
  }

  /// Sends the recent conversation (greeting excluded) to the chat worker; null if it's unreachable.
  Future<String?> _askModel() async {
    final history = [
      for (final m in _messages.skip(1))
        {'role': m.isUser ? 'user' : 'assistant', 'content': m.text},
    ];
    try {
      final res = await http
          .post(
            Uri.parse('${WorkerApi.baseUrl}/chat'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'messages': history}),
          )
          .timeout(const Duration(seconds: 30));
      if (res.statusCode != 200) return null;
      final reply = (jsonDecode(res.body) as Map<String, dynamic>)['reply'];
      return reply is String && reply.isNotEmpty ? reply : null;
    } catch (_) {
      return null;
    }
  }

  /// Saves the exchange to Firestore `chats` (add-only; readable in the Firebase console).
  void _logChat(String question, String answer) {
    FirebaseFirestore.instance
        .collection('chats')
        .add({
          'at': FieldValue.serverTimestamp(),
          'session': _session,
          'question': question.length > 800
              ? question.substring(0, 800)
              : question,
          'answer': answer.length > 4000 ? answer.substring(0, 4000) : answer,
        })
        .then((_) {}, onError: (_) {}); // never break the chat
  }

  void _scrollToEnd() => WidgetsBinding.instance.addPostFrameCallback((_) {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  });

  /// Renders **bold** segments.
  Widget _richText(String text, Color color) {
    final spans = <TextSpan>[];
    final parts = text.split('**');
    for (var i = 0; i < parts.length; i++) {
      spans.add(
        TextSpan(
          text: parts[i],
          style: TextStyle(
            fontWeight: i.isOdd ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      );
    }
    return SelectableText.rich(
      TextSpan(
        style: TextStyle(color: color, fontSize: 13.5, height: 1.45),
        children: spans,
      ),
    );
  }

  Widget _bubble(({bool isUser, String text}) m) {
    final r = const Radius.circular(16);
    return Align(
      alignment: m.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          gradient: m.isUser
              ? const LinearGradient(
                  colors: [Color(0xFF2F6BFF), Color(0xFF00B4FF)],
                )
              : null,
          color: m.isUser ? null : Colors.white.withValues(alpha: 0.08),
          border: m.isUser ? null : Border.all(color: AppColors.borderSubtle),
          borderRadius: BorderRadius.only(
            topLeft: r,
            topRight: r,
            bottomLeft: m.isUser ? r : Radius.zero,
            bottomRight: m.isUser ? Radius.zero : r,
          ),
        ),
        child: _richText(m.text, Colors.white),
      ),
    );
  }

  Widget _typingDots() => Align(
    alignment: Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 2 * pi),
        duration: const Duration(seconds: 1),
        onEnd: () => setState(() {}),
        builder: (_, a, __) => Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            3,
            (i) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 6,
              height: 6,
              transform: Matrix4.translationValues(
                0,
                sin(a + i * pi / 3) * 3,
                0,
              ),
              decoration: const BoxDecoration(
                color: Colors.white70,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Widget _chips() => SizedBox(
    height: 36,
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: [
        for (final s in KnowledgeBase.suggestions)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              label: Text(
                s,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              backgroundColor: AppColors.accent.withValues(alpha: 0.15),
              side: BorderSide(color: AppColors.borderAccent),
              shape: const StadiumBorder(),
              onPressed: () => _ask(s),
            ),
          ),
      ],
    ),
  );

  Widget _panel(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      width: min(400, size.width - 24),
      height: min(600, size.height - 100),
      decoration: BoxDecoration(
        color: const Color(0xF20D1526),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.borderAccent),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.25),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2F6BFF), Color(0xFF00B4FF)],
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(21)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.smart_toy_rounded,
                    color: Color(0xFF2F6BFF),
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mohamed's Assistant",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 4,
                            backgroundColor: Color(0xFF4ADE80),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Online · AI assistant',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white),
                  onPressed: _toggle,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(14),
              children: [
                for (final m in _messages) _bubble(m),
                if (_typing) _typingDots(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: _chips(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 8, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    onSubmitted: _ask,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Ask about experience, skills, projects…',
                      hintStyle: const TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.07),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: AppColors.borderSubtle),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: AppColors.accent),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                IconButton.filled(
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.accent,
                  ),
                  icon: const Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => _ask(_textController.text),
                ),
              ],
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
            bottom: 16,
            right: 12,
            child: ScaleTransition(
              scale: CurvedAnimation(parent: _anim, curve: Curves.easeOutBack),
              alignment: Alignment.bottomRight,
              child: _panel(context),
            ),
          ),
        if (!_isOpen)
          Positioned(
            bottom: 24,
            right: 20,
            child: FloatingActionButton.extended(
              onPressed: _toggle,
              backgroundColor: AppColors.floatingButtonBackground,
              icon: const Icon(Icons.chat_bubble_rounded, color: Colors.white),
              label: const Text(
                'Ask me',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _anim.dispose();
    super.dispose();
  }
}
