import 'package:flutter/material.dart';

class SensorColors {
  static Color getColor(BuildContext context, String sensor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (sensor.toLowerCase().replaceAll(' ', '_')) {
      case 'temperature':
        return isDark ? const Color(0xFFFF7043) : const Color(0xFFF4511E); // Deep Orange
      case 'humidity':
        return isDark ? const Color(0xFF42A5F5) : const Color(0xFF1E88E5); // Blue
      case 'soil_moisture':
        return isDark ? const Color(0xFF8D6E63) : const Color(0xFF6D4C41); // Brown
      case 'light':
        return isDark ? const Color(0xFFFFB300) : const Color(0xFFFFA000); // Amber
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }
}
