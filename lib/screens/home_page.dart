import 'package:flutter/material.dart';
import 'package:prompt_shot/widgets/footer_section.dart';
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

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderSection(),
              const SizedBox(height: 18),
              const InfoSection(),
              const SizedBox(height: 18),
              LimitedGallerySection(),
              const SizedBox(height: 6),
              const FooterSection(),
            ],
          ),
      ),
      
    );
  }
}
