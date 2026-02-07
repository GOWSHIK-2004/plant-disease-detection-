import 'package:flutter/material.dart';

class MessageFormatter {
  static TextSpan formatText(String text, {TextStyle? baseStyle}) {
    final List<TextSpan> spans = [];
    final lines = text.split('\n');
    bool inCodeBlock = false;
    
    for (var i = 0; i < lines.length; i++) {
      String line = lines[i].trim();
      
      // Handle titles (any line with a colon that isn't an inline phrase)
      if (line.contains(':') && !line.contains('**') && !inCodeBlock) {
        final colonIndex = line.indexOf(':');
        final title = line.substring(0, colonIndex).trim();
        final content = line.substring(colonIndex + 1).trim();
        
        // Add title with larger font and bold
        spans.add(TextSpan(
          text: '$title:',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            height: 1.5,
          ),
        ));
        
        // Add remaining content if any
        if (content.isNotEmpty) {
          spans.add(TextSpan(text: ' $content'));
        }
        
        if (i < lines.length - 1) spans.add(const TextSpan(text: '\n'));
        continue;
      }

      // Handle bullet points
      if (line.startsWith('-')) {
        line = '• ${line.substring(1).trim()}';
      }

      // Handle bold text consistently
      if (line.contains('**')) {
        var parts = line.split('**');
        var isInBold = false;
        
        for (var part in parts) {
          if (part.isNotEmpty) {
            spans.add(TextSpan(
              text: part,
              style: isInBold ? const TextStyle(fontWeight: FontWeight.w600) : null,
            ));
          }
          isInBold = !isInBold;
        }
      } else {
        spans.add(TextSpan(text: line));
      }

      // Add newline if not the last line
      if (i < lines.length - 1) {
        spans.add(const TextSpan(text: '\n'));
      }
    }

    return TextSpan(
      style: baseStyle,
      children: spans,
    );
  }
}
