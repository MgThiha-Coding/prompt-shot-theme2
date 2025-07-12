import 'package:flutter/material.dart';
import 'dart:math';

class AnimatedLoader extends StatefulWidget {
  const AnimatedLoader({super.key});

  @override
  State<AnimatedLoader> createState() => _AnimatedLoaderState();
}

class _AnimatedLoaderState extends State<AnimatedLoader>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  static const int _dotCount = 10;
  static const double _radius = 28; // Increased radius

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final amberColor = Colors.amber.shade400;
    final blueColor = Colors.blueAccent.shade700;

    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          final angle = 2 * pi / _dotCount;

          return SizedBox(
            width: _radius * 2 + 32,
            height: _radius * 2 + 32,
            child: Stack(
              children: List.generate(_dotCount, (index) {
                final currentAngle = angle * index + (_controller.value * 2 * pi);
                final dx = cos(currentAngle) * _radius + _radius + 16;
                final dy = sin(currentAngle) * _radius + _radius + 16;

                final opacity = (sin(currentAngle + _controller.value * 2 * pi) + 1) / 2;

                // Interpolate between blue and amber
                final blendedColor = Color.lerp(amberColor, blueColor, index / _dotCount)!.withOpacity(0.85);

                return Positioned(
                  left: dx,
                  top: dy,
                  child: Opacity(
                    opacity: opacity.clamp(0.3, 1.0),
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: blendedColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: blendedColor.withOpacity(opacity * 0.6),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        },
      ),
    );
  }
}
