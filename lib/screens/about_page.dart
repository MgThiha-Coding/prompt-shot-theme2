import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // ✅ Prevents ghosting
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: const Text(
          'About PromptShot\n\n'
          'PromptShot is a unique platform that transforms your personal photos into inspiring AI-generated artworks, '
          'reflecting the ambitions and dreams of who you want to become. Whether envisioning yourself as a doctor, engineer, '
          'or any professional you aspire to be, our gallery offers a creative glimpse into your future self.\n\n'
          'By blending cutting-edge AI technology with human creativity, PromptShot empowers you to visualize your goals '
          'and stay motivated on your journey. These images serve as powerful reminders that your dreams are within reach.\n\n'
          'We are committed to inspiring growth, confidence, and creativity, providing a space where art and ambition meet. '
          'Built with Flutter and Firebase, and hosted on Vercel, PromptShot delivers a seamless, modern experience to spark your imagination.\n\n'
          'Explore the gallery, find your inspiration, and share your vision with the world.',
          style: TextStyle(fontSize: 18, color: Colors.white70),
        ),
      ),
    );
  }
}
