import 'package:flutter/material.dart';
import '../shared/shimmer_box.dart';

class CityMapSkeleton extends StatelessWidget {
  const CityMapSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: const SizedBox(
        height: 230,
        child: Stack(
          children: [
            ShimmerBox(height: 190, width: double.infinity),
            Positioned(
              left: 12,
              right: 12,
              top: 12,
              child: ShimmerBox(height: 46, width: double.infinity),
            ),
          ],
        ),
      ),
    );
  }
}
