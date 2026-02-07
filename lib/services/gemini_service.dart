import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';
  static const String _apiKey = 'AIzaSyD7x2iHKovPb_SHcI6i5kHVs6uLvRl-Bsk';

  Future<String> generateResponse(String input, String languageCode) async {
    final prompt = _getLanguagePrompt(languageCode) + input;

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {'parts': [{'text': prompt}]}
          ],
          'generationConfig': {
            'temperature': 0.7,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 1024,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        throw Exception('Failed to generate response: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error generating response: $e');
    }
  }

  String _getLanguagePrompt(String languageCode) {
    switch (languageCode) {
      case 'ta':
        return 'Respond in Tamil language. User question: ';
      default:
        return 'Respond in English. User question: ';
    }
  }
}
