/*
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:prompt_shot/screens/content_page.dart';

// Firebase options
import 'firebase_options.dart';

// Screens
import 'screens/home_page.dart';
import 'screens/gallery_page.dart';
import 'screens/about_page.dart';
import 'screens/blog_post_page.dart';
import 'screens/pavicy_policy_page.dart';

// Shared UI
import 'widgets/nav_bar.dart';
import 'widgets/footer_section.dart';
import 'widgets/drawer_menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const PromptShotApp());
}

class PromptShotApp extends StatelessWidget {
  const PromptShotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData.dark(),
      title: 'PromptShot',
    );
  }
}

// Detect current active nav route
String getSelectedNavKey(String? path) {
  if (path == null || path == '/') return 'home';
  if (path.startsWith('/gallery')) return 'gallery';
  if (path.startsWith('/about')) return 'about';
  if (path.startsWith('/contact')) return 'contact';
  if (path.startsWith('/privacy')) return 'privacy';
  if (path.startsWith('/blog')) return 'blog';
  return '';
}

final GoRouter _router = GoRouter(
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
              if (!isMobile) NavBar(selected: selected),
              Expanded(child: child),
              const FooterSection(),
            ],
          ),
        );
      },
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomePage()),
        GoRoute(path: '/gallery', builder: (context, state) => const GalleryPage()),
        GoRoute(path: '/about', builder: (context, state) => const AboutPage()),
        GoRoute(path: '/contact', builder: (context, state) => const ContactPage()),
        GoRoute(path: '/privacy', builder: (context, state) => const PrivacyPolicyPage()),
        GoRoute(path: '/blog', builder: (context, state) => const BlogPostPage()),
      ],
    ),
  ],
);
*/
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:prompt_shot/screens/content_page.dart';
import 'package:prompt_shot/screens/pavicy_policy_page.dart';

// Import your Firebase options and screens here
import 'firebase_options.dart';

import 'screens/home_page.dart';
import 'screens/gallery_page.dart';
import 'screens/about_page.dart';
import 'screens/blog_post_page.dart';


import 'widgets/nav_bar.dart';
import 'widgets/footer_section.dart';
import 'widgets/drawer_menu.dart';

// Define your light and dark themes
final darkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: const Color(0xFF0F0F0F),
  primaryColor: const Color(0xFF00BCD4),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF00BCD4),
    secondary: Color(0xFFFFC107),
    surface: Color(0xFF1C1C1C),
    error: Colors.redAccent,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Colors.white70,
    onError: Colors.white,
    brightness: Brightness.dark,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1A1A1A),
    iconTheme: IconThemeData(color: Color(0xFFFFC107)),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
  ),
  cardColor: const Color(0xFF1B1B1B),
  canvasColor: const Color(0xFF262626),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white70),
    bodyMedium: TextStyle(color: Colors.white60),
    bodySmall: TextStyle(color: Colors.white54),
    titleLarge: TextStyle(color: Color(0xFFFFC107)),
    titleMedium: TextStyle(color: Color(0xFF00BCD4)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFFFC107),
      foregroundColor: Colors.black,
      textStyle: const TextStyle(fontWeight: FontWeight.w600),
    ),
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Color(0xFF1A1A1A),
    contentTextStyle: TextStyle(color: Colors.white),
  ),
);

final lightTheme = ThemeData.light().copyWith(
  primaryColor: Colors.blue,
  colorScheme: const ColorScheme.light(
    primary: Colors.blue,
    secondary: Colors.amber,
    surface: Colors.white,
    brightness: Brightness.light,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Colors.black87,
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.blue,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black87),
    bodyMedium: TextStyle(color: Colors.black54),
    bodySmall: TextStyle(color: Colors.black45),
    titleLarge: TextStyle(color: Colors.amber),
    titleMedium: TextStyle(color: Colors.blue),
  ),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const PromptShotApp());
}

class PromptShotApp extends StatefulWidget {
  const PromptShotApp({super.key});

  @override
  State<PromptShotApp> createState() => _PromptShotAppState();
}

class _PromptShotAppState extends State<PromptShotApp> {
  ThemeMode _themeMode = ThemeMode.dark; // default to dark mode

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  // Detect current active nav route
  String getSelectedNavKey(String? path) {
    if (path == null || path == '/') return 'home';
    if (path.startsWith('/gallery')) return 'gallery';
    if (path.startsWith('/about')) return 'about';
    if (path.startsWith('/contact')) return 'contact';
    if (path.startsWith('/privacy')) return 'privacy';
    if (path.startsWith('/blog')) return 'blog';
    return '';
  }

  late final GoRouter _router = GoRouter(
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
                const FooterSection(),
              ],
            ),
          );
        },
        routes: [
          GoRoute(path: '/', builder: (context, state) => const HomePage()),
          GoRoute(path: '/gallery', builder: (context, state) => const GalleryPage()),
          GoRoute(path: '/about', builder: (context, state) => const AboutPage()),
          GoRoute(path: '/contact', builder: (context, state) => const ContactPage()),
          GoRoute(path: '/privacy', builder: (context, state) => const PrivacyPolicyPage()),
          GoRoute(path: '/blog', builder: (context, state) => const BlogPostPage()),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'PromptShot',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
    );
  }
}
