import 'package:flutter/material.dart';
import 'package:prompt_shot/screens/about_page.dart';
import '../widgets/nav_bar.dart';
import '../widgets/footer_section.dart';

class BlogPostPage extends StatelessWidget {
  const BlogPostPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Scaffold(
      appBar: isMobile
          ? AppBar(
              title: const Text('Blog: AI Art Tips'),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              iconTheme: const IconThemeData(color: Colors.amber),
            )
          : null,
      drawer: isMobile ? const DrawerMenu() : null,
      body: Column(
        children: [
          if (!isMobile) const NavBar(selected: 'blog'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: const Text(
                'About PromptShot\n\n'
                'PromptShot is a curated gallery of stunning AI-generated artworks created from creative text prompts and original photo transformations. '
                'We use advanced AI tools to explore the blend between human creativity and machine imagination.\n\n'
                'This website is intended for inspiration and educational use only. All images are AI-generated and not for resale or commercial use.\n\n'
                'PromptShot is built with Flutter, Firebase, and hosted on Vercel.\n\n'
                'Disclaimer: We do not claim ownership of any AI models used to generate content. We do not sell or distribute these images commercially.',
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
            ),
          ),
          const FooterSection(),
        ],
      ),
    );
  }
}
