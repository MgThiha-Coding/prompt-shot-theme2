import 'package:flutter/material.dart';
import 'package:prompt_shot/widgets/footer_section.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key); // Add explicit constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // consistent background
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        children: const [
          Text(
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
          SizedBox(height: 120),
          FooterSection(),
        ],
      ),
    );
  }
}
