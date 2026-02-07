import 'dart:convert';
import 'chat_message.dart';

class ChatHistory {
  final List<ChatMessage> messages;
  final DateTime timestamp;
  final String title;

  ChatHistory({
    required this.messages,
    required this.timestamp,
    required this.title,
  });

  Map<String, dynamic> toJson() => {
    'messages': messages.map((msg) => {
      'message': msg.message,
      'isUser': msg.isUser,
      'timestamp': msg.timestamp.toIso8601String(),
    }).toList(),
    'timestamp': timestamp.toIso8601String(),
    'title': title,
  };

  factory ChatHistory.fromJson(Map<String, dynamic> json) => ChatHistory(
    messages: (json['messages'] as List).map((msg) => ChatMessage(
      message: msg['message'],
      isUser: msg['isUser'],
      timestamp: DateTime.parse(msg['timestamp']),
    )).toList(),
    timestamp: DateTime.parse(json['timestamp']),
    title: json['title'],
  );
}
