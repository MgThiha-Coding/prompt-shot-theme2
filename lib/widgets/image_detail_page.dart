import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'package:shimmer/shimmer.dart';

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

  Widget _buildShimmerPlaceholder(double height) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF1C1C1C),
      highlightColor: const Color(0xFF2A2A2A),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1C),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _imageView(context, 400),
                    const SizedBox(height: 12),
                    _buttonRow(context),
                    const SizedBox(height: 24),
                    _promptBox(context, 400),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: SizedBox(
                        height: 450,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _promptBox(context, 370),
                            const SizedBox(height: 10),
                            _buttonRow(context),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 5,
                      child: _imageView(context, 450),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _promptBox(BuildContext context, double height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Prompt',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: height,
          child: TextField(
            controller: TextEditingController(text: prompt),
            readOnly: true,
            maxLines: null,
            expands: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade900,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
        ),
      ],
    );
  }

  Widget _imageView(BuildContext context, double height) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: height,
        color: Colors.grey.shade900,
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
          width: double.infinity,
          loadingBuilder: (_, child, progress) =>
              progress == null ? child : _buildShimmerPlaceholder(height),
          errorBuilder: (_, __, ___) => _buildShimmerPlaceholder(height), // shimmer on error too
        ),
      ),
    );
  }

  Widget _buttonRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _copyPrompt(context),
            icon: const Icon(Icons.copy, size: 18),
            label: const Text('Copy Prompt'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _downloadImage(context),
            icon: const Icon(Icons.download, size: 20),
            label: const Text('Download Photo'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
