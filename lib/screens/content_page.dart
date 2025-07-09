import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: const Text(
          'Contact Us\n\n'
          'For inquiries, collaborations, or support, please feel free to reach out to us:\n\n'
          '📧 Email: promptshot80@gmail.com\n\n'
          'We look forward to hearing from you and will respond as soon as possible.',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white70,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
