// lib/features/weather/presentation/widgets/shared/shimmer_box.dart
import 'package:flutter/material.dart';

class ShimmerBox extends StatelessWidget {
  final double height, width;
  const ShimmerBox({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme.surfaceVariant.withOpacity(.38);
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: c,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
