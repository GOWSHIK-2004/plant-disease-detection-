import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  static const String _languageKey = 'selected_language';
  late SharedPreferences _prefs;
  Locale _currentLocale = const Locale('en');
  bool _initialized = false;

  final Map<String, Map<String, String>> _translations = {
    'en': {
      'settings': 'Settings',
      'language': 'Language',
      'scan': 'Scan',
      'home': 'Home',
      'dashboard': 'Dashboard',
      'chat': 'Chat',
      'retry': 'Retry',
      'no_internet': 'No Internet Connection',
      'check_internet': 'Please check your internet connection and try again',
      'plant_monitor': 'Botaniq',
      'loading': 'Loading...',
      'success': 'Success',
      'error': 'Error',
      'cancel': 'Cancel',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'add': 'Add',
      'temperature': 'Temperature',
      'humidity': 'Humidity',
      'moisture': 'Moisture',
      'light': 'Light',
      'status': 'Status',
      'last_updated': 'Last Updated',
      'plant_health': 'Plant Health',
      'water_now': 'Water Now',
      'healthy': 'Healthy',
      'needs_attention': 'Needs Attention',
      'sensor_readings': 'Sensor Readings',
      'sensor_trends': 'Sensor Trends',
      'plant_status': 'Plant Status',
      'logout': 'Logout',
      'plant_assistant': 'Plant Assistant',
      'ask_plants': 'Ask about your plants...',
      'soil_moisture': 'Soil Moisture',
      'time_hours': 'Time (hours)',
      'temperature_unit': '°C',
      'celsius': 'Celsius',
      'lux': 'lux',
      'percent': '%',
      'temperature_axis': 'Temperature (°C)',
      'humidity_axis': 'Humidity (%)',
      'moisture_axis': 'Moisture (%)',
      'light_axis': 'Light (lux)',
      'error_occurred': 'Error occurred',
      'send': 'Send',
      'plant_scanner': 'Plant Scanner',
      'take_photo': 'Take Photo',
      'pick_gallery': 'Pick from Gallery',
      'error_capturing': 'Error capturing image',
      'error_analyzing': 'Error analyzing image',
      'select_plants': 'Select Plants',
      'done': 'Done',
      'care_guide': 'Care Guide',
      'features': 'Features',
      'common_diseases': 'Common Diseases',
      'watering': 'Watering',
      'sunlight': 'Sunlight',
      'soil': 'Soil',
      'soil_type': 'Soil Type',
      'temperature': 'Temperature',
      'humidity': 'Humidity',
      'fertilizing': 'Fertilizing',
      'symptoms': 'Symptoms',
      'treatment_steps': 'Treatment Steps',
      'prevention': 'Prevention',
      'severity': 'Severity',
      'mild': 'MILD',
      'moderate': 'MODERATE',
      'severe': 'SEVERE',
      'scientific_name': 'Scientific Name',
      'description': 'Description',
      'confirm_logout': 'Are you sure you want to log out?',
      'yes': 'Yes',
      'no': 'No',
      'appearance': 'Appearance',
      'dark_mode': 'Dark Mode',
      'add_plants': 'Add Plants',
      'scan_history': 'Scan History',
      'no_scan_history': 'No scan history yet',
      'chat_history': 'Chat History',
      'no_chat_history': 'No chat history yet',
      'confirm_delete_chat_history': 'Delete Chat History',
      'delete_chat_history_message': 'Are you sure you want to delete all chat history? This action cannot be undone.',
    },
    'ta': {
      'settings': 'அமைப்புகள்',
      'language': 'மொழி',
      'scan': 'ஸ்கேன்',
      'home': 'முகப்பு',
      'dashboard': 'டாஷ்போர்டு',
      'chat': 'அரட்டை',
      'retry': 'மீண்டும் முயற்சி',
      'no_internet': 'இணைய இணைப்பு இல்லை',
      'check_internet': 'உங்கள் இணைய இணைப்பை சரிபார்த்து மீண்டும் முயற்சிக்கவும்',
      'plant_monitor': 'பொட்டானிக்',
      'loading': 'ஏற்றுகிறது...',
      'success': 'வெற்றி',
      'error': 'பிழை',
      'cancel': 'ரத்து',
      'save': 'சேமி',
      'delete': 'அழி',
      'edit': 'தொகு',
      'add': 'சேர்',
      'temperature': 'வெப்பநிலை',
      'humidity': 'ஈரப்பதம்',
      'moisture': 'ஈரம்',
      'light': 'ஒளி',
      'status': 'நிலை',
      'last_updated': 'கடைசியாக புதுப்பிக்கப்பட்டது',
      'plant_health': 'தாவர ஆரோக்கியம்',
      'water_now': 'நீர் ஊற்றவும்',
      'healthy': 'ஆரோக்கியமான',
      'needs_attention': 'கவனம் தேவை',
      'sensor_readings': 'உணர்வி அளவீடுகள்',
      'sensor_trends': 'உணர்வி போக்குகள்',
      'plant_status': 'தாவர நிலை',
      'logout': 'வெளியேறு',
      'plant_assistant': 'தாவர உதவியாளர்',
      'ask_plants': 'உங்கள் தாவரங்களைப் பற்றி கேளுங்கள்...',
      'soil_moisture': 'மண் ஈரப்பதம்',
      'time_hours': 'நேரம் (மணி)',
      'error_occurred': 'பிழை ஏற்பட்டது',
      'send': 'அனுப்பு',
      'plant_scanner': 'தாவர ஸ்கேனர்',
      'take_photo': 'புகைப்படம் எடு',
      'pick_gallery': 'கேலரியில் இருந்து தேர்வு',
      'error_capturing': 'படம் எடுப்பதில் பிழை',
      'error_analyzing': 'படம் பகுப்பாய்வில் பிழை',
      'select_plants': 'செடிகளைத் தேர்ந்தெடுக்கவும்',
      'done': 'முடிந்தது',
      'care_guide': 'பராமரிப்பு வழிகாட்டி',
      'features': 'அம்சங்கள்',
      'common_diseases': 'பொதுவான நோய்கள்',
      'watering': 'நீர் பாய்ச்சுதல்',
      'sunlight': 'சூரிய ஒளி',
      'soil': 'மண்',
      'soil_type': 'மண் வகை',
      'temperature': 'வெப்பநிலை',
      'humidity': 'ஈரப்பதம்',
      'fertilizing': 'உரமிடுதல்',
      'symptoms': 'அறிகுறிகள்',
      'treatment_steps': 'சிகிச்சை படிகள்',
      'prevention': 'தடுப்பு முறைகள்',
      'severity': 'தீவிரம்',
      'mild': 'லேசானது',
      'moderate': 'மிதமானது',
      'severe': 'கடுமையானது',
      'scientific_name': 'அறிவியல் பெயர்',
      'description': 'விளக்கம்',
      'confirm_logout': 'நீங்கள் வெளியேற விரும்புகிறீர்களா?',
      'yes': 'ஆம்',
      'no': 'இல்லை',
      'appearance': 'தோற்றம்',
      'dark_mode': 'இருண்ட பயன்முறை',
      'add_plants': 'செடிகளைச் சேர்க்கவும்',
      'scan_history': 'ஸ்கேன் வரலாறு',
      'no_scan_history': 'ஸ்கேன் வரலாறு எதுவும் இல்லை',
      'chat_history': 'அரட்டை வரலாறு',
      'no_chat_history': 'அரட்டை வரலாறு எதுவும் இல்லை',
      'confirm_delete_chat_history': 'அரட்டை வரலாற்றை நீக்கு',
      'delete_chat_history_message': 'அனைத்து அரட்டை வரலாற்றையும் நீக்க விரும்புகிறீர்களா? இந்த செயலை மீட்டெடுக்க முடியாது.',
    }
  };

  LanguageProvider() {
    _loadLanguagePreference();
  }

  Locale get currentLocale => _currentLocale;
  bool get isInitialized => _initialized;

  String get currentLanguage => _currentLocale.languageCode;

  String getText(String key) {
    if (!_initialized) return key;
    return _translations[currentLanguage]?[key] ?? key;
  }

  bool isLanguage(String code) => currentLanguage == code;

  Future<void> _loadLanguagePreference() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      final String langCode = _prefs.getString(_languageKey) ?? 'en';
      _currentLocale = Locale(langCode);
      _initialized = true;
      notifyListeners();
    } catch (e) {
      _currentLocale = const Locale('en');
      _initialized = true;
      notifyListeners();
    }
  }

  Future<void> setLanguage(String languageCode) async {
    if (!_initialized) await _loadLanguagePreference();
    if (languageCode == currentLanguage) return;
    
    _currentLocale = Locale(languageCode);
    await _prefs.setString(_languageKey, languageCode);
    notifyListeners();
  }
}
