import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medbh_portfolio/constants/app_colors.dart';
import 'package:medbh_portfolio/constants/app_strings.dart';
import 'package:http/http.dart' as http;
import 'package:medbh_portfolio/services/toast_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isLoading = false;

  Future<void> _sendEmail() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // EmailJS implementation
        // Create an account at emailjs.com to get these values
        const serviceId = 'service_1gftue9';
        const templateId = 'template_iadb884';
        const publicKey = 'Av0g4ACLjsdnmeWZ3';

        // Check if user has updated the keys
        if (serviceId.contains('service_') &&
            templateId.contains('template_')) {
          final response = await http.post(
            Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'service_id': serviceId,
              'template_id': templateId,
              'user_id': publicKey,
              'template_params': {
                'title': 'Portfolio Message ',
                'name': _nameController.text,
                'email': _emailController.text,
                'message': _messageController.text,
                'time': DateTime.now().toString().substring(0, 16),
                'reply_to': _emailController.text,
              },
            }),
          );

          if (response.statusCode == 200) {
            if (mounted) {
              ToastService.showSuccess(context, 'Mail Sent Successfully!');
              _formKey.currentState!.reset();
              _nameController.clear();
              _emailController.clear();
              _messageController.clear();
            }
          } else {
            throw Exception('Failed to send email: ${response.body}');
          }
        } else {
          // Fallback to mailto if keys are not set correctly
          final Uri params = Uri(
            scheme: 'mailto',
            path: AppStrings.email,
            query: _encodeQueryParameters(<String, String>{
              'subject': 'Portfolio Contact: ${_nameController.text}',
              'body':
                  '${_messageController.text}\n\nFrom: ${_emailController.text}',
            }),
          );

          if (!await launchUrl(params)) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Could not open email client')),
              );
            }
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.contactTitle,
          style: GoogleFonts.orbitron(
            fontSize: MediaQuery.of(context).size.width < 600 ? 22 : 28,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "Send me a message directly:",
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
        const SizedBox(height: 30),

        Container(
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration("Your Name"),
                  validator: (value) =>
                      value!.isEmpty ? "Please enter your name" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration("Your Email"),
                  validator: (value) => value!.isEmpty || !value.contains('@')
                      ? "Please enter a valid email"
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _messageController,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 5,
                  decoration: _inputDecoration("Your Message"),
                  validator: (value) =>
                      value!.isEmpty ? "Please enter a message" : null,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _sendEmail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.floatingButtonBackground,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            "Send Message",
                            style: GoogleFonts.orbitron(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 70),
      ],
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.black12,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.borderSubtle),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.borderSubtle),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.accent),
      ),
    );
  }

  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }
}
