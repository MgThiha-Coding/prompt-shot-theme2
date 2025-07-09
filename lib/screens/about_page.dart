import 'package:flutter/material.dart';
import '../widgets/nav_bar.dart';
import '../widgets/footer_section.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Scaffold(
      appBar: isMobile
          ? AppBar(
              title: const Text('About'),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              iconTheme: const IconThemeData(color: Colors.amber),
            )
          : null,
      drawer: isMobile ? DrawerMenu() : null,
      body: Column(
        children: [
          if (!isMobile)
            NavBar(
              selected: 'about',
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: const Text(
                'About PromptShot\n\n'
                'PromptShot is a curated gallery showcasing stunning AI-generated images created from creative prompts. '
                'Our mission is to inspire creativity by blending imagination and technology.\n\n'
                'This project is built with Flutter, Firebase, and hosted on Vercel. Feel free to explore and contribute!',
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

// Reuse DrawerMenu from home_page.dart or extract to widgets folder
class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue.shade700),
            child: const Text('PromptShot Menu',
                style: TextStyle(color: Colors.white, fontSize: 24)),
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
