import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Your firebase options file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PromptShotPage(),
  ));
}

class PromptShotPage extends StatefulWidget {
  const PromptShotPage({super.key});

  @override
  State<PromptShotPage> createState() => _PromptShotPageState();
}

class _PromptShotPageState extends State<PromptShotPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Stream<QuerySnapshot> getImagesStream() {
    return FirebaseFirestore.instance
        .collection('images')
        .orderBy('uploaded_at', descending: true)
        .snapshots();
  }

  int getCrossAxisCount(double width) {
    if (width >= 1200) return 5;
    if (width >= 900) return 4;
    if (width >= 600) return 3;
    if (width >= 400) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Scaffold(
      key: _scaffoldKey,
      drawer: isMobile ? Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue.shade700),
              child: const Text(
                'PromptShot Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                // Handle navigation
              },
            ),
            ListTile(
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                // Handle navigation
              },
            ),
            ListTile(
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                // Handle navigation
              },
            ),
            ListTile(
              title: const Text('Contact'),
              onTap: () {
                Navigator.pop(context);
                // Handle navigation
              },
            ),
          ],
        ),
      ) : null,
      appBar: isMobile
          ? AppBar(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.blue.shade700),
              title: Text(
                'PromptShot',
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              elevation: 1,
            )
          : null,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          if (!isMobile)
            NavBar(
              onHomeTap: () {},
              onGalleryTap: () {},
              onAboutTap: () {},
              onContactTap: () {},
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeaderSection(),
                  const SizedBox(height: 24),
                  const InfoSection(),
                  const SizedBox(height: 32),
                  const Text(
                    'Gallery',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 800,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final crossAxisCount = getCrossAxisCount(constraints.maxWidth);

                        return StreamBuilder<QuerySnapshot>(
                          stream: getImagesStream(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              // Show 12 placeholder boxes during loading
                              return GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16,
                                  childAspectRatio: 0.75,
                                ),
                                itemCount: 12,
                                itemBuilder: (context, index) => Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              );
                            }
                            if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  'Failed to load images.',
                                  style: TextStyle(color: Colors.black54),
                                ),
                              );
                            }
                            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                              return Center(
                                child: Text(
                                  'No images found.',
                                  style: TextStyle(color: Colors.black54),
                                ),
                              );
                            }

                            return GridView.builder(
                              physics: const BouncingScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: 0.75,
                              ),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                var doc = snapshot.data!.docs[index];
                                return ImageCard(
                                  imageUrl: doc['image_url'],
                                  uploadedAt: (doc['uploaded_at'] as Timestamp).toDate(),
                                  prompt: doc['prompt'] ?? 'No prompt provided',
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 50),
                  const FooterSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ImageCard extends StatelessWidget {
  final String imageUrl;
  final DateTime uploadedAt;
  final String prompt;

  const ImageCard({
    required this.imageUrl,
    required this.uploadedAt,
    required this.prompt,
    super.key,
  });

  String get formattedDate => DateFormat('yyyy-MM-dd HH:mm:ss').format(uploadedAt);

  Future<void> _downloadImage(BuildContext context) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..target = 'blank'
          ..download = 'promptshot_image.jpg';
        anchor.click();
        html.Url.revokeObjectUrl(url);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to download image')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _copyPrompt(BuildContext context) {
    html.window.navigator.clipboard?.writeText(prompt);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Prompt copied!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    color: Colors.grey.shade300,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.broken_image, size: 50, color: Colors.redAccent),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  formattedDate,
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
                const SizedBox(height: 8),
                ExpansionTile(
                  title: const Text(
                    'View Prompt',
                    style: TextStyle(color: Colors.blueAccent, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  children: [
                    Text(prompt, style: const TextStyle(color: Colors.black87)),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () => _copyPrompt(context),
                      icon: const Icon(Icons.copy, size: 18, color: Colors.white),
                      label: const Text('Copy Prompt'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => _downloadImage(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    'Download',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NavBar extends StatelessWidget {
  final VoidCallback onHomeTap;
  final VoidCallback onGalleryTap;
  final VoidCallback onAboutTap;
  final VoidCallback onContactTap;

  const NavBar({
    super.key,
    required this.onHomeTap,
    required this.onGalleryTap,
    required this.onAboutTap,
    required this.onContactTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'PromptShot',
            style: TextStyle(
              color: Colors.blue.shade700,
              fontWeight: FontWeight.w800,
              fontSize: 26,
              letterSpacing: 1.2,
            ),
          ),
          /*
          Row(
            children: [
              NavBarItem(title: 'Home', onTap: onHomeTap),
              const SizedBox(width: 24),
              NavBarItem(title: 'Gallery', onTap: onGalleryTap),
              const SizedBox(width: 24),
              NavBarItem(title: 'About', onTap: onAboutTap),
              const SizedBox(width: 24),
              NavBarItem(title: 'Contact', onTap: onContactTap),
            ],
          ),
          */
        ],
      ),
    );
  }
}

class NavBarItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const NavBarItem({required this.title, required this.onTap, super.key});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      hoverColor: Colors.blueAccent.withOpacity(0.2),
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Text(
          title,
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});
  @override
  Widget build(BuildContext context) {
    return const Text(
      'Welcome to PromptShot',
      style: TextStyle(
        fontSize: 38,
        fontWeight: FontWeight.bold,
        color: Colors.blueAccent,
        letterSpacing: 1.1,
      ),
    );
  }
}

class InfoSection extends StatelessWidget {
  const InfoSection({super.key});
  @override
  Widget build(BuildContext context) {
    return const Text(
      'PromptShot is a curated gallery showcasing stunning AI-generated images created from creative prompts. Explore, download, and get inspired by the power of imagination combined with technology.',
      style: TextStyle(fontSize: 18, color: Colors.black87, height: 1.5),
    );
  }
}

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade100,
      padding: const EdgeInsets.symmetric(vertical: 22),
      child: const Text(
        '© 2025 PromptShot. All rights reserved.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.blue, fontSize: 14),
      ),
    );
  }
}
