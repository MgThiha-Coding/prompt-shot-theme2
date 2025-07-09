import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
           Padding(
             padding: const EdgeInsets.all(8.0),
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
          _buildDrawerItem(context, 'Home', '/'),
          _buildDrawerItem(context, 'Gallery', '/gallery'),
          _buildDrawerItem(context, 'About', '/about'),
          _buildDrawerItem(context, 'Blog', '/blog'), // new
          _buildDrawerItem(context, 'Privacy Policy', '/privacy'), // new
          _buildDrawerItem(context, 'Contact', '/contact'),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, String title, String route) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.pop(context); // close drawer first
        context.go(route); // navigate using go_router
      },
    );
  }
}
