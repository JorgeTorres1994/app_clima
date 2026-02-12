// lib/features/weather/presentation/widgets/home/forecast_skeleton.dart
import 'package:flutter/material.dart';
import '../shared/shimmer_box.dart';

class ForecastSkeleton extends StatelessWidget {
  const ForecastSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ShimmerBox(height: 20, width: 140),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: List.generate(
                5,
                (i) => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      ShimmerBox(height: 40, width: 40),
                      SizedBox(width: 12),
                      Expanded(child: ShimmerBox(height: 16, width: double.infinity)),
                      SizedBox(width: 12),
                      ShimmerBox(height: 16, width: 90),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
