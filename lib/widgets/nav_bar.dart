import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final String selected; // 'home', 'gallery', 'about', 'contact', 'blog', 'privacy'

  const NavBar({super.key, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
      child: Row(
        children: [
          Text(
            'PromptShot',
            style: TextStyle(
              color: Colors.amber.shade400,
              fontWeight: FontWeight.w800,
              fontSize: 26,
              letterSpacing: 1.2,
            ),
          ),
          const Spacer(),
          _NavBarItem(title: 'Home', selected: selected == 'home', route: '/'),
          const SizedBox(width: 24),
          _NavBarItem(title: 'Gallery', selected: selected == 'gallery', route: '/gallery'),
          const SizedBox(width: 24),
          _NavBarItem(title: 'About', selected: selected == 'about', route: '/about'),
          const SizedBox(width: 24),
          _NavBarItem(title: 'Blog', selected: selected == 'blog', route: '/blog'),          // new
          const SizedBox(width: 24),
          _NavBarItem(title: 'Privacy Policy', selected: selected == 'privacy', route: '/privacy'), // new
          const SizedBox(width: 24),
          _NavBarItem(title: 'Contact', selected: selected == 'contact', route: '/contact'),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final String title;
  final bool selected;
  final String route;

  const _NavBarItem({
    required this.title,
    required this.selected,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushReplacementNamed(context, route),
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Text(
          title,
          style: TextStyle(
            color: selected ? Colors.amber : Colors.white70,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
