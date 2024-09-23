import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:e_commerce/constants/global_variables.dart';

const padding = GlobalVariables.defaultPadding;

class Skeleton extends StatelessWidget {
  const Skeleton({
    super.key,
    this.height = 16,
    this.width = 16,
    this.borederRadius = GlobalVariables.defaultPadding,
  });

  final double height, width;
  final double borederRadius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.secondary,
      highlightColor: Theme.of(context).colorScheme.primary,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface,
          borderRadius: BorderRadius.circular(borederRadius),
        ),
      ),
    );
  }
}

class CircularSkeleton extends StatelessWidget {
  const CircularSkeleton({super.key, this.size = 20});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.secondary,
      highlightColor: Theme.of(context).colorScheme.primary,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.04)),
      ),
    );
  }
}
