import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: const Text(
        'Contact Us\n\n'
        'For inquiries, collaborations, or support, please reach out to us at:\n'
        'Email: promptshot80@gmail.com\n'
        'We look forward to hearing from you!',
        style: TextStyle(fontSize: 18, color: Colors.white70),
      ),
    );
  }
}
