import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:prompt_shot/widgets/image_detail_page.dart';

import 'package:prompt_shot/widgets/shimmer.dart';
import 'package:prompt_shot/widgets/image_card.dart';
import 'package:prompt_shot/widgets/footer_section.dart';

final galleryNotifierProvider =
    StateNotifierProvider<GalleryNotifier, GalleryState>((ref) {
      return GalleryNotifier();
    });

class GalleryState {
  final List<QueryDocumentSnapshot> images;
  final bool isLoading;
  final bool hasMore;

  GalleryState({
    required this.images,
    required this.isLoading,
    required this.hasMore,
  });

  GalleryState copyWith({
    List<QueryDocumentSnapshot>? images,
    bool? isLoading,
    bool? hasMore,
  }) {
    return GalleryState(
      images: images ?? this.images,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class GalleryNotifier extends StateNotifier<GalleryState> {
  static const int _limit = 10;
  DocumentSnapshot? _lastDocument;

  GalleryNotifier()
    : super(GalleryState(images: [], isLoading: false, hasMore: true)) {
    fetchImages();
  }

  Future<void> fetchImages() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    Query query = FirebaseFirestore.instance
        .collection('images')
        .orderBy('uploaded_at', descending: true)
        .limit(_limit);

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    final snapshot = await query.get();

    if (snapshot.docs.isNotEmpty) {
      _lastDocument = snapshot.docs.last;
    }

    final allImages = [...state.images, ...snapshot.docs];

    state = state.copyWith(
      images: allImages,
      isLoading: false,
      hasMore: snapshot.docs.length == _limit,
    );
  }
}

class GalleryPage extends ConsumerStatefulWidget {
  const GalleryPage({super.key});

  @override
  ConsumerState<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends ConsumerState<GalleryPage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      final notifier = ref.read(galleryNotifierProvider.notifier);
      final state = ref.read(galleryNotifierProvider);

      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 300 &&
          !state.isLoading &&
          state.hasMore) {
        notifier.fetchImages();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
    final state = ref.watch(galleryNotifierProvider);
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = getCrossAxisCount(width);
    const shimmerCount = 10;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        children: [
          Text(
            'Gallery',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w300,
              color: Colors.white,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 16),
          // Grid Images
          if (state.images.isEmpty && state.isLoading)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: shimmerCount,
              itemBuilder: (context, index) => buildShimmerPlaceholder(),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: state.images.length,
              itemBuilder: (context, index) {
                final doc = state.images[index];
                final imageUrl = doc['image_url'];
                final uploadedAt = (doc['uploaded_at'] as Timestamp).toDate();
                final prompt = doc['prompt'] ?? 'No prompt provided';

                return ImageCard(
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

          const SizedBox(height: 32),

          if (state.isLoading)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: shimmerCount,
              itemBuilder: (context, index) => buildShimmerPlaceholder(),
            ),

          const SizedBox(height: 48),

          const FooterSection(),
        ],
      ),
    );
  }
}
