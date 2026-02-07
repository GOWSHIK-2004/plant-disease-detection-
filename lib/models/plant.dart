import 'package:flutter/material.dart';

class Plant {
  final String id;
  final String name;
  final String nameTa;
  final String scientificName;
  final IconData icon;
  final String description;
  final String descriptionTa;
  final CareGuide careGuide;
  final List<Disease> diseases;
  final List<String> features;
  final List<String> featuresTa;

  Plant({
    required this.id,
    required this.name,
    required this.nameTa,
    required this.icon,
    required this.scientificName,
    required this.description,
    required this.descriptionTa,
    required this.careGuide,
    this.diseases = const [],
    this.features = const [],
    this.featuresTa = const [],
  });

  String getLocalizedName(String languageCode) {
    return languageCode == 'ta' ? nameTa : name;
  }

  String getLocalizedDescription(String languageCode) {
    return languageCode == 'ta' ? descriptionTa : description;
  }
}

class CareGuide {
  final String wateringNeeds;
  final String wateringNeedsTa;
  final String sunlight;
  final String sunlightTa;
  final String soilType;
  final String soilTypeTa;
  final String temperature;
  final String humidity;
  final String humidityTa;
  final String fertilizing;
  final String fertilizingTa;

  CareGuide({
    required this.wateringNeeds,
    required this.wateringNeedsTa,
    required this.sunlight,
    required this.sunlightTa,
    required this.soilType,
    required this.soilTypeTa,
    required this.temperature,
    required this.humidity,
    required this.humidityTa,
    required this.fertilizing,
    required this.fertilizingTa,
  });

  String getLocalizedWateringNeeds(String languageCode) {
    return languageCode == 'ta' ? wateringNeedsTa : wateringNeeds;
  }

  String getLocalizedSunlight(String languageCode) {
    return languageCode == 'ta' ? sunlightTa : sunlight;
  }

  String getLocalizedSoilType(String languageCode) {
    return languageCode == 'ta' ? soilTypeTa : soilType;
  }

  String getLocalizedHumidity(String languageCode) {
    return languageCode == 'ta' ? humidityTa : humidity;
  }

  String getLocalizedFertilizing(String languageCode) {
    return languageCode == 'ta' ? fertilizingTa : fertilizing;
  }
}

class Disease {
  final String name;
  final String nameTa;
  final String symptoms;
  final String symptomsTa;
  final List<String> treatment;
  final List<String> treatmentTa;
  final List<String> prevention;
  final List<String> preventionTa;
  final DiseaseLevel severity;
  final IconData icon;

  Disease({
    required this.name,
    required this.nameTa,
    required this.symptoms,
    required this.symptomsTa,
    required this.treatment,
    required this.treatmentTa,
    required this.prevention,
    required this.preventionTa,
    required this.severity,
    this.icon = Icons.bug_report,
  });

  String getLocalizedName(String languageCode) {
    return languageCode == 'ta' ? nameTa : name;
  }

  String getLocalizedSymptoms(String languageCode) {
    return languageCode == 'ta' ? symptomsTa : symptoms;
  }

  List<String> getLocalizedTreatment(String languageCode) {
    return languageCode == 'ta' ? treatmentTa : treatment;
  }

  List<String> getLocalizedPrevention(String languageCode) {
    return languageCode == 'ta' ? preventionTa : prevention;
  }
}

enum DiseaseLevel {
  mild,
  moderate,
  severe
}
