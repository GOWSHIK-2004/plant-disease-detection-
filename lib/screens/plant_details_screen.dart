import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/plant.dart';
import '../providers/language_provider.dart';

class PlantDetailsScreen extends StatelessWidget {
  final Plant plant;

  const PlantDetailsScreen({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final lang = languageProvider.currentLanguage;

    return Scaffold(
      appBar: AppBar(title: Text(plant.getLocalizedName(lang))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Plant Header
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(plant.icon, size: 48, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(plant.getLocalizedName(lang), style: Theme.of(context).textTheme.headlineSmall),
                            Text(plant.scientificName, style: const TextStyle(fontStyle: FontStyle.italic)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(plant.getLocalizedDescription(lang)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Care Guide
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(languageProvider.getText('care_guide'), 
                       style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  _buildCareItem(context, Icons.water_drop, 'watering', lang),
                  _buildCareItem(context, Icons.wb_sunny, 'sunlight', lang),
                  _buildCareItem(context, Icons.landscape, 'soil', lang),
                  _buildCareItem(context, Icons.thermostat, 'temperature', lang),
                  _buildCareItem(context, Icons.water, 'humidity', lang),
                  _buildCareItem(context, Icons.eco, 'fertilizing', lang),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Features
          if (plant.features.isNotEmpty) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Features', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    ...plant.features.map((feature) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, size: 16),
                          const SizedBox(width: 8),
                          Text(feature),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Diseases
          if (plant.diseases.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(languageProvider.getText('common_diseases'), 
                         style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 16),
                    ...plant.diseases.map((disease) => 
                      _buildDiseaseItem(context, disease, 
                        Theme.of(context).brightness == Brightness.dark, lang)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCareItem(BuildContext context, IconData icon, String title, String langCode) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  languageProvider.getText(title),
                  style: const TextStyle(fontWeight: FontWeight.w500)
                ),
                Text(
                  title == 'watering' ? plant.careGuide.getLocalizedWateringNeeds(langCode) :
                  title == 'sunlight' ? plant.careGuide.getLocalizedSunlight(langCode) :
                  title == 'soil' ? plant.careGuide.getLocalizedSoilType(langCode) :
                  title == 'temperature' ? plant.careGuide.temperature :
                  title == 'humidity' ? plant.careGuide.getLocalizedHumidity(langCode) :
                  plant.careGuide.getLocalizedFertilizing(langCode),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiseaseItem(BuildContext context, Disease disease, bool isDark, String langCode) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(disease.icon, 
                  color: _getSeverityColor(disease.severity),
                  size: 24
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        disease.getLocalizedName(langCode),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        '${languageProvider.getText('severity')}: ${languageProvider.getText(disease.severity.name)}',
                        style: TextStyle(
                          color: _getSeverityColor(disease.severity),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(),
            _buildSection(context, languageProvider.getText('symptoms'), 
                         disease.getLocalizedSymptoms(langCode)),
            _buildListSection(context, languageProvider.getText('treatment_steps'), 
                            disease.getLocalizedTreatment(langCode)),
            _buildListSection(context, languageProvider.getText('prevention'), 
                            disease.getLocalizedPrevention(langCode)),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(content),
        ],
      ),
    );
  }

  Widget _buildListSection(BuildContext context, String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(item),
          )),
        ],
      ),
    );
  }

  Color _getSeverityColor(DiseaseLevel severity) {
    switch (severity) {
      case DiseaseLevel.mild:
        return Colors.orange;
      case DiseaseLevel.moderate:
        return Colors.orange.shade700;
      case DiseaseLevel.severe:
        return Colors.red;
    }
  }
}
