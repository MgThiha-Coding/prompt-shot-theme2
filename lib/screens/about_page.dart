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
          if (!isMobile) NavBar(selected: 'about'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: const Text(
                'About PromptShot\n\n'
                'PromptShot is a curated gallery that showcases captivating AI-generated images, each born from a blend of creativity, technology, and human essence. '
                'We specialize in transforming original human photos into stunning artistic styles using advanced prompt engineering powered by Hailuo AI.\n\n'
                'Whether it’s bringing a fantasy vision to life or stylizing portraits with cinematic flair, PromptShot captures imagination in pixels. '
                'Our goal is to inspire and empower anyone to see their own image reimagined through the lens of artificial intelligence.\n\n'
                'PromptShot is built using Flutter and Firebase, and proudly hosted on Vercel. It’s more than just a gallery — it’s a creative space where your face meets futuristic art.\n\n'
                'Feel free to explore, get inspired, and share the magic!',
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
