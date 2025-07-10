import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey[900],
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '© 2025 PromptShot. All rights reserved.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.amber, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text.rich(
            TextSpan(
              style: const TextStyle(color: Colors.white70, fontSize: 12),
              children: [
                const TextSpan(text: "Developed by "),
                TextSpan(
                  text: "PromptShot",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent[200],
                  ),
                ),
                const TextSpan(text: " • Built with "),
                TextSpan(
                  text: "Flutter",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent[200],
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  context.go('/privacy'); // GoRouter navigation
                },
                child: const Text('Privacy Policy',
                    style: TextStyle(color: Colors.amber)),
              ),
              const SizedBox(width: 12),
              TextButton(
                onPressed: () {
                  context.go('/contact'); // GoRouter navigation
                },
                child: const Text('Contact',
                    style: TextStyle(color: Colors.amber)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
