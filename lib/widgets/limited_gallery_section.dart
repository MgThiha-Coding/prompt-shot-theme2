import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:prompt_shot/widgets/shimmer.dart';
import 'package:prompt_shot/widgets/image_card.dart';

final latestImagesProvider = FutureProvider<List<QueryDocumentSnapshot>>((ref) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('images')
      .orderBy('uploaded_at', descending: true)
      .limit(50)  // fetch more images so home page can show more if needed
      .get();
  return snapshot.docs;
});

class LimitedGallerySection extends ConsumerWidget {
  final int crossAxisCount;
  final int limit;

  // Default 12 images shown on home page, 6 columns by default
  const LimitedGallerySection({
    super.key,
    this.crossAxisCount = 6,
    this.limit = 12,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latestImagesAsync = ref.watch(latestImagesProvider);

    final gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 0.75,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        const Text(
          'Latest Creations',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        latestImagesAsync.when(
          data: (docs) {
            if (docs.isEmpty) {
              return const Text('No images available.');
            }

            final displayedDocs = docs.take(limit).toList();

            // Calculate height based on rows needed (approx 200 height per row)
            final rowCount = (displayedDocs.length / crossAxisCount).ceil();
            final gridHeight = rowCount * 200.0;

            return SizedBox(
              height: gridHeight,
              child: GridView.builder(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                gridDelegate: gridDelegate,
                itemCount: displayedDocs.length,
                itemBuilder: (context, index) {
                  final doc = displayedDocs[index];
                  final imageUrl = doc['image_url'];
                  final uploadedAt = (doc['uploaded_at'] as Timestamp).toDate();
                  final prompt = doc['prompt'] ?? 'No prompt provided';

                  return ImageCard(
                    key: ValueKey(doc.id),
                    imageUrl: imageUrl,
                    uploadedAt: uploadedAt,
                    prompt: prompt,
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
                  );
                },
              ),
            );
          },
          loading: () => SizedBox(
            height: 300,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: gridDelegate,
              itemCount: 6,
              itemBuilder: (context, index) => buildShimmerPlaceholder(),
            ),
          ),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () => context.go('/gallery'),
            icon: const Icon(Icons.arrow_forward),
            label: const Text('View More'),
          ),
        ),
      ],
    );
  }
}