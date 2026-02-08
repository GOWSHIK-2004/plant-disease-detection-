import '../models/sensor_reading.dart';
import '../models/plant_health_report.dart';
import 'plant_thresholds.dart';

PlantHealthReport generateHourlyReport({
  required List<SensorReading> readings,
  required String plantName,
}) {
  final thresholds = plantThresholds[plantName]!;
  final total = readings.length;

  int tempAbnormal = 0;
  int humidityAbnormal = 0;
  int moistureAbnormal = 0;

  double tempSum = 0;
  double humiditySum = 0;
  double moistureSum = 0;

  for (final r in readings) {
    tempSum += r.temperature;
    humiditySum += r.humidity;
    moistureSum += r.moisture;

    if (r.temperature < thresholds.minTemp ||
        r.temperature > thresholds.maxTemp) {
      tempAbnormal++;
    }
    if (r.humidity < thresholds.minHumidity ||
        r.humidity > thresholds.maxHumidity) {
      humidityAbnormal++;
    }
    if (r.moisture < thresholds.minMoisture ||
        r.moisture > thresholds.maxMoisture) {
      moistureAbnormal++;
    }
  }

  final tempAbnormalPercent = tempAbnormal / total;
  final humidityAbnormalPercent = humidityAbnormal / total;
  final moistureAbnormalPercent = moistureAbnormal / total;

  // 🔹 Trend detection (simple slope)
  bool trendBad(List<double> values, bool increasingIsBad) {
  if (values.length < 5) return false;

  final firstAvg =
      values.take(2).reduce((a, b) => a + b) / 2;
  final lastAvg =
      values.skip(values.length - 2).reduce((a, b) => a + b) / 2;

  return increasingIsBad ? lastAvg > firstAvg : lastAvg < firstAvg;
}


  final tempTrendBad = trendBad(
      readings.map((r) => r.temperature).toList(), true);
  final humidityTrendBad = trendBad(
      readings.map((r) => r.humidity).toList(), false);
  final moistureTrendBad = trendBad(
      readings.map((r) => r.moisture).toList(), false);

  int persistentSensors = 0;
  if (tempAbnormalPercent >= 0.7) persistentSensors++;
  if (humidityAbnormalPercent >= 0.7) persistentSensors++;
  if (moistureAbnormalPercent >= 0.7) persistentSensors++;

  DiseaseLevel level = DiseaseLevel.healthy;

  if (persistentSensors == 1) {
    level = DiseaseLevel.stress;
  } else if (persistentSensors >= 2) {
    if (tempTrendBad || humidityTrendBad || moistureTrendBad) {
      level = DiseaseLevel.highProbability;
    } else {
      level = DiseaseLevel.sustainedStress;
    }
  }

  return PlantHealthReport(
    startTime: DateTime.now().subtract(const Duration(hours: 1)),
    endTime: DateTime.now(),
    avgTemperature: tempSum / total,
    avgHumidity: humiditySum / total,
    avgMoisture: moistureSum / total,
    tempAbnormalPercent: tempAbnormalPercent,
    humidityAbnormalPercent: humidityAbnormalPercent,
    moistureAbnormalPercent: moistureAbnormalPercent,
    tempTrendBad: tempTrendBad,
    humidityTrendBad: humidityTrendBad,
    moistureTrendBad: moistureTrendBad,
    diseaseLevel: level,
  );
}
