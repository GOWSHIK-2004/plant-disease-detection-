class SensorReading {
  final String id;
  final double temperature;
  final double humidity;
  final double moisture;  // changed from soilMoisture to match API
  final String timestamp;
  final String createdAt;

  SensorReading({
    required this.id,
    required this.temperature,
    required this.humidity,
    required this.moisture,
    required this.timestamp,
    required this.createdAt,
  });

  factory SensorReading.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return SensorReading(
      id: data['id'] as String,
      temperature: (data['temperature'] as num).toDouble(),
      humidity: (data['humidity'] as num).toDouble(),
      moisture: (data['moisture'] as num).toDouble(),
      timestamp: data['timestamp'] as String,
      createdAt: data['createdAt'] as String,
    );
  }
}
