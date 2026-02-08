enum DiseaseLevel {
  healthy,
  stress,
  sustainedStress,
  highProbability,
}

class PlantHealthReport {
  final DateTime startTime;
  final DateTime endTime;

  final double avgTemperature;
  final double avgHumidity;
  final double avgMoisture;

  final double tempAbnormalPercent;
  final double humidityAbnormalPercent;
  final double moistureAbnormalPercent;

  final bool tempTrendBad;
  final bool humidityTrendBad;
  final bool moistureTrendBad;

  final DiseaseLevel diseaseLevel;

  PlantHealthReport({
    required this.startTime,
    required this.endTime,
    required this.avgTemperature,
    required this.avgHumidity,
    required this.avgMoisture,
    required this.tempAbnormalPercent,
    required this.humidityAbnormalPercent,
    required this.moistureAbnormalPercent,
    required this.tempTrendBad,
    required this.humidityTrendBad,
    required this.moistureTrendBad,
    required this.diseaseLevel,
  });
}
