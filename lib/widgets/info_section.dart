import 'package:flutter/material.dart';

class InfoSection extends StatelessWidget {
  const InfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Align text start
      children: [
        Text(
          'PromptShot is a curated gallery showcasing stunning AI-generated images created from creative prompts. Explore, download, and get inspired by the power of imagination combined with technology.',
          style: TextStyle(fontSize: 18, color: Colors.white70, height: 1.5),
        ),
       
      ],
    );
  }
}
