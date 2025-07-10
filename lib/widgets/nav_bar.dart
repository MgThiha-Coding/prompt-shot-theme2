import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavBar extends StatelessWidget {
  final String selected; // 'home', 'gallery', etc.
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const NavBar({
    super.key,
    required this.selected,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    if (isMobile) {
      return const SizedBox.shrink(); // Hide NavBar on mobile
    }

    return Container(
      color: Colors.grey[900],
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
      child: Row(
        children: [
          // Title on left
          Text(
            'PromptShot',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 26,
              letterSpacing: 1.2,
            ),
          ),

          const Spacer(),

          // Navigation items
          _NavBarItem(title: 'Home', selected: selected == 'home', route: '/'),
          const SizedBox(width: 24),
          _NavBarItem(
            title: 'Gallery',
            selected: selected == 'gallery',
            route: '/gallery',
          ),
          const SizedBox(width: 24),

          _NavBarItem(
            title: 'Wallpapers',
            selected: selected == 'wallpapers',
            route: '/wallpapers',
          ),
          const SizedBox(width: 24),
          _NavBarItem(
            title: 'About',
            selected: selected == 'about',
            route: '/about',
          ),
          const SizedBox(width: 24),
          _NavBarItem(
            title: 'Blog',
            selected: selected == 'blog',
            route: '/blog',
          ),
          const SizedBox(width: 10),
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
      onTap: () => context.go(route), // Use go_router navigation here
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
