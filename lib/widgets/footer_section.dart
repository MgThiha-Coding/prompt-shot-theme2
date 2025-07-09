import 'package:flutter/material.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey[900],
      padding: const EdgeInsets.symmetric(vertical: 22),
      child: const Text(
        '© 2025 PromptShot. All rights reserved.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.amber, fontSize: 14),
      ),
    );
  }
}
