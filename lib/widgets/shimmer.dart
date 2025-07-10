import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget buildShimmerPlaceholder() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[850]!,          
    highlightColor: Colors.grey[700]!,  
    child: Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey[900],          
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            offset: const Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
    ),
  );
}
