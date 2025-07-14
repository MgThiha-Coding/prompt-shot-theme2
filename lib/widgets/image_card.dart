import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:html' as html;
import 'package:shimmer/shimmer.dart';

class ImageCard extends StatefulWidget {
  final String imageUrl;
  final DateTime uploadedAt;
  final String prompt;
  final String title;
  final VoidCallback? onTap;

  const ImageCard({
    required this.imageUrl,
    required this.uploadedAt,
    required this.prompt,
    required this.title,
    this.onTap,
    super.key,
  });

  @override
  State<ImageCard> createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  bool _copied = false;

  String get formattedDate =>
      DateFormat('yyyy-MM-dd HH:mm:ss').format(widget.uploadedAt);

  void _copyPrompt() {
    html.window.navigator.clipboard?.writeText(widget.prompt);
    setState(() {
      _copied = true;
    });
    // Reset back to "Copy Prompt" after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _copied = false;
        });
      }
    });
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
      onTap: widget.onTap,
      child: Card(
        color: Colors.grey.shade900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Column(
          children: [
            // Image fits container fully with BoxFit.cover
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(14),
                ),
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return buildShimmerPlaceholder();
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return buildShimmerPlaceholder();
                  },
                ),
              ),
            ),

            // Title with transparent background and opacity
            if (widget.title.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 12,
                ),
                color: Colors.black.withOpacity(0.4),
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

            // Prompt & Copy button area with opacity background
            Container(
              color: Colors.black.withOpacity(0.4),
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
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
                            widget.prompt,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Container(
                        width: double.infinity,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 8,
                              child: ElevatedButton.icon(
                                onPressed: _copyPrompt,
                                icon: const Icon(
                                  Icons.copy,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  _copied ? 'Copied' : 'Copy Prompt',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber.withOpacity(0.85),
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                onPressed: widget.onTap,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber.withOpacity(0.85),
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  minimumSize: const Size(40, 40),
                                ),
                                child: const Icon(
                                  Icons.info_outline,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
