import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medbh_portfolio/constants/app_colors.dart';
import 'package:medbh_portfolio/services/toast_service.dart';

/// Small newsletter popup (bottom-left) shown a few seconds after load; × closes it for this visit.
/// One Firestore doc per email (doc id = email), managed in the dashboard.
class NewsletterPopup extends StatefulWidget {
  const NewsletterPopup({super.key});

  /// Visible height of the bar (0 when hidden); the floating buttons lift by this much.
  static final height = ValueNotifier<double>(0);

  @override
  State<NewsletterPopup> createState() => _NewsletterPopupState();
}

class _NewsletterPopupState extends State<NewsletterPopup> {
  bool _visible = false;
  late final Timer _timer = Timer(const Duration(seconds: 8), () {
    if (mounted) setState(() => _visible = true);
  });

  @override
  void initState() {
    super.initState();
    _timer; // start the delay
  }

  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _timer.cancel();
    _email.dispose();
    super.dispose();
  }

  Future<void> _subscribe() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _sending = true);
    final email = _email.text.trim().toLowerCase();
    String message;
    try {
      await FirebaseFirestore.instance.collection('subscribers').doc(email).set(
        {'email': email, 'at': FieldValue.serverTimestamp()},
      );
      message = 'Subscribed! Thanks for joining.';
      _email.clear();
      _visible = false;
    } on FirebaseException catch (e) {
      // Rules only allow creating: an existing email is rejected as an update.
      message = e.code == 'permission-denied'
          ? 'You are already subscribed.'
          : 'Could not subscribe. Please try again.';
    }
    if (!mounted) return;
    setState(() => _sending = false);
    ToastService.showSuccess(context, message);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(color: AppColors.borderSubtle),
    );
    final title = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.mark_email_unread_rounded,
          color: Colors.blueAccent,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          'Newsletter',
          style: GoogleFonts.orbitron(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
    const subtitle = Text(
      'Stay up to date with my latest news and updates.',
      style: TextStyle(color: Colors.white70, fontSize: 13),
    );
    final close = IconButton(
      tooltip: 'Close',
      visualDensity: VisualDensity.compact,
      onPressed: () => setState(() => _visible = false),
      icon: const Icon(Icons.close_rounded, color: Colors.white70, size: 20),
    );
    final input = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextFormField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            onFieldSubmitted: (_) => _subscribe(),
            decoration: InputDecoration(
              isDense: true,
              hintText: 'your@email.com',
              hintStyle: const TextStyle(color: Colors.white38),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.06),
              enabledBorder: border,
              focusedBorder: border.copyWith(
                borderSide: const BorderSide(color: AppColors.accent),
              ),
              errorBorder: border.copyWith(
                borderSide: const BorderSide(color: Colors.redAccent),
              ),
              focusedErrorBorder: border.copyWith(
                borderSide: const BorderSide(color: Colors.redAccent),
              ),
            ),
            validator: (v) =>
                RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch((v ?? '').trim())
                ? null
                : 'Enter a valid email',
          ),
        ),
        const SizedBox(width: 8),
        // Same look as the review dialog's Submit button.
        FilledButton.icon(
          onPressed: _sending ? null : _subscribe,
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          ),
          icon: _sending
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.mail_rounded, size: 18),
          label: const Text('Subscribe'),
        ),
      ],
    );
    // Full-width bar at the bottom, styled like the review dialog. Reports its height so the
    // floating buttons can sit above it.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted)
        NewsletterPopup.height.value = _visible
            ? (context.size?.height ?? 0)
            : 0;
    });
    return AnimatedSlide(
      offset: _visible ? Offset.zero : const Offset(0, 1.5),
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: _visible ? 1 : 0,
        duration: const Duration(milliseconds: 300),
        child: IgnorePointer(
          ignoring: !_visible,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              isMobile ? 16 : 40,
              isMobile ? 12 : 26,
              isMobile ? 8 : 24,
              isMobile ? 14 : 30,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF111A2E),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              border: Border(top: BorderSide(color: AppColors.borderAccent)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, -6),
                ),
              ],
            ),
            child: Form(
              key: _form,
              child: isMobile
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: title),
                            close,
                          ],
                        ),
                        subtitle,
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: input,
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              title,
                              const SizedBox(height: 4),
                              subtitle,
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        SizedBox(width: 480, child: input),
                        const SizedBox(width: 8),
                        close,
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
