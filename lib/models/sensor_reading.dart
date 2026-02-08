class SensorReading {
  final double temperature;
  final double humidity;
  final double moisture;
  final String createdAt;

  SensorReading({
    required this.temperature,
    required this.humidity,
    required this.moisture,
    required this.createdAt,
  });

  factory SensorReading.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;

    return SensorReading(
      temperature: (data['temperature'] as num).toDouble(),
      humidity: (data['humidity'] as num).toDouble(),
      moisture: (data['moisture'] as num).toDouble(),
      // 🔥 Generate timestamp locally if ESP32 doesn't send it
      createdAt: data['createdAt'] ??
          DateTime.now().toIso8601String(),
    );
  }
}
