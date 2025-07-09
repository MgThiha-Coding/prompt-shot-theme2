import 'package:flutter/material.dart';

class BlogPostPage extends StatelessWidget {
  const BlogPostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: const Text(
        'Discover Your Ambition, Visualize Your Future\n\n'
        'At PromptShot, we believe that inspiration begins with a vision — a glimpse of who you aspire to be. Our platform transforms your own photo into striking, AI-generated images that reflect your dreams: whether as a doctor, engineer, creator, or any professional you envision.\n\n'
        'Using advanced AI technology, PromptShot creates realistic portraits that embody your passion and potential. These images are more than art; they are motivating symbols of your journey toward your ambitions.\n\n'
        'Seeing yourself as the professional you want to become can spark the confidence and drive needed to reach that future. PromptShot helps make your dreams visible and tangible, empowering you to take the next step.\n\n'
        'This site is built with Flutter and Firebase, hosted on Vercel. All images are AI-generated and intended for inspiration and educational purposes only. We do not sell or distribute any AI models or images commercially.\n\n'
        'Join us and let your imagination guide you — because your future self is closer than you think.',
        style: TextStyle(fontSize: 18, color: Colors.white70, height: 1.5),
      ),
    );
  }
}
