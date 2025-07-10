import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget buildShimmerPlaceholder() {
  return Shimmer.fromColors(
    baseColor: const Color(0xFF1C1C1C),         // Soft dark shimmer base
    highlightColor: const Color(0xFF2A2A2A),    // Slightly lighter shimmer
    child: Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),         // Match base color
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            offset: const Offset(0, 3),
            blurRadius: 5,
          ),
        ],
      ),
    ),
  );
}
