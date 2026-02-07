import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/sensor_reading.dart';

class SensorService {
  static const String _latestDataUrl = 'https://plant-monitor.onrender.com/api/sensor-data/latest';
  static const String _historicalDataUrl = 'https://plant-monitor.onrender.com/api/sensor-data';

  final _readingsController = StreamController<SensorReading>.broadcast();
  final _historicalController = StreamController<List<SensorReading>>.broadcast();
  Timer? _refreshTimer;
  List<SensorReading>? _cachedHistoricalData;

  Stream<SensorReading> get latestReadings => _readingsController.stream;
  Stream<List<SensorReading>> get historicalReadings => _historicalController.stream;

  void startAutoRefresh() {
    // Initial fetch
    _fetchAndEmitReadings();
    _fetchHistoricalData();
    
    // Setup periodic fetch every 30 seconds
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

  Future<void> _fetchAndEmitReadings() async {
    try {
      final reading = await getLatestReadings();
      _readingsController.add(reading);
    } catch (e) {
      if (kDebugMode) {
        print('Error in auto-refresh: $e');
      }
    }
  }

  Future<void> _fetchHistoricalData() async {
    try {
      final readings = await getHistoricalReadings();
      _cachedHistoricalData = readings;
      _historicalController.add(readings);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching historical data: $e');
      }
    }
  }

  Future<SensorReading> getLatestReadings() async {
    try {
      if (kDebugMode) {
        print('Fetching latest sensor readings...');
      }
      
      final response = await http.get(
        Uri.parse(_latestDataUrl),
        headers: {'Accept': 'application/json'},
      );
      
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
      
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          if (kDebugMode) {
            print('Parsing data: ${jsonResponse}');
          }
          return SensorReading.fromJson(jsonResponse);
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load sensor data: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in getLatestReadings: $e');
      }
      rethrow;
    }
  }

  Future<List<SensorReading>> getHistoricalReadings() async {
    try {
      if (kDebugMode) {
        print('Fetching historical readings...');
      }

      final response = await http.get(
        Uri.parse(_historicalDataUrl),
        headers: {'Accept': 'application/json'},
      );

      if (kDebugMode) {
        print('Historical data status: ${response.statusCode}');
        print('Historical data body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          final List<dynamic> data = jsonResponse['data'] as List;
          final readings = data.map((item) => 
            SensorReading.fromJson({'data': item})).toList();
          
          if (kDebugMode) {
            print('Parsed ${readings.length} historical readings');
          }
          return readings;
        } else {
          throw Exception('Invalid historical data format');
        }
      } else {
        throw Exception('Failed to load historical data: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in getHistoricalReadings: $e');
      }
      rethrow;
    }
  }
}
