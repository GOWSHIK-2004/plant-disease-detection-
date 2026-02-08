import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/plant_health_report.dart';
import '../services/sensor_service.dart';
import 'dashboard_screen.dart'; // ✅ reuse SensorGraphCard widgets

class ReportDetailScreen extends StatelessWidget {
  final PlantHealthReport report;

  const ReportDetailScreen({super.key, required this.report});

  Color _colorForLevel(DiseaseLevel level) {
    switch (level) {
      case DiseaseLevel.healthy:
        return Colors.green;
      case DiseaseLevel.stress:
        return Colors.yellow;
      case DiseaseLevel.sustainedStress:
        return Colors.orange;
      case DiseaseLevel.highProbability:
        return Colors.red;
    }
  }

  String _textForLevel(DiseaseLevel level) {
    switch (level) {
      case DiseaseLevel.healthy:
        return "Plant is Healthy";
      case DiseaseLevel.stress:
        return "Temporary Stress Detected";
      case DiseaseLevel.sustainedStress:
        return "Sustained Stress Detected";
      case DiseaseLevel.highProbability:
        return "High Disease Probability";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Health Report Details"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔴 Disease Status Card
            Card(
              color: _colorForLevel(report.diseaseLevel).withOpacity(0.15),
              child: ListTile(
                leading: Icon(
                  Icons.warning,
                  color: _colorForLevel(report.diseaseLevel),
                  size: 40,
                ),
                title: Text(
                  _textForLevel(report.diseaseLevel),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "${report.startTime} → ${report.endTime}",
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 📊 SUMMARY
            const Text(
              "Sensor Summary",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            _summaryRow(
              "Avg Temperature",
              "${report.avgTemperature.toStringAsFixed(1)} °C",
            ),
            _summaryRow(
              "Avg Humidity",
              "${report.avgHumidity.toStringAsFixed(1)} %",
            ),
            _summaryRow(
              "Avg Moisture",
              "${report.avgMoisture.toStringAsFixed(1)} %",
            ),

            const Divider(height: 32),

            // 🧠 EXPLANATION
            const Text(
              "Analysis Explanation",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Text(
              _buildExplanation(),
              style: const TextStyle(fontSize: 15),
            ),

            const Divider(height: 32),

            // 📈 SENSOR TRENDS (REUSED FROM DASHBOARD)
            const Text(
              "Sensor Trends (Recent)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            const SensorGraphCard(
              title: 'Temperature',
              icon: Icons.thermostat,
            ),
            const SizedBox(height: 16),

            const SensorGraphCard(
              title: 'Humidity',
              icon: Icons.water_drop,
            ),
            const SizedBox(height: 16),

            const SensorGraphCard(
              title: 'Soil Moisture',
              icon: Icons.grass,
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  String _buildExplanation() {
    final List<String> points = [];

    if (report.tempAbnormalPercent >= 0.7) {
      points.add("Temperature remained abnormal for most of the hour.");
    }
    if (report.humidityAbnormalPercent >= 0.7) {
      points.add("Humidity remained abnormal for most of the hour.");
    }
    if (report.moistureAbnormalPercent >= 0.7) {
      points.add("Soil moisture remained abnormal for most of the hour.");
    }

    if (report.tempTrendBad ||
        report.humidityTrendBad ||
        report.moistureTrendBad) {
      points.add(
        "Sensor trends indicate worsening conditions over time.",
      );
    }

    if (points.isEmpty) {
      return "All sensor values remained within the normal range.";
    }

    return points.map((e) => "• $e").join("\n");
  }
}
