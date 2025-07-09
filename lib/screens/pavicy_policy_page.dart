import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 32),
        child: const Text(
          'Privacy Policy\n\n'
          'We respect your privacy and are committed to protecting your personal data.\n\n'
          'Information We Collect:\n'
          '- Usage data such as IP address, browser type, and visit times.\n'
          '- Cookies to enhance and personalize your experience.\n\n'
          'How We Use Your Data:\n'
          '- To operate, maintain, and improve our website.\n'
          '- To analyze traffic, usage trends, and performance.\n\n'
          'Data Sharing:\n'
          'We do not sell, trade, or share your personal data with third parties.\n\n'
          'Consent:\n'
          'By using our website, you agree to the terms outlined in this privacy policy.\n\n'
          'Contact:\n'
          'For questions or concerns, contact us at support@yourdomain.com.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white70,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
