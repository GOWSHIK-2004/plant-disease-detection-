import 'plant_thresholds.dart';

List<String> checkPlantHealth({
  required String plantName,
  required int temperature,
  required int humidity,
  required int moisture,
}) {
  final threshold = plantThresholds[plantName];
  if (threshold == null) return [];

  List<String> issues = [];

  if (temperature < threshold.minTemp) {
    issues.add("Temperature too low");
  } else if (temperature > threshold.maxTemp) {
    issues.add("Temperature too high");
  }

  if (humidity < threshold.minHumidity) {
    issues.add("Humidity too low");
  } else if (humidity > threshold.maxHumidity) {
    issues.add("Humidity too high");
  }

  if (moisture < threshold.minMoisture) {
    issues.add("Soil moisture too low");
  } else if (moisture > threshold.maxMoisture) {
    issues.add("Soil moisture too high");
  }

  return issues;
}
