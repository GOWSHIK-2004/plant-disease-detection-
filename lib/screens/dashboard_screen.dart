import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import '../providers/user_provider.dart';
import '../providers/language_provider.dart';
import '../utils/sensor_colors.dart';
import '../services/sensor_service.dart';
import '../models/sensor_reading.dart';
import 'plant_details_screen.dart';
import 'plant_selection_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.watch<LanguageProvider>().getText('dashboard'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Selected Plants Horizontal List
          SizedBox(
            height: 120,
            child: Consumer<UserProvider>(
              builder: (context, userProvider, _) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  // Add 1 to itemCount for the add button
                  itemCount: userProvider.selectedPlants.length + 1,
                  itemBuilder: (context, index) {
                    // If it's the last item, show add button
                    if (index == userProvider.selectedPlants.length) {
                      return SizedBox(
                        width: 90,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PlantSelectionScreen(isSelecting: true),
                                ),
                              );
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Card(
                                  child: SizedBox(
                                    width: 70,
                                    height: 70,
                                    child: Icon(
                                      Icons.add, // Changed from add_circle_outline
                                      size: 35,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  context.watch<LanguageProvider>().getText('add_plants'),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    // Show plant items
                    final plant = userProvider.selectedPlants[index];
                    return SizedBox(
                      width: 90,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PlantDetailsScreen(plant: plant),
                              ),
                            );
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Card(
                                child: SizedBox(
                                  width: 70,
                                  height: 70,
                                  child: Icon(
                                    plant.icon,
                                    size: 35,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                plant.getLocalizedName(context.watch<LanguageProvider>().currentLanguage),
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const Divider(),
          const PlantStatusCard(),
          const SizedBox(height: 16),
          Text(
            context.watch<LanguageProvider>().getText('sensor_readings'),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const SensorGridView(),
          const SizedBox(height: 16),
          Text(
            context.watch<LanguageProvider>().getText('sensor_trends'),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const SensorGraphsView(),
        ],
      ),
    );
  }
}

class PlantStatusCard extends StatelessWidget {
  const PlantStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, _) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.eco, size: 48, color: Colors.green),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      languageProvider.getText('plant_status'),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(languageProvider.getText('healthy')),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SensorGridView extends StatefulWidget {
  const SensorGridView({super.key});

  @override
  State<SensorGridView> createState() => _SensorGridViewState();
}

class _SensorGridViewState extends State<SensorGridView> {
  final _sensorService = SensorService();

  @override
  void initState() {
    super.initState();
    _sensorService.startAutoRefresh();
  }

  @override
  void dispose() {
    _sensorService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SensorReading>(
      stream: _sensorService.latestReadings,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              context.watch<LanguageProvider>().getText('error_occurred'),
              textAlign: TextAlign.center,
            ),
          );
        }

        if (!snapshot.hasData) {
          return const SizedBox();
        }

        final reading = snapshot.data!;

        return LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = (constraints.maxWidth - 32) / 2;
            final cardHeight = cardWidth * 0.8;

            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: cardWidth / cardHeight,
              children: [
                SensorCard(
                  title: 'temperature',
                  value: '${reading.temperature.toStringAsFixed(1)}°C',
                  icon: Icons.thermostat,
                ),
                SensorCard(
                  title: 'humidity',
                  value: '${reading.humidity.toStringAsFixed(0)}%',
                  icon: Icons.water_drop,
                ),
                SensorCard(
                  title: 'soil_moisture',
                  value: '${reading.moisture.toStringAsFixed(0)}%',
                  icon: Icons.grass,
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class SensorCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const SensorCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, _) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 28,
                  color: getSensorColor(context, title),
                ),
                const SizedBox(height: 4),
                Text(
                  languageProvider.getText(title),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 14,
                      ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    value,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: getSensorColor(context, title),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color getSensorColor(BuildContext context, String sensor) {
    return SensorColors.getColor(context, sensor);
  }
}

class SensorGraphsView extends StatelessWidget {
  const SensorGraphsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SensorGraphCard(
          title: 'Temperature',
          icon: Icons.thermostat,
        ),
        SizedBox(height: 16),
        SensorGraphCard(
          title: 'Humidity',
          icon: Icons.water_drop,
        ),
        SizedBox(height: 16),
        SensorGraphCard(
          title: 'Soil Moisture',
          icon: Icons.grass,
        ),
      ],
    );
  }
}

class SensorGraphCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const SensorGraphCard({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, _) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: getSensorColor(context, title)),
                    const SizedBox(width: 8),
                    Text(
                      languageProvider.getText(title.toLowerCase().replaceAll(' ', '_')),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: SensorChart(
                    title: title,
                    data: getSensorData(),
                    color: getSensorColor(context, title),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<SensorData> getSensorData() {
    final now = DateTime.now();
    final List<SensorData> data = [];
    switch (title) {
      case 'Temperature':
        for (int i = 0; i < 24; i++) {
          data.add(SensorData(
            now.subtract(Duration(hours: 23 - i)),
            22 + (i % 5) + (i / 10),
          ));
        }
        break;
      case 'Humidity':
        for (int i = 0; i < 24; i++) {
          data.add(SensorData(
            now.subtract(Duration(hours: 23 - i)),
            60 + (i % 10),
          ));
        }
        break;
      case 'Soil Moisture':
        for (int i = 0; i < 24; i++) {
          data.add(SensorData(
            now.subtract(Duration(hours: 23 - i)),
            75 + (i % 8),
          ));
        }
        break;
    }
    return data;
  }

  Color getSensorColor(BuildContext context, String sensor) {
    return SensorColors.getColor(context, sensor);
  }
}

class SensorChart extends StatelessWidget {
  final String title;
  final List<SensorData> data;
  final Color color;

  const SensorChart({
    super.key,
    required this.title,
    required this.data,
    required this.color,
  });

  List<SensorData> _convertToChartData(List<SensorReading> readings) {
    if (kDebugMode) {
      print('Converting ${readings.length} readings for $title chart');
    }

    final sortedReadings = readings
      ..sort((a, b) => DateTime.parse(a.createdAt).compareTo(DateTime.parse(b.createdAt)));

    return sortedReadings.map((reading) {
      final value = switch (title.toLowerCase()) {
        'temperature' => reading.temperature,
        'humidity' => reading.humidity,
        'soil moisture' => reading.moisture,
        _ => 0.0,
      };
      
      if (kDebugMode) {
        print('Data point: ${reading.createdAt} -> $value');
      }
      
      return SensorData(DateTime.parse(reading.createdAt), value);
    }).toList();
  }

  List<SensorData> _getDefaultData() {
    final now = DateTime.now();
    final defaultValue = switch (title.toLowerCase()) {
      'temperature' => 25.0,
      'humidity' => 60.0,
      'soil moisture' => 40.0,
      _ => 0.0,
    };

    return List.generate(24, (i) {
      final time = now.subtract(Duration(hours: 23 - i));
      return SensorData(time, defaultValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, _) {
        return StreamBuilder<List<SensorReading>>(
          stream: Provider.of<SensorService>(context, listen: false).historicalReadings,
          builder: (context, snapshot) {
            final data = snapshot.hasData && snapshot.data!.isNotEmpty 
              ? _convertToChartData(snapshot.data!)
              : _getDefaultData();

            return SfCartesianChart(
              margin: const EdgeInsets.fromLTRB(10, 20, 15, 10),
              plotAreaBorderWidth: 0,
              primaryXAxis: DateTimeAxis(
                majorGridLines: const MajorGridLines(width: 0),
                axisLine: const AxisLine(width: 1),
                labelStyle: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
                intervalType: DateTimeIntervalType.hours,
                interval: 6,
                title: AxisTitle(
                  text: languageProvider.getText('time_hours'),
                  textStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              primaryYAxis: NumericAxis(
                axisLine: const AxisLine(width: 1),
                labelStyle: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
                majorTickLines: const MajorTickLines(size: 4),
                majorGridLines: MajorGridLines(
                  width: 1,
                  color: Colors.grey.withOpacity(0.2),
                ),
                title: AxisTitle(
                  text: getYAxisTitle(title, languageProvider),
                  textStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                minimum: getYAxisMinimum(title),
                maximum: getYAxisMaximum(title),
                interval: getYAxisInterval(title),
              ),
              series: <CartesianSeries<SensorData, DateTime>>[
                SplineAreaSeries<SensorData, DateTime>(
                  dataSource: data,
                  xValueMapper: (SensorData data, _) => data.time,
                  yValueMapper: (SensorData data, _) => data.value,
                  color: color.withOpacity(0.15),
                  borderColor: color,
                  borderWidth: 3,
                  splineType: SplineType.cardinal,
                  cardinalSplineTension: 0.3,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      color.withOpacity(0.3),
                      color.withOpacity(0.05),
                    ],
                  ),
                ),
              ],
              tooltipBehavior: TooltipBehavior(
                enable: true,
                color: Colors.white,
                textStyle: const TextStyle(color: Colors.black),
                borderColor: Colors.grey,
                borderWidth: 1,
              ),
            );
          },
        );
      },
    );
  }

  String getYAxisTitle(String sensor, LanguageProvider languageProvider) {
    final sensorName = languageProvider.getText(sensor.toLowerCase().replaceAll(' ', '_'));
    switch (sensor) {
      case 'Temperature':
        return '$sensorName (°C)';
      case 'Humidity':
      case 'Soil Moisture':
        return '$sensorName (%)';
      default:
        return sensorName;
    }
  }

  double getYAxisMinimum(String sensor) {
    switch (sensor) {
      case 'Temperature':
        return 15;
      case 'Humidity':
      case 'Soil Moisture':
        return 0;
      default:
        return 0;
    }
  }

  double getYAxisMaximum(String sensor) {
    switch (sensor) {
      case 'Temperature':
        return 35;
      case 'Humidity':
      case 'Soil Moisture':
        return 100;
      default:
        return 100;
    }
  }

  double getYAxisInterval(String sensor) {
    switch (sensor) {
      case 'Temperature':
        return 5;
      case 'Humidity':
      case 'Soil Moisture':
        return 20;
      default:
        return 20;
    }
  }
}

class SensorData {
  final DateTime time;
  final double value;
  SensorData(this.time, this.value);
}
