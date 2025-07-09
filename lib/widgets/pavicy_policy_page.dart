import 'package:flutter/material.dart';
import 'package:prompt_shot/screens/about_page.dart';
import '../widgets/nav_bar.dart';
import '../widgets/footer_section.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Scaffold(
      appBar: isMobile
          ? AppBar(
              title: const Text('Privacy Policy'),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              iconTheme: const IconThemeData(color: Colors.amber),
            )
          : null,
      drawer: isMobile ? const DrawerMenu() : null,
      body: Column(
        children: [
          if (!isMobile) const NavBar(selected: 'privacy'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: const Text(
                'Privacy Policy\n\n'
                'We respect your privacy and are committed to protecting your personal data.\n\n'
                'Information we collect:\n'
                '- Usage data such as IP address, browser type, and visit times.\n'
                '- Cookies to improve user experience.\n\n'
                'How we use your data:\n'
                '- To operate and improve the website.\n'
                '- To analyze traffic and usage patterns.\n\n'
                'We do not sell or share your personal data with third parties.\n\n'
                'By using our website, you consent to this privacy policy.\n\n'
                'For questions, please contact us at support@yourdomain.com.',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ),
          ),
          const FooterSection(),
        ],
      ),
    );
  }
}
