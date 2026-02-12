// lib/features/weather/presentation/widgets/home/current_weather_skeleton.dart
import 'package:flutter/material.dart';
import '../shared/shimmer_box.dart';

class CurrentWeatherSkeleton extends StatelessWidget {
  const CurrentWeatherSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: const [
            ShimmerBox(height: 18, width: 160),
            SizedBox(height: 12),
            ShimmerBox(height: 56, width: 240),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShimmerBox(height: 14, width: 80),
                SizedBox(width: 16),
                ShimmerBox(height: 14, width: 80),
                SizedBox(width: 16),
                ShimmerBox(height: 14, width: 80),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
