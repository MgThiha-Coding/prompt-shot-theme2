import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:prompt_shot/widgets/shimmer.dart';

final latestImagesProvider = FutureProvider<List<QueryDocumentSnapshot>>((
  ref,
) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('images')
      .orderBy('uploaded_at', descending: true)
      .limit(50)
      .get();
  return snapshot.docs;
});

class LimitedGallerySection extends ConsumerStatefulWidget {
  final int limit;

  const LimitedGallerySection({super.key, this.limit = 12});

  @override
  ConsumerState<LimitedGallerySection> createState() =>
      _LimitedGallerySectionState();
}

class _LimitedGallerySectionState extends ConsumerState<LimitedGallerySection> {
  static const double itemWidth = 300;
  static const double itemHeight = 350;

  final ScrollController _autoScrollController = ScrollController();

  void _startAutoScroll() async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted || !_autoScrollController.hasClients) return;

    final maxScroll = _autoScrollController.position.maxScrollExtent;

    _autoScrollController.animateTo(
      maxScroll,
      duration: const Duration(seconds: 15),
      curve: Curves.linear,
    );
  }

  @override
  void dispose() {
    _autoScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final latestImagesAsync = ref.watch(latestImagesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Latest Creations',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerRight,
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.amber.shade300, Colors.amber.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  color: Colors.amberAccent,
                  offset: Offset(0, 4),
                  blurRadius: 6,
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () => context.go('/gallery'),
              icon: const Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: Colors.black87,
              ),
              label: const Text(
                'View More',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),
        latestImagesAsync.when(
          data: (docs) {
            if (docs.isEmpty) {
              return const Text('No images available.');
            }

            final displayedDocs = docs.take(widget.limit).toList();
            _startAutoScroll();

            return SizedBox(
              height: itemHeight,
              child: ListView.builder(
                controller: _autoScrollController,
                scrollDirection: Axis.horizontal,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: displayedDocs.length,
                itemBuilder: (context, index) {
                  final doc = displayedDocs[index];

                  final imageUrl = doc['image_url'] as String? ?? '';
                  final uploadedAt =
                      (doc['uploaded_at'] as Timestamp?)?.toDate() ??
                      DateTime.now();
                  final prompt =
                      doc['prompt'] as String? ?? 'No prompt provided';

                  return Container(
                    width: itemWidth,
                    margin: EdgeInsets.only(
                      right: index == displayedDocs.length - 1 ? 0 : 16,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        final uri = Uri(
                          path: '/gallery/image-detail',
                          queryParameters: {
                            'imageUrl': imageUrl,
                            'prompt': prompt,
                            'uploadedAt': uploadedAt.toIso8601String(),
                          },
                        );
                        context.push(uri.toString());
                      },
                      child: CustomImageBox(imageUrl: imageUrl),
                    ),
                  );
                },
              ),
            );
          },
          loading: () => SizedBox(
            height: itemHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 6,
              itemBuilder: (context, index) => Container(
                width: itemWidth,
                margin: EdgeInsets.only(right: index == 5 ? 0 : 16),
                child: buildShimmerPlaceholder(),
              ),
            ),
          ),
          error: (error, stack) => SizedBox(
            height: itemHeight,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.error_outline, color: Colors.redAccent, size: 40),
                  SizedBox(height: 8),
                  Text(
                    'Failed to load images',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildShimmerPlaceholder() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(color: const Color(0xFF1C1C1C)),
    );
  }
}



class CustomImageBox extends StatelessWidget {
  final String imageUrl;

  const CustomImageBox({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return buildShimmerPlaceholder();
          },
          errorBuilder: (context, error, stackTrace) {
            return buildShimmerPlaceholder();
          },
        ),
      ),
    );
  }
}
