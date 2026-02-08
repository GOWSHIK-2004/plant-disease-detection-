class PlantThreshold {
  final int minTemp;
  final int maxTemp;
  final int minHumidity;
  final int maxHumidity;
  final int minMoisture;
  final int maxMoisture;

  const PlantThreshold({
    required this.minTemp,
    required this.maxTemp,
    required this.minHumidity,
    required this.maxHumidity,
    required this.minMoisture,
    required this.maxMoisture,
  });
}

final Map<String, PlantThreshold> plantThresholds = {
  "Paddy Rice": PlantThreshold(
    minTemp: 33,
    maxTemp: 35,
    minHumidity: 60,
    maxHumidity: 95,
    minMoisture: 70,
    maxMoisture: 95,
  ),
  "Turmeric": PlantThreshold(
    minTemp: 33,
    maxTemp: 30,
    minHumidity: 60,
    maxHumidity: 85,
    minMoisture: 40,
    maxMoisture: 65,
  ),
  "Sugarcane": PlantThreshold(
    minTemp: 33,
    maxTemp: 35,
    minHumidity: 60,
    maxHumidity: 85,
    minMoisture: 60,
    maxMoisture: 85,
  ),
  "Groundnut": PlantThreshold(
    minTemp: 33,
    maxTemp: 30,
    minHumidity: 50,
    maxHumidity: 75,
    minMoisture: 40,
    maxMoisture: 60,
  ),
  "Brinjal": PlantThreshold(
    minTemp: 33,
    maxTemp: 30,
    minHumidity: 55,
    maxHumidity: 80,
    minMoisture: 50,
    maxMoisture: 70,
  ),
  "Coconut": PlantThreshold(
    minTemp: 33,
    maxTemp: 32,
    minHumidity: 70,
    maxHumidity: 95,
    minMoisture: 40,
    maxMoisture: 65,
  ),
  "Banana": PlantThreshold(
    minTemp: 33,
    maxTemp: 32,
    minHumidity: 70,
    maxHumidity: 95,
    minMoisture: 60,
    maxMoisture: 85,
  ),
};
