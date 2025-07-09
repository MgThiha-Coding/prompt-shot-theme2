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
  static const double _radius = 12;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1, milliseconds: 500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = Colors.blueAccent.shade700;

    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          final angle = 2 * pi / _dotCount;

          return SizedBox(
            width: _radius * 2 + 24,
            height: _radius * 2 + 24,
            child: Stack(
              children: List.generate(_dotCount, (index) {
                final currentAngle = angle * index + (_controller.value * 2 * pi);
                final dx = cos(currentAngle) * _radius + _radius + 12;
                final dy = sin(currentAngle) * _radius + _radius + 12;

                final opacity = (sin(currentAngle + _controller.value * 2 * pi) + 1) / 2;

                return Positioned(
                  left: dx,
                  top: dy,
                  child: Opacity(
                    opacity: opacity.clamp(0.3, 1.0),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: baseColor.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: baseColor.withOpacity(opacity * 0.5),
                            blurRadius: 4,
                            spreadRadius: 0.5,
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
