import 'dart:convert';

class ScanResult {
  final String imagePath;
  final String analysis;
  final DateTime timestamp;

  ScanResult({
    required this.imagePath,
    required this.analysis,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'imagePath': imagePath,
    'analysis': analysis,
    'timestamp': timestamp.toIso8601String(),
  };

  factory ScanResult.fromJson(Map<String, dynamic> json) => ScanResult(
    imagePath: json['imagePath'],
    analysis: json['analysis'],
    timestamp: DateTime.parse(json['timestamp']),
  );
}
