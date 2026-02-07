import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../models/chat_message.dart';
import '../providers/chat_provider.dart';
import '../services/gemini_service.dart';
import '../utils/message_formatter.dart';
import '../providers/language_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GeminiService _geminiService = GeminiService();
  late final ChatProvider _chatProvider;

  @override
  void initState() {
    super.initState();
    _chatProvider = Provider.of<ChatProvider>(context, listen: false);
    // Load chat history when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _chatProvider.loadChatHistory();
    });
  }

  @override
  void dispose() {
    _chatProvider.saveCurrentChat();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _controller.clear();
    // Clear system keyboard buffer
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    
    await chatProvider.addMessage(ChatMessage(
      message: text,
      isUser: true,
    ));
    
    chatProvider.setLoading(true);

    try {
      final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
      final response = await _geminiService.generateResponse(
        text,
        languageProvider.currentLanguage,
      );
      await chatProvider.addMessage(ChatMessage(
        message: response,
        isUser: false,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
          '${Provider.of<LanguageProvider>(context, listen: false).getText('error_occurred')}: ${e.toString()}'
        )),
      );
    } finally {
      chatProvider.setLoading(false);
    }
  }

  void _showChatHistory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.2,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, controller) => Consumer2<ChatProvider, LanguageProvider>(
          builder: (context, chatProvider, languageProvider, _) {
            final history = chatProvider.chatHistory;
            if (history.isEmpty) {
              return Center(
                child: Text(languageProvider.getText('no_chat_history')),
              );
            }
            
            // Sort dates in descending order
            final dates = history.keys.toList()
              ..sort((a, b) => b.compareTo(a));
            
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        languageProvider.getText('chat_history'),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _showDeleteConfirmation(context, chatProvider),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: controller,
                    itemCount: dates.length,
                    itemBuilder: (context, index) {
                      final date = dates[index];
                      final messages = history[date]!;
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              _formatDate(DateTime.parse(date)),
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          _buildChatHistoryItem(context, date, messages),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(BuildContext context, ChatProvider chatProvider) async {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(languageProvider.getText('confirm_delete_chat_history')),
        content: Text(languageProvider.getText('delete_chat_history_message')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(languageProvider.getText('cancel')),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(languageProvider.getText('delete')),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await chatProvider.clearChatHistory();
      Navigator.pop(context);
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month) {
      if (date.day == now.day) return 'Today';
      if (date.day == now.day - 1) return 'Yesterday';
    }
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildChatHistoryItem(BuildContext context, String date, List<ChatMessage> messages) {
    // Get first user message as preview
    final firstUserMessage = messages.firstWhere((msg) => msg.isUser);
    final messagesCount = messages.length;
    
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      child: ListTile(
        title: Text(
          firstUserMessage.message,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '$messagesCount messages • ${_formatTime(firstUserMessage.timestamp)}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Provider.of<ChatProvider>(context, listen: false)
              .loadHistoryMessages(date);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(languageProvider.getText('plant_assistant')),
            actions: [
              IconButton(
                icon: const Icon(Icons.history),
                onPressed: _showChatHistory,
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Consumer<ChatProvider>(
                    builder: (context, chatProvider, _) {
                      return ListView.builder(
                        controller: _scrollController,
                        reverse: true,
                        padding: const EdgeInsets.all(8.0),
                        itemCount: chatProvider.messages.length,
                        itemBuilder: (context, index) {
                          final message = chatProvider.messages[chatProvider.messages.length - 1 - index];
                          return _buildMessageBubble(message);
                        },
                      );
                    },
                  ),
                ),
                Consumer<ChatProvider>(
                  builder: (context, chatProvider, _) {
                    if (chatProvider.isLoading) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: languageProvider.getText('ask_plants'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: _sendMessage,
                        icon: const Icon(Icons.send),
                        tooltip: languageProvider.getText('send'),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: message.isUser
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: RichText(
          text: MessageFormatter.formatText(
            message.message,
            baseStyle: TextStyle(
              color: message.isUser
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface,
              fontSize: 15,
              height: 1.4,
            ),
          ),
        ),
      ),
    );
  }
}
