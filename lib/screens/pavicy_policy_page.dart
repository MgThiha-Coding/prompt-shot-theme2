import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = Colors.white70;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        child: Text('''
Privacy Policy

We respect your privacy and are committed to protecting your personal data.

Information We Collect:
- Usage data such as IP address, browser type, and visit times.
- Cookies to enhance and personalize your experience.

How We Use Your Data:
- To operate, maintain, and improve our website.
- To analyze traffic, usage trends, and performance.
- To serve personalized ads through Google AdSense.

Cookies:
Our site uses cookies to enhance user experience and for advertising purposes via Google AdSense. You can disable cookies in your browser settings, but some features may not function properly.

Data Sharing:
We do not sell, trade, or share your personal data with third parties other than advertising partners.

Consent:
By using our website, you agree to the terms outlined in this privacy policy.

Contact:
For questions or concerns, contact us at promptshot80@gmail.com.
''', style: TextStyle(fontSize: 16, color: textColor, height: 1.5)),
      ),
    );
  }
}
