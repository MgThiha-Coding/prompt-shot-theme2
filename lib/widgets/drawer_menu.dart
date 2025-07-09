import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  final VoidCallback onHomeTap;
  final VoidCallback onGalleryTap;
  final VoidCallback onAboutTap;
  final VoidCallback onContactTap;

  const DrawerMenu({
    super.key,
    required this.onHomeTap,
    required this.onGalleryTap,
    required this.onAboutTap,
    required this.onContactTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: const Text(
              'PromptShot Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              onHomeTap();
            },
          ),
          ListTile(
            title: const Text('Gallery'),
            onTap: () {
              Navigator.pop(context);
              onGalleryTap();
            },
          ),
          ListTile(
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
              onAboutTap();
            },
          ),
          ListTile(
            title: const Text('Contact'),
            onTap: () {
              Navigator.pop(context);
              onContactTap();
            },
          ),
        ],
      ),
    );
  }
}
