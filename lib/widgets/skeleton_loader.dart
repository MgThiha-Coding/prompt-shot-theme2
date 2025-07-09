import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonPost extends StatelessWidget {
  const SkeletonPost({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade700,
      highlightColor: Colors.grey.shade500,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Circle for avatar
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 10),
            // Text line 1
            Container(height: 12, color: Colors.grey, width: 150),
            const SizedBox(height: 6),
            // Text line 2
            Container(height: 12, color: Colors.grey, width: 200),
            const SizedBox(height: 10),
            // Rectangular image placeholder
            Container(height: 200, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
