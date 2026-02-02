import 'dart:async';
import 'package:flutter/material.dart';

class TypingText extends StatefulWidget {
  final List<String> texts;
  final TextStyle style;
  final Duration typingSpeed;
  final Duration backspaceSpeed;
  final Duration pauseDuration;
  final bool showCursor;
  final String cursorChar;

  const TypingText({
    super.key,
    required this.texts,
    required this.style,
    this.typingSpeed = const Duration(milliseconds: 100),
    this.backspaceSpeed = const Duration(milliseconds: 50),
    this.pauseDuration = const Duration(seconds: 2),
    this.showCursor = true,
    this.cursorChar = '_',
  });

  @override
  State<TypingText> createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText> {
  String _displayedText = "";
  int _textIndex = 0;
  int _charIndex = 0;
  bool _isDeleting = false;
  Timer? _timer;
  bool _cursorVisible = true;
  Timer? _cursorTimer;

  @override
  void initState() {
    super.initState();
    _startAnimation();
    if (widget.showCursor) {
      _cursorTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
        if (mounted) {
          setState(() {
            _cursorVisible = !_cursorVisible;
          });
        }
      });
    }
  }

  void _startAnimation() {
    final currentText = widget.texts[_textIndex];

    _timer = Timer(
      _isDeleting ? widget.backspaceSpeed : widget.typingSpeed,
      () {
        if (mounted) {
          setState(() {
            if (!_isDeleting) {
              if (_charIndex < currentText.length) {
                _displayedText += currentText[_charIndex];
                _charIndex++;
                _startAnimation();
              } else {
                _isDeleting = true;
                Future.delayed(widget.pauseDuration, _startAnimation);
              }
            } else {
              if (_charIndex > 0) {
                _displayedText = _displayedText.substring(0, _charIndex - 1);
                _charIndex--;
                _startAnimation();
              } else {
                _isDeleting = false;
                _textIndex = (_textIndex + 1) % widget.texts.length;
                _startAnimation();
              }
            }
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cursorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$_displayedText${widget.showCursor && _cursorVisible ? widget.cursorChar : " "}',
      style: widget.style,
    );
  }
}
