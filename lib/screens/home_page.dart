import 'package:flutter/material.dart';
import '../widgets/limited_gallery_section.dart';
import '../widgets/header_section.dart';
import '../widgets/info_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  int getCrossAxisCount(double width) {
    if (width >= 1200) return 4;
    if (width >= 900) return 3;
    if (width >= 600) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeaderSection(),
          const SizedBox(height: 24),
          const InfoSection(),
          const SizedBox(height: 32),
          LimitedGallerySection(crossAxisCount: getCrossAxisCount(width)),
          const SizedBox(height: 70),
        ],
      ),
    );
  }
}
