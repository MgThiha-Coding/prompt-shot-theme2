import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'package:shimmer/shimmer.dart';

class ImageCard extends StatelessWidget {
  final String imageUrl;
  final DateTime uploadedAt;
  final String prompt;
  final VoidCallback? onTap;

  const ImageCard({
    required this.imageUrl,
    required this.uploadedAt,
    required this.prompt,
    this.onTap,
    super.key,
  });

  String get formattedDate =>
      DateFormat('yyyy-MM-dd HH:mm:ss').format(uploadedAt);

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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _copyPrompt(BuildContext context) {
    html.window.navigator.clipboard?.writeText(prompt);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Prompt copied!')),
    );
  }

  Widget buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF1C1C1C),
      highlightColor: const Color(0xFF2A2A2A),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF1C1C1C),
          borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.grey.shade900,
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
                    return buildShimmerPlaceholder(); // While loading
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return buildShimmerPlaceholder(); // On error too
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  ExpansionTile(
                    title: const Text(
                      'View Prompt',
                      style: TextStyle(
                        color: Colors.amberAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: [
                      SizedBox(
                        height: 120,
                        child: SingleChildScrollView(
                          child: Text(
                            prompt,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: () => _copyPrompt(context),
                        icon: const Icon(Icons.copy, size: 18, color: Color.fromARGB(255, 70, 63, 63)),
                        label: const Text('Copy Prompt',style: TextStyle( color : Color.fromARGB(255, 68, 63, 63)),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _downloadImage(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Download',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
