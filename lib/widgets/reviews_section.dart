import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medbh_portfolio/constants/app_colors.dart';
import 'package:medbh_portfolio/models/review_model.dart';
import 'package:medbh_portfolio/services/content_store.dart';
import 'package:url_launcher/url_launcher.dart';

class ReviewsSection extends StatelessWidget {
  const ReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "Client Reviews",
                style: GoogleFonts.orbitron(
                  fontSize: isMobile ? 22 : 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            OutlinedButton.icon(
              onPressed: () => showDialog(
                context: context,
                builder: (_) => const _ReviewFormDialog(),
              ),
              icon: const Icon(Icons.rate_review_outlined, size: 18),
              label: Text(isMobile ? 'Review' : 'Write a review'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: AppColors.borderAccent),
                shape: const StadiumBorder(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 800) {
              final reviews = ContentStore.instance.reviews;
              final perRow = reviews.length.clamp(1, 3);
              return Column(
                children: [
                  for (var i = 0; i < reviews.length; i += perRow)
                    Padding(
                      padding: EdgeInsets.only(top: i == 0 ? 0 : 24),
                      // IntrinsicHeight + stretch: every card in a row gets the tallest card's height
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (var j = i; j < i + perRow; j++) ...[
                              if (j > i) const SizedBox(width: 24),
                              Expanded(
                                child: j < reviews.length
                                    ? _ReviewCard(review: reviews[j])
                                    : const SizedBox(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                ],
              );
            }
            return Column(
              children: [
                for (final review in ContentStore.instance.reviews) ...[
                  _ReviewCard(review: review),
                  if (review != ContentStore.instance.reviews.last)
                    const SizedBox(height: 20),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final ReviewModel review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderAccent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.format_quote,
                    color: Colors.blueAccent,
                    size: 28,
                  ),
                  const Spacer(),
                  if (review.rating > 0) Stars(rating: review.rating),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                review.text,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blueAccent.withOpacity(0.8),
                child: Text(
                  review.initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      [
                        review.role,
                        review.company,
                      ].where((s) => s.isNotEmpty).join(' – '),
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: review.sourceUrl.isEmpty
                    ? null
                    : () => launchUrl(Uri.parse(review.sourceUrl)),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Text(
                    "on ${review.source}",
                    style: const TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Visitor review form. Saved as "pending"; it appears only after approval in the dashboard.
class _ReviewFormDialog extends StatefulWidget {
  const _ReviewFormDialog();

  @override
  State<_ReviewFormDialog> createState() => _ReviewFormDialogState();
}

class _ReviewFormDialogState extends State<_ReviewFormDialog> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _role = TextEditingController();
  final _company = TextEditingController();
  final _text = TextEditingController();
  final _link = TextEditingController();
  int _rating = 0;
  bool _sending = false;
  bool _sent = false;

  @override
  void dispose() {
    for (final c in [_name, _role, _company, _text, _link]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _sending = true);
    final name = _name.text.trim();
    final initials = name
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .take(2)
        .map((w) => w[0].toUpperCase())
        .join();
    try {
      await FirebaseFirestore.instance.collection('reviews').add({
        'name': name,
        'role': _role.text.trim(),
        'company': _company.text.trim(),
        'text': _text.text.trim(),
        'initials': initials,
        'source': 'Portfolio',
        'sourceUrl': _link.text.trim(),
        if (_rating > 0) 'rating': _rating,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'order': 1000,
      });
      if (mounted) setState(() => _sent = true);
    } catch (_) {
      if (mounted) {
        setState(() => _sending = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not send your review. Please try again.'),
          ),
        );
      }
    }
  }

  InputDecoration _deco(String label) => InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: Colors.white70),
    filled: true,
    fillColor: Colors.white.withValues(alpha: 0.06),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.borderSubtle),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.accent),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.redAccent),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.redAccent),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF111A2E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColors.borderAccent),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _sent
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.greenAccent,
                      size: 56,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Thank you!',
                      style: GoogleFonts.orbitron(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Your review will appear once it has been approved.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                )
              : Form(
                  key: _form,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Write a review',
                          style: GoogleFonts.orbitron(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Worked with Mohamed? Share your experience.',
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _name,
                          maxLength: 80,
                          style: const TextStyle(color: Colors.white),
                          decoration: _deco('Your name *'),
                          validator: (v) => (v ?? '').trim().isEmpty
                              ? 'Please enter your name'
                              : null,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _role,
                                maxLength: 80,
                                style: const TextStyle(color: Colors.white),
                                decoration: _deco('Role'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _company,
                                maxLength: 80,
                                style: const TextStyle(color: Colors.white),
                                decoration: _deco('Company'),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              const Text(
                                'Rating',
                                style: TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(width: 12),
                              Stars(
                                rating: _rating,
                                size: 28,
                                onChanged: (v) => setState(() => _rating = v),
                              ),
                            ],
                          ),
                        ),
                        TextFormField(
                          controller: _text,
                          maxLength: 1500,
                          minLines: 4,
                          maxLines: 8,
                          style: const TextStyle(color: Colors.white),
                          decoration: _deco('Your review *'),
                          validator: (v) => (v ?? '').trim().length < 10
                              ? 'Please write at least 10 characters'
                              : null,
                        ),
                        TextFormField(
                          controller: _link,
                          maxLength: 300,
                          keyboardType: TextInputType.url,
                          style: const TextStyle(color: Colors.white),
                          decoration: _deco(
                            'Link (optional, e.g. LinkedIn or company site)',
                          ),
                          validator: (v) {
                            final t = (v ?? '').trim();
                            return t.isEmpty ||
                                    RegExp(r'^https?://\S+$').hasMatch(t)
                                ? null
                                : 'Enter a full link starting with https://';
                          },
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            const SizedBox(width: 8),
                            FilledButton.icon(
                              onPressed: _sending ? null : _submit,
                              icon: _sending
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.send_rounded, size: 18),
                              label: const Text('Submit'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

/// Five stars; tappable when [onChanged] is set.
class Stars extends StatelessWidget {
  final int rating;
  final double size;
  final ValueChanged<int>? onChanged;
  const Stars({
    super.key,
    required this.rating,
    this.size = 18,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      for (var i = 1; i <= 5; i++)
        GestureDetector(
          onTap: onChanged == null ? null : () => onChanged!(i),
          child: Icon(
            i <= rating ? Icons.star_rounded : Icons.star_outline_rounded,
            color: Colors.amber,
            size: size,
          ),
        ),
    ],
  );
}
