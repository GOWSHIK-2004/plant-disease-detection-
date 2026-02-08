import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../models/sensor_reading.dart';
import '../main.dart'; // showPlantHealthAlert
import '../models/plant_health_report.dart';
import '../utils/report_analyzer.dart';

class SensorService {
  // 🔥 ESP32 LOCAL API (ACCESS POINT MODE)
  static const String _localEsp32Url = 'http://192.168.4.1/data';

  // 🔹 Sliding window (5 readings = simulated 1 hour)
  final List<SensorReading> _lastHourReadings = [];

  // 🔹 Generated reports
  final List<PlantHealthReport> _reports = [];
  List<PlantHealthReport> get reports => _reports;

  final _readingsController = StreamController<SensorReading>.broadcast();
  final _historicalController =
      StreamController<List<SensorReading>>.broadcast();

  Timer? _refreshTimer;

  Stream<SensorReading> get latestReadings => _readingsController.stream;
  Stream<List<SensorReading>> get historicalReadings =>
      _historicalController.stream;

  // ==========================
  // AUTO REFRESH
  // ==========================
  void startAutoRefresh() {
    _fetchAndEmitReadings();

    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _fetchAndEmitReadings();
    });
  }

  void dispose() {
    _refreshTimer?.cancel();
    _readingsController.close();
    _historicalController.close();
  }

  // ==========================
  // CORE SENSOR PIPELINE
  // ==========================
  Future<void> _fetchAndEmitReadings() async {
    try {
      final reading = await getLatestReadings();

      // 🔹 Emit live reading to UI
      _readingsController.add(reading);

      // 🔹 Add reading to sliding window
      _lastHourReadings.add(reading);

      if (_lastHourReadings.length > 5) {
        _lastHourReadings.removeAt(0);
      }

      // 🔹 Simulated hourly report
      if (_lastHourReadings.length == 5) {
        final report = generateHourlyReport(
          readings: List.from(_lastHourReadings),
          plantName: "Paddy Rice",
        );

        _reports.add(report);

        if (kDebugMode) {
          print("=================================");
          print("📊 SIMULATED HOURLY REPORT");
          print("Disease Level: ${report.diseaseLevel}");
          print("Temp abnormal %: ${report.tempAbnormalPercent}");
          print("Humidity abnormal %: ${report.humidityAbnormalPercent}");
          print("Moisture abnormal %: ${report.moistureAbnormalPercent}");
          print("=================================");
        }

        if (report.diseaseLevel == DiseaseLevel.highProbability) {
          showPlantHealthAlert(
            plantName: "Paddy Rice",
            issues: ["High disease probability detected"],
          );
        }
      }

      // 🔹 Emit simulated history
      _historicalController.add(List.from(_lastHourReadings));
    } catch (e) {
      if (kDebugMode) {
        print('ESP32 read error: $e');
      }
    }
  }

  // ==========================
  // ESP32 LOCAL API
  // ==========================
 Future<SensorReading> getLatestReadings() async {
  final response = await http
      .get(Uri.parse(_localEsp32Url))
      .timeout(const Duration(seconds: 5));

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    return SensorReading.fromJson(jsonResponse);
  } else {
    throw Exception('ESP32 not reachable');
  }
}

}
