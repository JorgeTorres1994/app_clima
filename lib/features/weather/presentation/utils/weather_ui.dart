// lib/features/weather/presentation/utils/weather_ui.dart
import 'package:flutter/material.dart';

double cToF(double c) => (c * 9 / 5) + 32;

LinearGradient gradientForCondition(String condition) {
  final c = condition.toLowerCase();

  if (c.contains('rain') || c.contains('lluv')) {
    return const LinearGradient(
      colors: [Color(0xFF3B82F6), Color(0xFF93C5FD)],
    );
  } else if (c.contains('storm') || c.contains('torment')) {
    return const LinearGradient(
      colors: [Color(0xFF312E81), Color(0xFF4338CA)],
    );
  } else if (c.contains('cloud') || c.contains('nubl')) {
    return const LinearGradient(
      colors: [Color(0xFF64748B), Color(0xFF94A3B8)],
    );
  }

  return const LinearGradient(
    colors: [Color(0xFF0EA5E9), Color(0xFF38BDF8)],
  );
}
