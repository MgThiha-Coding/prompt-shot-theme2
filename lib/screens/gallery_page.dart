import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prompt_shot/widgets/animated_loader.dart';
import 'package:prompt_shot/widgets/image_card.dart';
import 'package:prompt_shot/widgets/image_detail_page.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final ScrollController _scrollController = ScrollController();
  final List<DocumentSnapshot> _images = [];
  bool _isLoading = false;
  bool _hasMore = true;
  DocumentSnapshot? _lastDocument;
  static const int _limit = 10;

  @override
  void initState() {
    super.initState();
    _fetchImages();
    _scrollController.addListener(_scrollListener);
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

  Future<void> _fetchImages() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

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
      _images.addAll(snapshot.docs);
    }

    setState(() {
      _isLoading = false;
      _hasMore = snapshot.docs.length == _limit;
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 300 &&
        !_isLoading &&
        _hasMore) {
      _fetchImages();
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: _images.isEmpty && _isLoading
          ? const Center(child: AnimatedLoader())
          : GridView.builder(
              controller: _scrollController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: getCrossAxisCount(width),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: _images.length + (_hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < _images.length) {
                  final doc = _images[index];
                  return ImageCard(
                    imageUrl: doc['image_url'],
                    uploadedAt: (doc['uploaded_at'] as Timestamp).toDate(),
                    prompt: doc['prompt'] ?? 'No prompt provided',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ImageDetailPage(
                            imageUrl: doc['image_url'],
                            uploadedAt: (doc['uploaded_at'] as Timestamp).toDate(),
                            prompt: doc['prompt'] ?? 'No prompt provided',
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
    );
  }
}
