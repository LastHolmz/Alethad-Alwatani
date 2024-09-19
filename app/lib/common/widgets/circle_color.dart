import 'package:flutter/material.dart';

class ColorCircle extends StatelessWidget {
  final Color? color; // Accepts a nullable Color
  final double width;
  final double height;
  final double radius;

  const ColorCircle({
    super.key,
    this.color,
    this.width = 24,
    this.height = 24,
    this.radius = 24,
  });

  @override
  Widget build(BuildContext context) {
    // If color is null, return nothing (null)
    if (color == null) {
      return const SizedBox.shrink(); // This widget renders nothing (no circle)
    }

    // If color is provided, return a small circle
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: width, // You can adjust the size
        height: height, // Adjust the size for the circle
        color: color,
        // decoration: BoxDecoration(
        //   color: color, // Background color of the circle
        //   // shape: BoxShape.circle, // Makes it a circle
        // ),
      ),
    );
  }
}
