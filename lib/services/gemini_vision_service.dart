import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class GeminiVisionService {
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1/models/gemini-2.0-flash:generateContent';
  static const String _apiKey = 'AIzaSyD7x2iHKovPb_SHcI6i5kHVs6uLvRl-Bsk';

  Future<String> analyzeImage(Uint8List imageBytes, String languageCode) async {
    final base64Image = base64Encode(imageBytes);
    final prompt = _getAnalysisPrompt(languageCode);
    
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": {
            "parts": [
              {"text": prompt},
              {
                "inlineData": {
                  "mimeType": "image/jpeg",
                  "data": base64Image
                }
              }
            ]
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        print('Error response: ${response.body}');
        throw Exception('Failed to analyze image: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error analyzing image: $e');
    }
  }

  String _getAnalysisPrompt(String languageCode) {
    switch (languageCode) {
      case 'ta':
        return 'முதலில் இந்த தாவரத்தை அடையாளம் காணவும். பின்னர் அதன் படத்தை ஆய்வு செய்து, ஏதேனும் நோய்கள் அல்லது ஆரோக்கிய பிரச்சினைகளை கண்டறியவும். பிரச்சினைகள் இருந்தால், பின்வரும் தீர்வுகளை வழங்கவும்: 1) பரிந்துரைக்கப்படும் பூச்சிக்கொல்லிகள், 2) இயற்கை/கரிம மாற்று வழிகள், 3) பிரச்சினையை சரிசெய்ய படிப்படியான வழிமுறைகள்.';
      default:
        return 'First, identify this plant species. Then analyze the plant image and identify any diseases or health issues. If there are issues, provide: 1) Recommended pesticides or chemical treatments, 2) Natural/organic alternatives, 3) Step-by-step procedure to eradicate the problem. Be specific with product names and application methods where possible.';
    }
  }
}
