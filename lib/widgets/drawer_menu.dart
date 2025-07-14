import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'PromptShot',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
                letterSpacing: 1.1,
              ),
            ),
          ),

          // ✅ Optional: Show horizontal mini nav on mobile only
          if (isMobile)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildMiniNavButton(context, 'Home', '/'),
                    _buildMiniNavButton(context, 'Gallery', '/gallery'),
                    _buildMiniNavButton(context, 'Wallpapers', '/wallpapers'),
                  ],
                ),
              ),
            ),

          const Divider(),

          // Full menu still in drawer
          _buildDrawerItem(context, 'About', '/about'),
          _buildDrawerItem(context, 'Blog', '/blog'),
          _buildDrawerItem(context, 'Privacy Policy', '/privacy'),
          _buildDrawerItem(context, 'Contact', '/contact'),
        ],
      ),
    );
  }

  Widget _buildMiniNavButton(BuildContext context, String title, String route) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.amber,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        onPressed: () {
          Navigator.pop(context);
          context.go(route);
        },
        child: Text(title),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, String title, String route) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        context.go(route);
      },
    );
  }
}
