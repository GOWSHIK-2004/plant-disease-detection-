import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../models/sensor_reading.dart';
import '../main.dart'; // showPlantHealthAlert
import '../models/plant_health_report.dart';
import '../utils/report_analyzer.dart';

class SensorService {
  static const String _latestDataUrl =
      'https://plant-monitor.onrender.com/api/sensor-data/latest';
  static const String _historicalDataUrl =
      'https://plant-monitor.onrender.com/api/sensor-data';

  // 🔹 Sliding window (TEMP: 5 readings = 1 simulated hour)
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
    _fetchHistoricalData();

    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _fetchAndEmitReadings();
      _fetchHistoricalData();
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

      // 🔹 Keep only last 5 readings (TEMP simulation)
      if (_lastHourReadings.length > 5) {
        _lastHourReadings.removeAt(0);
      }

      // 🔹 Generate simulated hourly report
      if (_lastHourReadings.length == 5) {
        final report = generateHourlyReport(
          readings: List.from(_lastHourReadings),
          plantName: "Paddy Rice",
        );

        _reports.add(report);

        // 🔹 Console log for verification
        print("=================================");
        print("📊 SIMULATED HOURLY REPORT");
        print("Disease Level: ${report.diseaseLevel}");
        print("Temp abnormal %: ${report.tempAbnormalPercent}");
        print("Humidity abnormal %: ${report.humidityAbnormalPercent}");
        print("Moisture abnormal %: ${report.moistureAbnormalPercent}");
        print("=================================");

        // 🔔 NOTIFY ONLY IF REPORT CONFIRMS DISEASE
        if (report.diseaseLevel == DiseaseLevel.highProbability) {
          showPlantHealthAlert(
            plantName: "Paddy Rice",
            issues: ["High disease probability detected"],
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in auto-refresh: $e');
      }
    }
  }

  // ==========================
  // HISTORICAL DATA
  // ==========================
  Future<void> _fetchHistoricalData() async {
    try {
      final readings = await getHistoricalReadings();
      _historicalController.add(readings);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching historical data: $e');
      }
    }
  }

  // ==========================
  // API CALLS
  // ==========================
  Future<SensorReading> getLatestReadings() async {
    final response = await http.get(
      Uri.parse(_latestDataUrl),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return SensorReading.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load sensor data');
    }
  }

  Future<List<SensorReading>> getHistoricalReadings() async {
    final response = await http.get(
      Uri.parse(_historicalDataUrl),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List<dynamic> data = jsonResponse['data'] as List;
      return data
          .map((item) => SensorReading.fromJson({'data': item}))
          .toList();
    } else {
      throw Exception('Failed to load historical data');
    }
  }
}
