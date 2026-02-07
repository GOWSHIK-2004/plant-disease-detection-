import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../providers/user_provider.dart';
import '../models/plant.dart';
import '../main.dart';

class PlantSelectionScreen extends StatefulWidget {
  final bool isSelecting;

  const PlantSelectionScreen({
    super.key,
    this.isSelecting = false,
  });

  @override
  State<PlantSelectionScreen> createState() => _PlantSelectionScreenState();
}

class _PlantSelectionScreenState extends State<PlantSelectionScreen> {
  final Set<Plant> _selectedPlants = {};

  final List<Plant> _availablePlants = [
    Plant(
      id: '1',
      name: 'Paddy Rice',
      nameTa: 'நெல்',
      scientificName: 'Oryza sativa',
      icon: Icons.grass,
      description: 'Major food crop of Tamil Nadu, grown in delta regions.',
      descriptionTa: 'தமிழ்நாட்டின் முக்கிய உணவு பயிர், டெல்டா பகுதிகளில் வளர்க்கப்படுகிறது.',
      careGuide: CareGuide(
        wateringNeeds: 'Standing water during growth',
        wateringNeedsTa: 'வளர்ச்சியின் போது நிலைத்த நீர்',
        sunlight: 'Full sun',
        sunlightTa: 'முழு சூரிய ஒளி',
        soilType: 'Clay-rich soil',
        soilTypeTa: 'களிமண் நிறைந்த மண்',
        temperature: '20-35°C',
        humidity: 'High',
        humidityTa: 'அதிகம்',
        fertilizing: 'NPK during key growth stages',
        fertilizingTa: 'முக்கிய வளர்ச்சி நிலைகளில் NPK',
      ),
      diseases: [
        Disease(
          name: 'Blast Disease',
          nameTa: 'வைரஸ் நோய்',
          symptoms: 'Diamond-shaped lesions on leaves and nodes',
          symptomsTa: 'இலைகள் மற்றும் கணுக்களில் வைர வடிவ புண்கள்',
          treatment: ['Apply fungicide', 'Improve drainage', 'Remove infected plants'],
          treatmentTa: ['பூஞ்சைக்கொல்லி பயன்படுத்துக', 'வடிகால் மேம்படுத்துக', 'நோய்த்தாக்கிய செடிகளை அகற்றுக'],
          prevention: ['Use resistant varieties', 'Balanced fertilization', 'Proper spacing'],
          preventionTa: ['எதிர்ப்பு ரகங்களைப் பயன்படுத்துக', 'சமச்சீர் உரமிடுதல்', 'சரியான இடைவெளி'],
          severity: DiseaseLevel.severe,
        ),
        Disease(
          name: 'Bacterial Leaf Blight',
          nameTa: 'பாக்டீரியல் இலை எரிச்சல்',
          symptoms: 'Yellow to white lesions along leaf margins',
          symptomsTa: 'இலை விளிம்புகளில் மஞ்சள் முதல் வெள்ளை வரை புண்கள்',
          treatment: ['Remove infected parts', 'Copper-based sprays', 'Improve ventilation'],
          treatmentTa: ['பாதிக்கப்பட்ட பகுதிகளை அகற்றுக', 'செம்பு அடிப்படையிலான தெளிப்புகள்', 'காற்றோட்டத்தை மேம்படுத்துக'],
          prevention: ['Use clean seeds', 'Crop rotation', 'Proper water management'],
          preventionTa: ['சுத்தமான விதைகளைப் பயன்படுத்துக', 'பயிர் சுழற்சி', 'சரியான நீர் மேலாண்மை'],
          severity: DiseaseLevel.severe,
        ),
        Disease(
          name: 'Brown Spot',
          nameTa: 'பழுப்பு புள்ளி',
          symptoms: 'Circular brown spots on leaves and grains',
          symptomsTa: 'இலைகள் மற்றும் தானியங்களில் வட்ட வடிவ பழுப்பு புள்ளிகள்',
          treatment: ['Apply fungicide', 'Balance soil nutrients', 'Remove infected parts'],
          treatmentTa: ['பூஞ்சைக்கொல்லி பயன்படுத்துக', 'மண் ஊட்டச்சத்துக்களை சமநிலைப்படுத்துக', 'பாதிக்கப்பட்ட பகுதிகளை அகற்றுக'],
          prevention: ['Maintain proper soil fertility', 'Use clean seeds', 'Proper spacing'],
          preventionTa: ['சரியான மண் வளத்தை பராமரிக்கவும்', 'சுத்தமான விதைகளைப் பயன்படுத்துக', 'சரியான இடைவெளி'],
          severity: DiseaseLevel.moderate,
        ),
        Disease(
          name: 'Sheath Blight',
          nameTa: 'உறை எரிச்சல்',
          symptoms: 'Irregular lesions on leaf sheaths',
          symptomsTa: 'இலை உறைகளில் ஒழுங்கற்ற புண்கள்',
          treatment: ['Apply fungicide', 'Reduce humidity', 'Remove infected parts'],
          treatmentTa: ['பூஞ்சைக்கொல்லி பயன்படுத்துக', 'ஈரப்பதத்தை குறைக்கவும்', 'பாதிக்கப்பட்ட பகுதிகளை அகற்றுக'],
          prevention: ['Reduce crop density', 'Balanced fertilization', 'Clean field'],
          preventionTa: ['பயிர் அடர்த்தியை குறைக்கவும்', 'சமச்சீர் உரமிடுதல்', 'சுத்தமான வயல்'],
          severity: DiseaseLevel.severe,
        ),
      ],
    ),
    Plant(
      id: '2',
      name: 'Turmeric',
      nameTa: 'மஞ்சள்',
      scientificName: 'Curcuma longa',
      icon: Icons.spa,
      description: 'Important spice crop of Tamil Nadu, known for its medicinal properties.',
      descriptionTa: 'தமிழ்நாட்டின் முக்கிய மசாலா பயிர், மருத்துவ குணங்களுக்கு பெயர் பெற்றது.',
      careGuide: CareGuide(
        wateringNeeds: 'Regular watering',
        wateringNeedsTa: 'வழக்கமான நீர் பாய்ச்சல்',
        sunlight: 'Partial shade',
        sunlightTa: 'பகுதி நிழல்',
        soilType: 'Well-draining, rich soil',
        soilTypeTa: 'நன்கு வடிகால் கொண்ட, வளமான மண்',
        temperature: '20-30°C',
        humidity: 'Moderate to high',
        humidityTa: 'மிதமான முதல் அதிக ஈரப்பதம்',
        fertilizing: 'Organic matter rich fertilizer',
        fertilizingTa: 'கரிம பொருள் நிறைந்த உரம்',
      ),
      diseases: [
        Disease(
          name: 'Rhizome Rot',
          nameTa: 'கிழங்கு அழுகல்',
          symptoms: 'Yellowing leaves, rotting rhizomes',
          symptomsTa: 'இலைகள் மஞ்சள் நிறமாதல், கிழங்குகள் அழுகல்',
          treatment: ['Remove infected plants', 'Improve drainage', 'Apply fungicide'],
          treatmentTa: ['நோய்த்தாக்கிய செடிகளை அகற்றுக', 'வடிகால் மேம்படுத்துக', 'பூஞ்சைக்கொல்லி பயன்படுத்துக'],
          prevention: ['Well-draining soil', 'Clean rhizomes for planting', 'Crop rotation'],
          preventionTa: ['நல்ல வடிகால் மண்', 'நடவுக்கு சுத்தமான கிழங்குகள்', 'பயிர் சுழற்சி'],
          severity: DiseaseLevel.severe,
        ),
        Disease(
          name: 'Leaf Spot',
          nameTa: 'இலை புள்ளி நோய்',
          symptoms: 'Brown spots with yellow halos on leaves',
          symptomsTa: 'இலைகளில் மஞ்சள் வளையங்களுடன் கூடிய பழுப்பு புள்ளிகள்',
          treatment: ['Remove infected leaves', 'Apply fungicide', 'Improve air circulation'],
          treatmentTa: ['பாதிக்கப்பட்ட இலைகளை அகற்றுக', 'பூஞ்சைக்கொல்லி பயன்படுத்துக', 'காற்றோட்டத்தை மேம்படுத்துக'],
          prevention: ['Proper spacing', 'Clean field', 'Balanced irrigation'],
          preventionTa: ['சரியான இடைவெளி', 'சுத்தமான வயல்', 'சமநிலை நீர்ப்பாசனம்'],
          severity: DiseaseLevel.moderate,
        ),
        Disease(
          name: 'Leaf Blotch',
          nameTa: 'இலை கறை நோய்',
          symptoms: 'Large brown patches on leaves',
          symptomsTa: 'இலைகளில் பெரிய பழுப்பு கறைகள்',
          treatment: ['Apply fungicide', 'Remove affected leaves', 'Improve drainage'],
          treatmentTa: ['பூஞ்சைக்கொல்லி பயன்படுத்துக', 'பாதிக்கப்பட்ட இலைகளை அகற்றுக', 'வடிகால் மேம்படுத்துக'],
          prevention: ['Crop rotation', 'Clean planting material', 'Proper spacing'],
          preventionTa: ['பயிர் சுழற்சி', 'சுத்தமான நடவு பொருட்கள்', 'சரியான இடைவெளி'],
          severity: DiseaseLevel.moderate,
        ),
      ],
    ),
    Plant(
      id: '3',
      name: 'Sugarcane',
      nameTa: 'கரும்பு',
      scientificName: 'Saccharum officinarum',
      icon: Icons.agriculture,
      description: 'Major commercial crop in Tamil Nadu.',
      descriptionTa: 'தமிழ்நாட்டின் முக்கிய வணிக பயிர்.',
      careGuide: CareGuide(
        wateringNeeds: 'Regular irrigation',
        wateringNeedsTa: 'வழக்கமான நீர்ப்பாசனம்',
        sunlight: 'Full sun',
        sunlightTa: 'முழு சூரிய ஒளி',
        soilType: 'Deep, well-draining soil',
        soilTypeTa: 'ஆழமான, நல்ல வடிகால் உள்ள மண்',
        temperature: '21-38°C',
        humidity: 'Moderate to high',
        humidityTa: 'மிதமான முதல் அதிக ஈரப்பதம்',
        fertilizing: 'NPK at different stages',
        fertilizingTa: 'வளர்ச்சி நிலைகளில் NPK',
      ),
      diseases: [
        Disease(
          name: 'Red Rot',
          nameTa: 'சிவப்பு அழுகல்',
          symptoms: 'Red patches in internal tissue',
          symptomsTa: 'உள் திசுக்களில் சிவப்பு நிற கறைகள்',
          treatment: ['Remove infected plants', 'Hot water treatment of sets', 'Proper drainage'],
          treatmentTa: ['நோய்த்தாக்கிய செடிகளை அகற்றுக', 'வெந்நீர் சிகிச்சை', 'சரியான வடிகால்'],
          prevention: ['Use resistant varieties', 'Clean planting material', 'Crop rotation'],
          preventionTa: ['எதிர்ப்பு ரகங்களைப் பயன்படுத்துக', 'சுத்தமான நடவு பொருட்கள்', 'பயிர் சுழற்சி'],
          severity: DiseaseLevel.severe,
        ),
        Disease(
          name: 'Smut',
          nameTa: 'கருப்பு அழுகல்',
          symptoms: 'Black whip-like structures from growing points',
          symptomsTa: 'வளர்ச்சி பகுதிகளில் இருந்து கருப்பு சவுக்குகள்',
          treatment: ['Remove infected plants', 'Hot water treatment', 'Clean field'],
          treatmentTa: ['நோய்த்தாக்கிய செடிகளை அகற்றுக', 'வெந்நீர் சிகிச்சை', 'சுத்தமான வயல்'],
          prevention: ['Use disease-free sets', 'Resistant varieties', 'Field sanitation'],
          preventionTa: ['நோயற்ற நடவு பொருட்கள்', 'எதிர்ப்பு ரகங்கள்', 'வயல் சுத்தம்'],
          severity: DiseaseLevel.severe,
        ),
        Disease(
          name: 'Wilt',
          nameTa: 'வாடுதல்',
          symptoms: 'Sudden wilting of plants',
          symptomsTa: 'செடிகள் திடீரென வாடுதல்',
          treatment: ['Remove diseased clumps', 'Improve drainage', 'Soil treatment'],
          treatmentTa: ['நோய்த்தாக்கிய குழுக்களை அகற்றுக', 'வடிகால் மேம்படுத்துக', 'மண் சிகிச்சை'],
          prevention: ['Crop rotation', 'Clean planting material', 'Proper irrigation'],
          preventionTa: ['பயிர் சுழற்சி', 'சுத்தமான நடவு பொருட்கள்', 'சரியான நீர்ப்பாசனம்'],
          severity: DiseaseLevel.severe,
        ),
      ],
    ),
    Plant(
      id: '4',
      name: 'Groundnut',
      nameTa: 'நிலக்கடலை',
      scientificName: 'Arachis hypogaea',
      icon: Icons.grass,
      description: 'Important oilseed crop in Tamil Nadu.',
      descriptionTa: 'தமிழ்நாட்டின் முக்கிய எண்ணெய் வித்து பயிர்.',
      careGuide: CareGuide(
        wateringNeeds: 'Moderate, critical during flowering',
        wateringNeedsTa: 'மிதமான, பூக்கும் காலத்தில் முக்கியம்',
        sunlight: 'Full sun',
        sunlightTa: 'முழு சூரிய ஒளி',
        soilType: 'Sandy loam',
        soilTypeTa: 'மணல் களிமண்',
        temperature: '25-35°C',
        humidity: 'Moderate',
        humidityTa: 'மிதமான',
        fertilizing: 'Calcium important during pod formation',
        fertilizingTa: 'காய் உருவாகும் போது கால்சியம் முக்கியம்',
      ),
      diseases: [
        Disease(
          name: 'Leaf Spot',
          nameTa: 'இலை கறை நோய்',
          symptoms: 'Brown/black spots on leaves',
          symptomsTa: 'இலைகளில் பழுப்பு/கருப்பு புள்ளிகள்',
          treatment: ['Apply fungicide', 'Remove infected parts', 'Improve air circulation'],
          treatmentTa: ['பூஞ்சைக்கொல்லி பயன்படுத்துக', 'பாதிக்கப்பட்ட பகுதிகளை அகற்றுக', 'காற்றோட்டத்தை மேம்படுத்துக'],
          prevention: ['Crop rotation', 'Resistant varieties', 'Proper spacing'],
          preventionTa: ['பயிர் சுழற்சி', 'எதிர்ப்பு ரகங்கள்', 'சரியான இடைவெளி'],
          severity: DiseaseLevel.moderate,
        ),
      ],
    ),
    Plant(
      id: '5',
      name: 'Brinjal',
      nameTa: 'கத்திரிக்காய்',
      scientificName: 'Solanum melongena',
      icon: Icons.spa,
      description: 'Popular vegetable crop in Tamil Nadu.',
      descriptionTa: 'தமிழ்நாட்டின் பிரபலமான காய்கறி பயிர்.',
      careGuide: CareGuide(
        wateringNeeds: 'Regular watering',
        wateringNeedsTa: 'வழக்கமான நீர்ப்பாசனம்',
        sunlight: 'Full sun',
        sunlightTa: 'முழு சூரிய ஒளி',
        soilType: 'Rich, well-draining soil',
        soilTypeTa: 'வளமான, நல்ல வடிகால் மண்',
        temperature: '25-35°C',
        humidity: 'Moderate',
        humidityTa: 'மிதமான',
        fertilizing: 'Every 3-4 weeks',
        fertilizingTa: 'ஒவ்வொரு 3-4 வாரங்களிலும்',
      ),
      diseases: [
        Disease(
          name: 'Damping Off',
          nameTa: 'தண்ணீர் அழுகல்',
          symptoms: 'Seedling collapse at soil level',
          symptomsTa: 'மண் மட்டத்தில் தழைச்செடி சரிவு',
          treatment: ['Remove affected plants', 'Reduce moisture', 'Apply fungicide'],
          treatmentTa: ['பாதிக்கப்பட்ட செடிகளை அகற்றுக', 'ஈரப்பதத்தை குறைக்கவும்', 'பூஞ்சைக்கொல்லி பயன்படுத்துக'],
          prevention: ['Well-draining soil', 'Proper spacing', 'Clean tools'],
          preventionTa: ['நல்ல வடிகால் மண்', 'சரியான இடைவெளி', 'சுத்தமான கருவிகள்'],
          severity: DiseaseLevel.severe,
        ),
      ],
    ),
    Plant(
      id: '6',
      name: 'Coconut',
      nameTa: 'தென்னை',
      scientificName: 'Cocos nucifera',
      icon: Icons.park,
      description: 'Important plantation crop in coastal Tamil Nadu.',
      descriptionTa: 'தமிழ்நாட்டின் கடலோர பகுதிகளில் முக்கிய தோட்டப் பயிர்.',
      careGuide: CareGuide(
        wateringNeeds: 'Regular irrigation',
        wateringNeedsTa: 'வழக்கமான நீர்ப்பாசனம்',
        sunlight: 'Full sun',
        sunlightTa: 'முழு சூரிய ஒளி',
        soilType: 'Sandy loam',
        soilTypeTa: 'மணல் களிமண்',
        temperature: '20-35°C',
        humidity: 'High',
        humidityTa: 'அதிகம்',
        fertilizing: 'Biannual application',
        fertilizingTa: 'ஆண்டுக்கு இருமுறை உரமிடுதல்',
      ),
      diseases: [
        Disease(
          name: 'Root Wilt',
          nameTa: 'வேர் வாடல்',
          symptoms: 'Yellowing and wilting of leaves',
          symptomsTa: 'இலைகள் மஞ்சள் நிறமாகி வாடுதல்',
          treatment: ['Remove infected trees', 'Improve drainage', 'Apply nutrients'],
          treatmentTa: ['நோய்த்தாக்கிய மரங்களை அகற்றுக', 'வடிகால் மேம்படுத்துக', 'ஊட்டச்சத்துக்களை பயன்படுத்துக'],
          prevention: ['Use disease-free seedlings', 'Proper spacing', 'Regular monitoring'],
          preventionTa: ['நோயற்ற நாற்றுகளை பயன்படுத்துக', 'சரியான இடைவெளி', 'தொடர் கண்காணிப்பு'],
          severity: DiseaseLevel.severe,
        ),
      ],
    ),
    Plant(
      id: '7',
      name: 'Banana',
      nameTa: 'வாழை',
      scientificName: 'Musa acuminata',
      icon: Icons.eco,
      description: 'Widely grown fruit crop in Tamil Nadu.',
      descriptionTa: 'தமிழ்நாட்டில் பரவலாக வளர்க்கப்படும் பழப்பயிர்.',
      careGuide: CareGuide(
        wateringNeeds: 'Regular watering',
        wateringNeedsTa: 'வழக்கமான நீர்ப்பாசனம்',
        sunlight: 'Full sun',
        sunlightTa: 'முழு சூரிய ஒளி',
        soilType: 'Rich, well-draining soil',
        soilTypeTa: 'வளமான, நல்ல வடிகால் மண்',
        temperature: '15-35°C',
        humidity: 'High',
        humidityTa: 'அதிகம்',
        fertilizing: 'Monthly application',
        fertilizingTa: 'மாதாந்திர உரமிடுதல்',
      ),
      diseases: [
        Disease(
          name: 'Panama Wilt',
          nameTa: 'பனாமா வாடல்',
          symptoms: 'Yellowing of older leaves',
          symptomsTa: 'முதிர்ந்த இலைகள் மஞ்சள் நிறமாதல்',
          treatment: ['Remove infected plants', 'Improve drainage', 'Soil treatment'],
          treatmentTa: ['நோய்த்தாக்கிய செடிகளை அகற்றுக', 'வடிகால் மேம்படுத்துக', 'மண் சிகிச்சை'],
          prevention: ['Use clean planting material', 'Crop rotation', 'Proper spacing'],
          preventionTa: ['சுத்தமான நடவு பொருட்கள்', 'பயிர் சுழற்சி', 'சரியான இடைவெளி'],
          severity: DiseaseLevel.severe,
        ),
      ],
    ),
    Plant(
      id: '8',
      name: 'Cotton',
      nameTa: 'பருத்தி',
      scientificName: 'Gossypium hirsutum',
      icon: Icons.grass,
      description: 'Important commercial fiber crop in Tamil Nadu.',
      descriptionTa: 'தமிழ்நாட்டின் முக்கிய வணிக நார் பயிர்.',
      careGuide: CareGuide(
        wateringNeeds: 'Moderate irrigation',
        wateringNeedsTa: 'மிதமான நீர்ப்பாசனம்',
        sunlight: 'Full sun',
        sunlightTa: 'முழு சூரிய ஒளி',
        soilType: 'Deep black soil',
        soilTypeTa: 'ஆழமான கருப்பு மண்',
        temperature: '20-30°C',
        humidity: 'Moderate',
        humidityTa: 'மிதமான',
        fertilizing: 'NPK during growth stages',
        fertilizingTa: 'வளர்ச்சி நிலைகளில் NPK',
      ),
      diseases: [
        Disease(
          name: 'Cotton Wilt',
          nameTa: 'பருத்தி வாடல்',
          symptoms: 'Wilting and yellowing of leaves',
          symptomsTa: 'இலைகள் வாடி மஞ்சள் நிறமாதல்',
          treatment: ['Remove infected plants', 'Soil solarization', 'Apply fungicides'],
          treatmentTa: ['நோய்த்தாக்கிய செடிகளை அகற்றுக', 'மண் சூரிய ஒளி படுதல்', 'பூஞ்சைக்கொல்லி பயன்படுத்துக'],
          prevention: ['Use resistant varieties', 'Crop rotation', 'Field sanitation'],
          preventionTa: ['எதிர்ப்பு ரகங்களைப் பயன்படுத்துக', 'பயிர் சுழற்சி', 'வயல் சுத்தம்'],
          severity: DiseaseLevel.severe,
        ),
      ],
    ),
    Plant(
      id: '9',
      name: 'Tomato',
      nameTa: 'தக்காளி',
      scientificName: 'Solanum lycopersicum',
      icon: Icons.spa,
      description: 'Popular vegetable crop grown throughout Tamil Nadu.',
      descriptionTa: 'தமிழ்நாடு முழுவதும் வளர்க்கப்படும் பிரபலமான காய்கறி பயிர்.',
      careGuide: CareGuide(
        wateringNeeds: 'Regular watering',
        wateringNeedsTa: 'வழக்கமான நீர்ப்பாசனம்',
        sunlight: 'Full sun',
        sunlightTa: 'முழு சூரிய ஒளி',
        soilType: 'Rich, well-draining soil',
        soilTypeTa: 'வளமான, நல்ல வடிகால் மண்',
        temperature: '20-30°C',
        humidity: 'Moderate',
        humidityTa: 'மிதமான',
        fertilizing: 'Every 2 weeks',
        fertilizingTa: 'ஒவ்வொரு 2 வாரங்களுக்கும்',
      ),
      diseases: [
        Disease(
          name: 'Early Blight',
          nameTa: 'முன் எரிச்சல்',
          symptoms: 'Dark spots with concentric rings',
          symptomsTa: 'மைய வளைய கருப்பு புள்ளிகள்',
          treatment: ['Remove infected leaves', 'Apply fungicide', 'Improve air circulation'],
          treatmentTa: ['நோய்த்தாக்கிய இலைகளை அகற்றுக', 'பூஞ்சைக்கொல்லி பயன்படுத்துக', 'காற்றோட்டத்தை மேம்படுத்துக'],
          prevention: ['Crop rotation', 'Proper spacing', 'Clean field'],
          preventionTa: ['பயிர் சுழற்சி', 'சரியான இடைவெளி', 'சுத்தமான வயல்'],
          severity: DiseaseLevel.severe,
        ),
      ],
    ),
    Plant(
      id: '10',
      name: 'Black Pepper',
      nameTa: 'மிளகு',
      scientificName: 'Piper nigrum',
      icon: Icons.grass,
      description: 'Important spice crop in hilly regions.',
      descriptionTa: 'மலைப்பகுதிகளில் முக்கிய மசாலா பயிர்.',
      careGuide: CareGuide(
        wateringNeeds: 'Regular watering',
        wateringNeedsTa: 'வழக்கமான நீர்ப்பாசனம்',
        sunlight: 'Partial shade',
        sunlightTa: 'பகுதி நிழல்',
        soilType: 'Rich organic soil',
        soilTypeTa: 'வளமான கரிம மண்',
        temperature: '20-30°C',
        humidity: 'High',
        humidityTa: 'அதிகம்',
        fertilizing: 'Quarterly application',
        fertilizingTa: 'காலாண்டு உரமிடுதல்',
      ),
      diseases: [
        Disease(
          name: 'Quick Wilt',
          nameTa: 'விரைவு வாடல்',
          symptoms: 'Sudden wilting of vines',
          symptomsTa: 'கொடிகள் திடீரென வாடுதல்',
          treatment: ['Remove infected vines', 'Apply fungicide', 'Improve drainage'],
          treatmentTa: ['நோய்த்தாக்கிய கொடிகளை அகற்றுக', 'பூஞ்சைக்கொல்லி பயன்படுத்துக', 'வடிகால் மேம்படுத்துக'],
          prevention: ['Use disease-free cuttings', 'Proper spacing', 'Good drainage'],
          preventionTa: ['நோயற்ற துண்டுகளைப் பயன்படுத்துக', 'சரியான இடைவெளி', 'நல்ல வடிகால்'],
          severity: DiseaseLevel.severe,
        ),
      ],
    ),
    Plant(
      id: '11',
      name: 'Ginger',
      nameTa: 'இஞ்சி',
      scientificName: 'Zingiber officinale',
      icon: Icons.spa,
      description: 'Valuable spice and medicinal crop.',
      descriptionTa: 'மதிப்புமிக்க மசாலா மற்றும் மருத்துவ பயிர்.',
      careGuide: CareGuide(
        wateringNeeds: 'Regular watering',
        wateringNeedsTa: 'வழக்கமான நீர்ப்பாசனம்',
        sunlight: 'Partial shade',
        sunlightTa: 'பகுதி நிழல்',
        soilType: 'Rich loamy soil',
        soilTypeTa: 'வளமான களிமண்',
        temperature: '20-30°C',
        humidity: 'High',
        humidityTa: 'அதிகம்',
        fertilizing: 'Monthly application',
        fertilizingTa: 'மாதாந்திர உரமிடுதல்',
      ),
      diseases: [
        Disease(
          name: 'Soft Rot',
          nameTa: 'மென் அழுகல்',
          symptoms: 'Yellowing leaves and rotting rhizomes',
          symptomsTa: 'இலைகள் மஞ்சள் நிறமாதல் மற்றும் கிழங்குகள் அழுகல்',
          treatment: ['Remove infected plants', 'Improve drainage', 'Apply fungicide'],
          treatmentTa: ['நோய்த்தாக்கிய செடிகளை அகற்றுக', 'வடிகால் மேம்படுத்துக', 'பூஞ்சைக்கொல்லி பயன்படுத்துக'],
          prevention: ['Use healthy rhizomes', 'Proper spacing', 'Good drainage'],
          preventionTa: ['ஆரோக்கியமான கிழங்குகள்', 'சரியான இடைவெளி', 'நல்ல வடிகால்'],
          severity: DiseaseLevel.severe,
        ),
      ],
    ),
    Plant(
      id: '12',
      name: 'Pearl Millet',
      nameTa: 'கம்பு',
      scientificName: 'Pennisetum glaucum',
      icon: Icons.grass,
      description: 'Drought-resistant cereal crop widely grown in Tamil Nadu.',
      descriptionTa: 'தமிழ்நாட்டில் பரவலாக வளரும் வறட்சி எதிர்ப்பு தானியப் பயிர்.',
      careGuide: CareGuide(
        wateringNeeds: 'Minimal irrigation',
        wateringNeedsTa: 'குறைந்த நீர்ப்பாசனம்',
        sunlight: 'Full sun',
        sunlightTa: 'முழு சூரிய ஒளி',
        soilType: 'Sandy loam to clay loam',
        soilTypeTa: 'மணல் களிமண் முதல் களிமண் வரை',
        temperature: '25-35°C',
        humidity: 'Low to moderate',
        humidityTa: 'குறைவு முதல் மிதமான',
        fertilizing: 'NPK during sowing',
        fertilizingTa: 'விதைக்கும் போது NPK',
      ),
      diseases: [
        Disease(
          name: 'Downy Mildew',
          nameTa: 'பனி சாம்பல்',
          symptoms: 'Yellow stripes on leaves',
          symptomsTa: 'இலைகளில் மஞ்சள் கோடுகள்',
          treatment: ['Remove infected plants', 'Apply fungicide', 'Improve ventilation'],
          treatmentTa: ['நோய்த்தாக்கிய செடிகளை அகற்றுக', 'பூஞ்சைக்கொல்லி பயன்படுத்துக', 'காற்றோட்டத்தை மேம்படுத்துக'],
          prevention: ['Use resistant varieties', 'Crop rotation', 'Proper spacing'],
          preventionTa: ['எதிர்ப்பு ரகங்களைப் பயன்படுத்துக', 'பயிர் சுழற்சி', 'சரியான இடைவெளி'],
          severity: DiseaseLevel.severe,
        ),
      ],
    ),
    Plant(
      id: '13',
      name: 'Finger Millet',
      nameTa: 'கேழ்வரகு',
      scientificName: 'Eleusine coracana',
      icon: Icons.grass,
      description: 'Nutritious millet variety popular in Tamil Nadu.',
      descriptionTa: 'தமிழ்நாட்டில் பிரபலமான ஊட்டச்சத்து மிக்க சிறு தானியம்.',
      careGuide: CareGuide(
        wateringNeeds: 'Moderate irrigation',
        wateringNeedsTa: 'மிதமான நீர்ப்பாசனம்',
        sunlight: 'Full sun',
        sunlightTa: 'முழு சூரிய ஒளி',
        soilType: 'Red loamy soil',
        soilTypeTa: 'சிவப்பு களிமண்',
        temperature: '20-30°C',
        humidity: 'Moderate',
        humidityTa: 'மிதமான',
        fertilizing: 'Organic manure preferred',
        fertilizingTa: 'கரிம உரம் விரும்பத்தக்கது',
      ),
      diseases: [
        Disease(
          name: 'Blast Disease',
          nameTa: 'கருகல் நோய்',
          symptoms: 'Diamond-shaped spots on leaves',
          symptomsTa: 'இலைகளில் வைர வடிவ புள்ளிகள்',
          treatment: ['Apply fungicide', 'Remove affected parts', 'Improve drainage'],
          treatmentTa: ['பூஞ்சைக்கொல்லி பயன்படுத்துக', 'பாதிக்கப்பட்ட பகுதிகளை அகற்றுக', 'வடிகால் மேம்படுத்துக'],
          prevention: ['Use resistant varieties', 'Clean seeds', 'Proper spacing'],
          preventionTa: ['எதிர்ப்பு ரகங்களைப் பயன்படுத்துக', 'சுத்தமான விதைகள்', 'சரியான இடைவெளி'],
          severity: DiseaseLevel.severe,
        ),
      ],
    ),
    Plant(
      id: '14',
      name: 'Sorghum',
      nameTa: 'சோளம்',
      scientificName: 'Sorghum bicolor',
      icon: Icons.grass,
      description: 'Important fodder and food crop in Tamil Nadu.',
      descriptionTa: 'தமிழ்நாட்டில் முக்கிய தீவனப் பயிர் மற்றும் உணவு தானியம்.',
      careGuide: CareGuide(
        wateringNeeds: 'Moderate watering',
        wateringNeedsTa: 'மிதமான நீர்ப்பாசனம்',
        sunlight: 'Full sun',
        sunlightTa: 'முழு சூரிய ஒளி',
        soilType: 'Well-draining soil',
        soilTypeTa: 'நல்ல வடிகால் மண்',
        temperature: '25-35°C',
        humidity: 'Moderate',
        humidityTa: 'மிதமான',
        fertilizing: 'NPK application',
        fertilizingTa: 'NPK உரமிடல்',
      ),
      diseases: [
        Disease(
          name: 'Grain Mold',
          nameTa: 'தானிய பூஞ்சை',
          symptoms: 'Discolored and moldy grains',
          symptomsTa: 'நிறம் மாறிய மற்றும் பூஞ்சை பிடித்த தானியங்கள்',
          treatment: ['Early harvesting', 'Proper drying', 'Storage management'],
          treatmentTa: ['முன்கூட்டிய அறுவடை', 'சரியான உலர்த்துதல்', 'சேமிப்பு மேலாண்மை'],
          prevention: ['Resistant varieties', 'Timely harvest', 'Proper drying'],
          preventionTa: ['எதிர்ப்பு ரகங்கள்', 'சரியான நேர அறுவடை', 'சரியான உலர்த்துதல்'],
          severity: DiseaseLevel.moderate,
        ),
      ],
    ),
    Plant(
      id: '15',
      name: 'Green Gram',
      nameTa: 'பாசிப்பயறு',
      scientificName: 'Vigna radiata',
      icon: Icons.grass,
      description: 'Popular pulse crop in Tamil Nadu.',
      descriptionTa: 'தமிழ்நாட்டில் பிரபலமான பயறு வகை.',
      careGuide: CareGuide(
        wateringNeeds: 'Moderate irrigation',
        wateringNeedsTa: 'மிதமான நீர்ப்பாசனம்',
        sunlight: 'Full sun',
        sunlightTa: 'முழு சூரிய ஒளி',
        soilType: 'Well-draining loamy soil',
        soilTypeTa: 'நல்ல வடிகால் களிமண்',
        temperature: '25-35°C',
        humidity: 'Moderate',
        humidityTa: 'மிதமான',
        fertilizing: 'Light fertilization',
        fertilizingTa: 'லேசான உரமிடல்',
      ),
      diseases: [
        Disease(
          name: 'Yellow Mosaic',
          nameTa: 'மஞ்சள் தேமல்',
          symptoms: 'Yellow mosaic pattern on leaves',
          symptomsTa: 'இலைகளில் மஞ்சள் தேமல் வடிவம்',
          treatment: ['Remove infected plants', 'Control whiteflies', 'Use pesticides'],
          treatmentTa: ['நோய்த்தாக்கிய செடிகளை அகற்றுக', 'வெள்ளை ஈக்களை கட்டுப்படுத்துக', 'பூச்சிக்கொல்லி பயன்படுத்துக'],
          prevention: ['Resistant varieties', 'Early sowing', 'Field sanitation'],
          preventionTa: ['எதிர்ப்பு ரகங்கள்', 'முன்கூட்டிய விதைப்பு', 'வயல் சுத்தம்'],
          severity: DiseaseLevel.severe,
        ),
      ],
    ),
    Plant(
      id: '16',
      name: 'Maize',
      nameTa: 'சோளம்',
      scientificName: 'Zea mays',
      icon: Icons.grass,
      description: 'Important food and fodder crop.',
      descriptionTa: 'முக்கிய உணவு மற்றும் கால்நடை தீவனப் பயிர்.',
      careGuide: CareGuide(
        wateringNeeds: 'Regular irrigation',
        wateringNeedsTa: 'வழக்கமான நீர்ப்பாசனம்',
        sunlight: 'Full sun',
        sunlightTa: 'முழு சூரிய ஒளி',
        soilType: 'Well-draining loamy soil',
        soilTypeTa: 'நல்ல வடிகால் களிமண்',
        temperature: '20-30°C',
        humidity: 'Moderate',
        humidityTa: 'மிதமான',
        fertilizing: 'NPK at key growth stages',
        fertilizingTa: 'முக்கிய வளர்ச்சி நிலைகளில் NPK',
      ),
      diseases: [
        Disease(
          name: 'Leaf Blight',
          nameTa: 'இலை கருகல்',
          symptoms: 'Long elliptical grey-green lesions',
          symptomsTa: 'நீள்வட்ட சாம்பல்-பச்சை புண்கள்',
          treatment: ['Remove infected parts', 'Apply fungicide', 'Improve drainage'],
          treatmentTa: ['பாதிக்கப்பட்ட பகுதிகளை அகற்றுக', 'பூஞ்சைக்கொல்லி பயன்படுத்துக', 'வடிகால் மேம்படுத்துக'],
          prevention: ['Resistant varieties', 'Crop rotation', 'Proper spacing'],
          preventionTa: ['எதிர்ப்பு ரகங்கள்', 'பயிர் சுழற்சி', 'சரியான இடைவெளி'],
          severity: DiseaseLevel.severe,
        ),
      ],
    ),
    Plant(
      id: '17',
      name: 'Drumstick',
      nameTa: 'முருங்கை',
      scientificName: 'Moringa oleifera',
      icon: Icons.park,
      description: 'Nutritious tree with multiple uses, common in Tamil Nadu.',
      descriptionTa: 'தமிழ்நாட்டில் பொதுவான, பல பயன்கள் கொண்ட சத்தான மரம்.',
      careGuide: CareGuide(
        wateringNeeds: 'Moderate watering',
        wateringNeedsTa: 'மிதமான நீர்ப்பாசனம்',
        sunlight: 'Full sun',
        sunlightTa: 'முழு சூரிய ஒளி',
        soilType: 'Well-draining, sandy loam',
        soilTypeTa: 'நல்ல வடிகால் மணல் களிமண்',
        temperature: '25-35°C',
        humidity: 'Moderate',
        humidityTa: 'மிதமான',
        fertilizing: 'Organic manure quarterly',
        fertilizingTa: 'காலாண்டுக்கு ஒருமுறை கரிம உரம்',
      ),
      diseases: [
        Disease(
          name: 'Root Rot',
          nameTa: 'வேர் அழுகல்',
          symptoms: 'Yellowing leaves, wilting, root decay',
          symptomsTa: 'இலைகள் மஞ்சள் நிறமாதல், வாடுதல், வேர் அழுகல்',
          treatment: ['Improve drainage', 'Remove affected parts', 'Apply fungicide'],
          treatmentTa: ['வடிகால் மேம்படுத்துக', 'பாதிக்கப்பட்ட பகுதிகளை அகற்றுக', 'பூஞ்சைக்கொல்லி பயன்படுத்துக'],
          prevention: ['Well-draining soil', 'Avoid overwatering', 'Regular monitoring'],
          preventionTa: ['நல்ல வடிகால் மண்', 'அதிக நீர் பாய்ச்சுவதை தவிர்க்கவும்', 'தொடர் கண்காணிப்பு'],
          severity: DiseaseLevel.severe,
        ),
      ],
    ),
    Plant(
      id: '18',
      name: 'Gingelly',
      nameTa: 'எள்ளு',
      scientificName: 'Sesamum indicum',
      icon: Icons.grass,
      description: 'Important oilseed crop with medicinal value.',
      descriptionTa: 'மருத்துவ குணம் கொண்ட முக்கிய எண்ணெய் வித்து பயிர்.',
      careGuide: CareGuide(
        wateringNeeds: 'Moderate irrigation',
        wateringNeedsTa: 'மிதமான நீர்ப்பாசனம்',
        sunlight: 'Full sun',
        sunlightTa: 'முழு சூரிய ஒளி',
        soilType: 'Well-draining soil',
        soilTypeTa: 'நல்ல வடிகால் மண்',
        temperature: '25-35°C',
        humidity: 'Moderate',
        humidityTa: 'மிதமான',
        fertilizing: 'Light fertilization',
        fertilizingTa: 'லேசான உரமிடல்',
      ),
      diseases: [
        Disease(
          name: 'Phyllody',
          nameTa: 'இலை மாற்றம்',
          symptoms: 'Floral parts transform into leaf-like structures',
          symptomsTa: 'பூ பாகங்கள் இலை போன்ற அமைப்புகளாக மாறுதல்',
          treatment: ['Remove infected plants', 'Control insects', 'Improve drainage'],
          treatmentTa: ['நோய்த்தாக்கிய செடிகளை அகற்றுக', 'பூச்சிகளை கட்டுப்படுத்துக', 'வடிகால் மேம்படுத்துக'],
          prevention: ['Use healthy seeds', 'Early sowing', 'Field sanitation'],
          preventionTa: ['ஆரோக்கியமான விதைகள்', 'முன்கூட்டிய விதைப்பு', 'வயல் சுத்தம்'],
          severity: DiseaseLevel.severe,
        ),
      ],
    ),
    Plant(
      id: '19',
      name: 'Mango',
      nameTa: 'மாம்பழம்',
      scientificName: 'Mangifera indica',
      icon: Icons.park,
      description: 'Popular fruit tree grown throughout Tamil Nadu.',
      descriptionTa: 'தமிழ்நாடு முழுவதும் வளர்க்கப்படும் பிரபலமான பழ மரம்.',
      careGuide: CareGuide(
        wateringNeeds: 'Regular watering when young, drought tolerant when mature',
        wateringNeedsTa: 'இளம் மரத்திற்கு வழக்கமான நீர்ப்பாய்ச்சல், முதிர்ந்த மரம் வறட்சியை தாங்கக்கூடியது',
        sunlight: 'Full sun',
        sunlightTa: 'முழு சூரிய ஒளி',
        soilType: 'Well-draining, deep soil',
        soilTypeTa: 'நன்கு வடிகால் கொண்ட, ஆழமான மண்',
        temperature: '24-35°C',
        humidity: 'Moderate',
        humidityTa: 'மிதமான',
        fertilizing: 'NPK before flowering and fruiting',
        fertilizingTa: 'பூக்கும் மற்றும் காய்க்கும் முன் NPK',
      ),
      diseases: [
        Disease(
          name: 'Anthracnose',
          nameTa: 'அந்த்ராக்னோஸ்',
          symptoms: 'Dark spots on leaves and fruits',
          symptomsTa: 'இலைகள் மற்றும் பழங்களில் கருப்பு புள்ளிகள்',
          treatment: ['Apply fungicide', 'Remove infected parts', 'Improve air circulation'],
          treatmentTa: ['பூஞ்சைக்கொல்லி பயன்படுத்துக', 'நோய்த்தாக்கிய பகுதிகளை அகற்றுக', 'காற்றோட்டத்தை மேம்படுத்துக'],
          prevention: ['Regular pruning', 'Proper spacing', 'Clean orchard'],
          preventionTa: ['வழக்கமான கிளை வெட்டுதல்', 'சரியான இடைவெளி', 'சுத்தமான தோட்டம்'],
          severity: DiseaseLevel.moderate,
        ),
      ],
    ),
    Plant(
      id: '20',
      name: 'Guava',
      nameTa: 'கொய்யா',
      scientificName: 'Psidium guajava',
      icon: Icons.park,
      description: 'Hardy fruit tree with high nutritional value.',
      descriptionTa: 'அதிக ஊட்டச்சத்து மதிப்பு கொண்ட வலிமையான பழ மரம்.',
      careGuide: CareGuide(
        wateringNeeds: 'Regular watering',
        wateringNeedsTa: 'வழக்கமான நீர்ப்பாய்ச்சல்',
        sunlight: 'Full sun to partial shade',
        sunlightTa: 'முழு சூரிய ஒளி முதல் பகுதி நிழல் வரை',
        soilType: 'Rich, well-draining soil',
        soilTypeTa: 'வளமான, நல்ல வடிகால் மண்',
        temperature: '23-35°C',
        humidity: 'Moderate to high',
        humidityTa: 'மிதமான முதல் அதிக ஈரப்பதம்',
        fertilizing: 'Organic manure twice yearly',
        fertilizingTa: 'ஆண்டுக்கு இருமுறை கரிம உரம்',
      ),
      diseases: [
        Disease(
          name: 'Wilt',
          nameTa: 'வாடல்',
          symptoms: 'Yellowing leaves, wilting branches',
          symptomsTa: 'இலைகள் மஞ்சள் நிறமாதல், கிளைகள் வாடுதல்',
          treatment: ['Remove affected parts', 'Apply fungicide', 'Improve drainage'],
          treatmentTa: ['பாதிக்கப்பட்ட பகுதிகளை அகற்றுக', 'பூஞ்சைக்கொல்லி பயன்படுத்துக', 'வடிகால் மேம்படுத்துக'],
          prevention: ['Disease-free saplings', 'Proper spacing', 'Avoid waterlogging'],
          preventionTa: ['நோயற்ற கன்றுகள்', 'சரியான இடைவெளி', 'நீர் தேங்குவதை தவிர்க்கவும்'],
          severity: DiseaseLevel.severe,
        ),
      ],
    ),
    Plant(
      id: '21',
      name: 'Lemon',
      nameTa: 'எலுமிச்சை',
      scientificName: 'Citrus limon',
      icon: Icons.park,
      description: 'Popular citrus fruit tree with medicinal properties.',
      descriptionTa: 'மருத்துவ குணங்கள் கொண்ட பிரபலமான சிட்ரஸ் பழ மரம்.',
      careGuide: CareGuide(
        wateringNeeds: 'Regular but moderate watering',
        wateringNeedsTa: 'வழக்கமான ஆனால் மிதமான நீர்ப்பாய்ச்சல்',
        sunlight: 'Full sun',
        sunlightTa: 'முழு சூரிய ஒளி',
        soilType: 'Well-draining, slightly acidic soil',
        soilTypeTa: 'நல்ல வடிகால், சற்று அமில மண்',
        temperature: '20-30°C',
        humidity: 'Moderate',
        humidityTa: 'மிதமான',
        fertilizing: 'NPK every 3-4 months',
        fertilizingTa: 'ஒவ்வொரு 3-4 மாதங்களுக்கும் NPK',
      ),
      diseases: [
        Disease(
          name: 'Citrus Canker',
          nameTa: 'சிட்ரஸ் கேங்கர்',
          symptoms: 'Raised lesions on leaves, fruits and stems',
          symptomsTa: 'இலைகள், பழங்கள் மற்றும் தண்டுகளில் புடைத்த புண்கள்',
          treatment: ['Remove infected parts', 'Copper-based sprays', 'Prune affected areas'],
          treatmentTa: ['நோய்த்தாக்கிய பகுதிகளை அகற்றுக', 'செம்பு அடிப்படையிலான தெளிப்புகள்', 'பாதிக்கப்பட்ட பகுதிகளை வெட்டுக'],
          prevention: ['Disease-free plants', 'Windbreaks', 'Avoid overhead irrigation'],
          preventionTa: ['நோயற்ற செடிகள்', 'காற்றுத் தடுப்புகள்', 'மேலிருந்து நீர் பாய்ச்சுவதை தவிர்க்கவும்'],
          severity: DiseaseLevel.severe,
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.isSelecting) {
      // Initialize with currently selected plants to mark them as selected in UI
      final currentPlants = Provider.of<UserProvider>(context, listen: false).selectedPlants;
      _selectedPlants.addAll(currentPlants);
    }
  }

  void _savePlantsAndNavigate() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Get existing plants and create a map using plant ID as key to prevent duplicates
    final Map<String, Plant> uniquePlants = {};
    
    // Add existing plants first
    if (widget.isSelecting) {
      for (var plant in userProvider.selectedPlants) {
        uniquePlants[plant.id] = plant;
      }
    }
    
    // Add newly selected plants, overwriting any existing ones with same ID
    for (var plant in _selectedPlants) {
      uniquePlants[plant.id] = plant;
    }

    // Convert back to list and save
    userProvider.setSelectedPlants(uniquePlants.values.toList());
    
    if (widget.isSelecting) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.watch<LanguageProvider>().getText(
          widget.isSelecting ? 'add_plants' : 'select_plants'
        )),
        // Add close button when selecting additional plants
        leading: widget.isSelecting
          ? IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _availablePlants.length,
        itemBuilder: (context, index) {
          final plant = _availablePlants[index];
          final isSelected = _selectedPlants.contains(plant);

          return InkWell(
            onTap: () {
              setState(() {
                if (isSelected) {
                  _selectedPlants.remove(plant);
                } else {
                  _selectedPlants.add(plant);
                }
              });
            },
            child: Card(
              color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(plant.icon, size: 48),
                  const SizedBox(height: 8),
                  Text(
                    context.watch<LanguageProvider>().currentLanguage == 'ta'
                        ? plant.nameTa
                        : plant.name,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (isSelected)
                    const Icon(Icons.check_circle, color: Colors.green),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _selectedPlants.isEmpty ? null : _savePlantsAndNavigate,
        label: Text(context.watch<LanguageProvider>().getText('done')),
        icon: const Icon(Icons.check),
      ),
    );
  }
}
