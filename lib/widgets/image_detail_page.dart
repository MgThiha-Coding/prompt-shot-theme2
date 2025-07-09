import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Clipboard
import 'package:http/http.dart' as http;
import 'dart:html' as html;

import 'package:prompt_shot/screens/content_page.dart';
import '../widgets/nav_bar.dart';
import '../widgets/footer_section.dart';

class ImageDetailPage extends StatelessWidget {
  final String imageUrl;
  final DateTime uploadedAt;
  final String prompt;

  const ImageDetailPage({
    super.key,
    required this.imageUrl,
    required this.uploadedAt,
    required this.prompt,
  });

  void _copyPrompt(BuildContext context) {
    Clipboard.setData(ClipboardData(text: prompt));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Prompt copied to clipboard!')),
    );
  }

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
        SnackBar(content: Text('Error downloading image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Scaffold(
      appBar: isMobile
          ? AppBar(
              title: const Text('Image Detail'),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              iconTheme: const IconThemeData(color: Colors.amber),
            )
          : null,
      drawer: isMobile ? DrawerMenu() : null,
      body: Column(
        children: [
          if (!isMobile) const NavBar(selected: ''),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: isMobile
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _imageView(context),
                            const SizedBox(height: 8),
                            _downloadButton(context),
                            const SizedBox(height: 24),
                            _promptView(context),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 24),
                                child: _promptView(context),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _imageView(context),
                                  const SizedBox(height: 8),
                                  _downloadButton(context),
                                ],
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
          const FooterSection(),
        ],
      ),
    );
  }

  Widget _promptView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Prompt',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          prompt,
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () => _copyPrompt(context),
          icon: const Icon(Icons.copy, size: 18),
          label: const Text('Copy Prompt'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Uploaded At: ${uploadedAt.toLocal().toString().split('.')[0]}',
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _imageView(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 420,
        color: Colors.grey.shade900,
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain, // Show entire image within 400px height
          width: double.infinity,
          loadingBuilder: (_, child, progress) =>
              progress == null ? child : const Center(child: CircularProgressIndicator()),
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.broken_image, size: 80),
        ),
      ),
    );
  }

  Widget _downloadButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _downloadImage(context),
      icon: const Icon(Icons.download, size: 18),
      label: const Text('Download Image'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
