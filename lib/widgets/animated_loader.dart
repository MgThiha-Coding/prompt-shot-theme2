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
  static const int _dotCount = 12;
  static const double _radius = 15;  // decreased from 30 to 15

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
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          final angle = 2 * pi / _dotCount;

          return SizedBox(
            width: _radius * 2 + 20,
            height: _radius * 2 + 20,
            child: Stack(
              children: List.generate(_dotCount, (index) {
                final currentAngle =
                    angle * index + (_controller.value * 2 * pi);
                final dx = cos(currentAngle) * _radius + _radius + 10;
                final dy = sin(currentAngle) * _radius + _radius + 10;

                final fade = (sin(currentAngle + _controller.value * 2 * pi) + 1) / 2;

                return Positioned(
                  left: dx,
                  top: dy,
                  child: Opacity(
                    opacity: fade.clamp(0.2, 1.0),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.indigoAccent,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.indigoAccent.withOpacity(fade),
                            blurRadius: 8,
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
