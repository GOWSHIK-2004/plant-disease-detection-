import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_message.dart';

class ChatProvider with ChangeNotifier {
  static const String _chatHistoryKey = 'chat_history';
  static const int maxMessages = 50;

  final List<ChatMessage> _messages = [];
  Map<String, List<ChatMessage>> _chatHistory = {};
  bool _isLoading = false;

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  Map<String, List<ChatMessage>> get chatHistory => Map.unmodifiable(_chatHistory);
  bool get isLoading => _isLoading;

  Future<void> addMessage(ChatMessage message) async {
    if (_messages.length >= maxMessages) {
      _messages.removeRange(0, _messages.length - maxMessages + 1);
    }
    _messages.add(message);
    await saveCurrentChat(); // Save after each message
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }

  Future<void> saveCurrentChat() async {
    if (_messages.isEmpty) return;

    final today = DateTime.now().toIso8601String().split('T')[0];
    
    // Create new list for today if it doesn't exist
    if (!_chatHistory.containsKey(today)) {
      _chatHistory[today] = [];
    }

    // Store the complete conversation for today
    _chatHistory[today] = List.from(_messages);

    // Keep only last 100 messages per day to prevent memory issues
    if (_chatHistory[today]!.length > 100) {
      _chatHistory[today] = _chatHistory[today]!.sublist(_chatHistory[today]!.length - 100);
    }

    await _saveChatHistory();
    notifyListeners();
  }

  Future<void> _saveChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = _chatHistory.map((date, messages) => MapEntry(
      date,
      messages.map((msg) => {
        'message': msg.message,
        'isUser': msg.isUser,
        'timestamp': msg.timestamp.toIso8601String(),
      }).toList(),
    ));
    await prefs.setString(_chatHistoryKey, jsonEncode(historyJson));
  }

  Future<void> loadChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyStr = prefs.getString(_chatHistoryKey);
    if (historyStr != null) {
      final historyJson = jsonDecode(historyStr) as Map<String, dynamic>;
      _chatHistory = historyJson.map((date, messages) => MapEntry(
        date,
        (messages as List).map((msg) => ChatMessage(
          message: msg['message'],
          isUser: msg['isUser'],
          timestamp: DateTime.parse(msg['timestamp']),
        )).toList(),
      ));
      notifyListeners();
    }
  }

  Future<void> clearChatHistory() async {
    _chatHistory.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_chatHistoryKey);
    notifyListeners();
  }

  void loadHistoryMessages(String date) {
    _messages.clear();
    if (_chatHistory.containsKey(date)) {
      _messages.addAll(_chatHistory[date]!);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    saveCurrentChat(); // Save when disposing
    super.dispose();
  }
}
