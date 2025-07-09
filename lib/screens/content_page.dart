import 'package:flutter/material.dart';
import '../widgets/nav_bar.dart';
import '../widgets/footer_section.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Scaffold(
      appBar: isMobile
          ? AppBar(
              title: const Text('Contact'),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              iconTheme: const IconThemeData(color: Colors.amber),
            )
          : null,
      drawer: isMobile ? DrawerMenu() : null,
      body: Column(
        children: [
          if (!isMobile) NavBar(selected: 'contact'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: const Text(
                'Contact Us\n\n'
                'For inquiries, collaborations, or support, please reach out to us at:\n'
                'Email: promptshot80@gmail.com\n'
                'We look forward to hearing from you!',
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
            ),
          ),
          const FooterSection(),
        ],
      ),
    );
  }
}

// Reuse DrawerMenu from other pages
class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue.shade700),
            child: const Text(
              'PromptShot Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          _buildDrawerItem(context, 'Home', '/'),
          _buildDrawerItem(context, 'Gallery', '/gallery'),
          _buildDrawerItem(context, 'About', '/about'),
          _buildDrawerItem(context, 'Contact', '/contact'),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, String title, String route) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, route);
      },
    );
  }
}
