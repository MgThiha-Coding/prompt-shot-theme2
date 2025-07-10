// wallpaper_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'package:shimmer/shimmer.dart';

class WallpaperDetailPage extends StatelessWidget {
  final String imageUrl;
  final DateTime? uploadedAt; // optional if you want to show

  const WallpaperDetailPage({
    super.key,
    required this.imageUrl,
    this.uploadedAt,
  });

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

  Future<void> _downloadImage(BuildContext context) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..target = 'blank'
          ..download = 'wallpaper.jpg';
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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _imageView(context, 400),
                    const SizedBox(height: 12),
                    _buttonRow(context),
                    if (uploadedAt != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          'Uploaded: ${uploadedAt!.toLocal().toString().split(' ')[0]}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 6,
                      child: _imageView(context, 450),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 4,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (uploadedAt != null)
                            Text(
                              'Uploaded: ${uploadedAt!.toLocal().toString().split(' ')[0]}',
                              style: const TextStyle(color: Colors.white70),
                            ),
                          const SizedBox(height: 12),
                          _buttonRow(context),
                        ],
                      ),
                    )
                  ],
                ),
        ),
      ),
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
          fit: BoxFit.cover,
          width: double.infinity,
          loadingBuilder: (_, child, progress) =>
              progress == null ? child : _buildShimmerPlaceholder(height),
          errorBuilder: (_, __, ___) => _buildShimmerPlaceholder(height),
        ),
      ),
    );
  }

  Widget _buttonRow(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _downloadImage(context),
      icon: const Icon(Icons.download, size: 20),
      label: const Text('Download Wallpaper'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
