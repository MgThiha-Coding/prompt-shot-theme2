import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:prompt_shot/screens/content_page.dart';
import 'firebase_options.dart';

import 'screens/home_page.dart';
import 'screens/gallery_page.dart';
import 'screens/about_page.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const PromptShotApp());
}

class PromptShotApp extends StatelessWidget {
  const PromptShotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PromptShot',
      theme: darkTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/gallery': (context) => const GalleryPage(),
        '/about': (context) => const AboutPage(),
        '/contact': (context) => const ContactPage(),
      },
    );
  }
}
