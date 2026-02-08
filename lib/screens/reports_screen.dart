import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/sensor_service.dart';
import '../models/plant_health_report.dart';
import 'report_detail_screen.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

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
        return "Healthy";
      case DiseaseLevel.stress:
        return "Temporary Stress";
      case DiseaseLevel.sustainedStress:
        return "Sustained Stress";
      case DiseaseLevel.highProbability:
        return "High Disease Probability";
    }
  }

  @override
  Widget build(BuildContext context) {
    final sensorService = Provider.of<SensorService>(context);
    final reports = sensorService.reports.reversed.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Plant Health Reports"),
      ),
      body: reports.isEmpty
          ? const Center(
              child: Text("No reports generated yet"),
            )
          : ListView.builder(
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final report = reports[index];

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          _colorForLevel(report.diseaseLevel),
                    ),
                    title: Text(
                      _textForLevel(report.diseaseLevel),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "${report.startTime.hour}:${report.startTime.minute.toString().padLeft(2, '0')} "
                      "→ ${report.endTime.hour}:${report.endTime.minute.toString().padLeft(2, '0')}",
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ReportDetailScreen(report: report),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
