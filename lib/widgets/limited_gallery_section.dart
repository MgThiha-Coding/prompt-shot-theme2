import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prompt_shot/widgets/image_card.dart';
import 'package:prompt_shot/widgets/image_detail_page.dart';

class LimitedGallerySection extends StatelessWidget {
  final int crossAxisCount;

  const LimitedGallerySection({super.key, required this.crossAxisCount});

  Future<List<QueryDocumentSnapshot>> _fetchLatestImages() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('images')
        .orderBy('uploaded_at', descending: true)
        .limit(6)
        .get();
    return snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Latest Creations',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        FutureBuilder<List<QueryDocumentSnapshot>>(
          future: _fetchLatestImages(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final docs = snapshot.data ?? [];

            if (docs.isEmpty) {
              return const Text('No images available.');
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final doc = docs[index];
                final imageUrl = doc['image_url'];
                final uploadedAt = (doc['uploaded_at'] as Timestamp).toDate();
                final prompt = doc['prompt'] ?? 'No prompt provided';

                return ImageCard(
                  imageUrl: imageUrl,
                  uploadedAt: uploadedAt,
                  prompt: prompt,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ImageDetailPage(
                          imageUrl: imageUrl,
                          uploadedAt: uploadedAt,
                          prompt: prompt,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/gallery'),
            icon: const Icon(Icons.arrow_forward),
            label: const Text('View More'),
          ),
        ),
      ],
    );
  }
}
