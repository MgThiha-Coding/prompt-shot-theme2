import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:prompt_shot/widgets/animated_loader.dart';
import 'dart:html' as html;
import 'package:prompt_shot/widgets/footer_section.dart';

final wallpaperNotifierProvider =
    StateNotifierProvider<WallpaperNotifier, WallpaperState>((ref) {
  return WallpaperNotifier();
});

class WallpaperState {
  final List<QueryDocumentSnapshot> wallpapers;
  final bool isLoading;
  final bool hasMore;

  WallpaperState({
    required this.wallpapers,
    required this.isLoading,
    required this.hasMore,
  });

  WallpaperState copyWith({
    List<QueryDocumentSnapshot>? wallpapers,
    bool? isLoading,
    bool? hasMore,
  }) {
    return WallpaperState(
      wallpapers: wallpapers ?? this.wallpapers,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class WallpaperNotifier extends StateNotifier<WallpaperState> {
  static const int _limit = 10;
  DocumentSnapshot? _lastDocument;

  WallpaperNotifier()
      : super(WallpaperState(wallpapers: [], isLoading: false, hasMore: true)) {
    fetchWallpapers();
  }

  Future<void> fetchWallpapers() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    Query query = FirebaseFirestore.instance
        .collection('wallpapers')
        .orderBy('uploaded_at', descending: true)
        .limit(_limit);

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    final snapshot = await query.get();

    if (snapshot.docs.isNotEmpty) {
      _lastDocument = snapshot.docs.last;
    }

    final allWallpapers = [...state.wallpapers, ...snapshot.docs];

    state = state.copyWith(
      wallpapers: allWallpapers,
      isLoading: false,
      hasMore: snapshot.docs.length == _limit,
    );
  }
}

class WallpaperPage extends ConsumerStatefulWidget {
  const WallpaperPage({super.key});

  @override
  ConsumerState<WallpaperPage> createState() => _WallpaperPageState();
}

class _WallpaperPageState extends ConsumerState<WallpaperPage> {
  late ScrollController _scrollController;
  late PageController _pageController;
  Timer? _carouselTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _pageController = PageController(viewportFraction: 0.85);

    _scrollController.addListener(() {
      final notifier = ref.read(wallpaperNotifierProvider.notifier);
      final state = ref.read(wallpaperNotifierProvider);

      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 300 &&
          !state.isLoading &&
          state.hasMore) {
        notifier.fetchWallpapers();
      }
    });

    _startAutoPlay();
  }

  void _startAutoPlay() {
    _carouselTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      final state = ref.read(wallpaperNotifierProvider);
      if (state.wallpapers.isEmpty || !_pageController.hasClients) return;

      _currentPage++;
      if (_currentPage >= state.wallpapers.length) {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    _carouselTimer?.cancel();
    super.dispose();
  }

  int getCrossAxisCount(double width) {
    if (width >= 1200) return 4; // fixed 4 columns for wide screens
    if (width >= 900) return 3;
    if (width >= 600) return 2;
    return 1;
  }

  Future<void> downloadImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", "wallpaper.jpg")
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to download image')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error downloading image: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(wallpaperNotifierProvider);
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
            'Wallpapers',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w300,
              color: Colors.white,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 16),

          // === Carousel slider with autoplay, no download button ===
          SizedBox(
            height: 300,
            child: state.wallpapers.isEmpty
                ? AnimatedLoader()
                : PageView.builder(
                    controller: _pageController,
                    itemCount: state.wallpapers.length,
                    itemBuilder: (context, index) {
                      final doc = state.wallpapers[index];
                      final imageUrl = doc['image_url'];
                      final uploadedAt = (doc['uploaded_at'] as Timestamp).toDate();

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: GestureDetector(
                          onTap: () {
                            final uri = Uri(
                              path: '/wallpaper/detail',
                              queryParameters: {
                                'imageUrl': imageUrl,
                                'uploadedAt': uploadedAt.toIso8601String(),
                              },
                            );
                            context.push(uri.toString());
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              loadingBuilder: (_, child, progress) =>
                                  progress == null
                                      ? child
                                      : const Center(
                                          child: CircularProgressIndicator.adaptive(),
                                        ),
                              errorBuilder: (_, __, ___) =>
                                  Container(color: Colors.grey.shade900),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          const SizedBox(height: 32),

          if (state.wallpapers.isEmpty && state.isLoading)
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
              itemCount: state.wallpapers.length,
              itemBuilder: (context, index) {
                final doc = state.wallpapers[index];
                final imageUrl = doc['image_url'];
                final uploadedAt = (doc['uploaded_at'] as Timestamp).toDate();

                return GestureDetector(
                  onTap: () {
                    final uri = Uri(
                      path: '/wallpaper/detail',
                      queryParameters: {
                        'imageUrl': imageUrl,
                        'uploadedAt': uploadedAt.toIso8601String(),
                      },
                    );
                    context.go(uri.toString());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return buildShimmerPlaceholder();
                              },
                              errorBuilder: (context, error, stackTrace) =>
                                  buildShimmerPlaceholder(),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(12),
                            ),
                          ),
                          child: TextButton.icon(
                            onPressed: () async {
                              await downloadImage(imageUrl);
                            },
                            icon: const Icon(
                              Icons.download,
                              color: Colors.black,
                            ),
                            label: const Text(
                              'Download',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

          const SizedBox(height: 48),
          const FooterSection(),
        ],
      ),
    );
  }

  Widget buildShimmerPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
