import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prompt_shot/widgets/image_detail_page.dart';
import 'package:prompt_shot/widgets/wallpaper_detail_page.dart';

import 'firebase_options.dart';

import 'screens/home_page.dart';
import 'screens/gallery_page.dart';
import 'screens/about_page.dart';
import 'screens/blog_post_page.dart';
import 'screens/content_page.dart';
import 'screens/pavicy_policy_page.dart';
import 'screens/wallpaper_page.dart';

import 'widgets/nav_bar.dart';
import 'widgets/drawer_menu.dart';

final darkTheme = ThemeData.dark().copyWith(
  // your dark theme here...
);

final lightTheme = ThemeData.light().copyWith(
  // your light theme here...
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: const PromptShotApp()));
}

class PromptShotApp extends StatefulWidget {
  const PromptShotApp({super.key});

  @override
  State<PromptShotApp> createState() => _PromptShotAppState();
}

class _PromptShotAppState extends State<PromptShotApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  String getSelectedNavKey(String? path) {
    if (path == null || path == '/') return 'home';
    if (path.startsWith('/gallery')) return 'gallery';
    if (path.startsWith('/about')) return 'about';
    if (path.startsWith('/contact')) return 'contact';
    if (path.startsWith('/privacy')) return 'privacy';
    if (path.startsWith('/blog')) return 'blog';
    if (path.startsWith('/wallpapers')) return 'wallpapers'; // <-- added
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      routes: [
        ShellRoute(
          builder: (context, state, child) {
            final width = MediaQuery.of(context).size.width;
            final isMobile = width < 800;
            final selected = getSelectedNavKey(state.fullPath);

            return Scaffold(
              appBar: isMobile
                  ? AppBar(
                      title: const Text('PromptShot'),
                      backgroundColor: Colors.black,
                      iconTheme: const IconThemeData(color: Colors.amber),
                    )
                  : null,
              drawer: isMobile ? const DrawerMenu() : null,
              body: Column(
                children: [
                  if (!isMobile)
                    NavBar(
                      selected: selected,
                      isDarkMode: _themeMode == ThemeMode.dark,
                      onThemeChanged: _toggleTheme,
                    ),
                  Expanded(child: child),
                ],
              ),
            );
          },
          routes: [
            GoRoute(path: '/', builder: (context, state) => const HomePage()),

            GoRoute(
              path: '/gallery',
              builder: (context, state) => const GalleryPage(),
            ),

            GoRoute(
              path: '/wallpapers',
              builder: (context, state) => const WallpaperPage(),
            ),

            GoRoute(
              path: '/wallpaper/detail',
              builder: (context, state) {
                final imageUrl = state.uri.queryParameters['imageUrl'] ?? '';
                final uploadedAtStr =
                    state.uri.queryParameters['uploadedAt'] ?? '';
                final uploadedAt = DateTime.tryParse(uploadedAtStr);

                return WallpaperDetailPage(
                  imageUrl: imageUrl,
                  uploadedAt: uploadedAt,
                );
              },
            ),

            GoRoute(
              path: '/gallery/image-detail',
              builder: (context, state) {
                final imageUrl = state.uri.queryParameters['imageUrl'] ?? '';
                final prompt = state.uri.queryParameters['prompt'] ?? '';
                final uploadedAtStr =
                    state.uri.queryParameters['uploadedAt'] ?? '';
                final uploadedAt =
                    DateTime.tryParse(uploadedAtStr) ?? DateTime.now();

                return ImageDetailPage(
                  imageUrl: imageUrl,
                  prompt: prompt,
                  uploadedAt: uploadedAt,
                );
              },
            ),

            GoRoute(
              path: '/about',
              builder: (context, state) => const AboutPage(),
            ),
            GoRoute(
              path: '/contact',
              builder: (context, state) => const ContactPage(),
            ),
            GoRoute(
              path: '/privacy',
              builder: (context, state) => const PrivacyPolicyPage(),
            ),
            GoRoute(
              path: '/blog',
              builder: (context, state) => const BlogPostPage(),
            ),
          ],
        ),
      ],
    );

    return MaterialApp.router(
      title: 'PromptShot',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
    );
  }
}
