import 'package:flutter/material.dart';

LinearGradient gradientFor(String condition) {
  final c = condition.toLowerCase();
  if (c.contains('lluv') || c.contains('rain')) {
    return const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF93C5FD)]);
  } else if (c.contains('nubl') || c.contains('cloud')) {
    return const LinearGradient(colors: [Color(0xFF64748B), Color(0xFF94A3B8)]);
  } else { // despejado / clear
    return const LinearGradient(colors: [Color(0xFF0EA5E9), Color(0xFF38BDF8)]);
  }
}
