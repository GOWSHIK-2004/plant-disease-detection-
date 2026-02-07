import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/gemini_vision_service.dart';
import '../utils/message_formatter.dart';
import '../providers/language_provider.dart';
import '../providers/user_provider.dart';
import '../models/scan_result.dart';
import 'package:provider/provider.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final GeminiVisionService _geminiVision = GeminiVisionService();
  final ImagePicker _picker = ImagePicker();
  File? _image;
  String? _analysis;
  bool _isAnalyzing = false;

  Future<void> _captureImage(ImageSource source) async {
    try {
      final XFile? photo = await _picker.pickImage(source: source);
      if (photo != null) {
        setState(() {
          _image = File(photo.path);
          _analysis = null;
        });
        await _analyzeImage();
      }
    } catch (e) {
      final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${languageProvider.getText('error_capturing')}: $e')),
      );
    }
  }

  Future<void> _analyzeImage() async {
    if (_image == null) return;

    setState(() {
      _isAnalyzing = true;
    });

    try {
      final bytes = await _image!.readAsBytes();
      final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
      final analysis = await _geminiVision.analyzeImage(
        bytes,
        languageProvider.currentLanguage,
      );
      
      // Save the result
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.addScanResult(ScanResult(
        imagePath: _image!.path,
        analysis: analysis,
        timestamp: DateTime.now(),
      ));
      
      setState(() {
        _analysis = analysis;
      });
    } catch (e) {
      final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${languageProvider.getText('error_analyzing')}: $e')),
      );
    } finally {
      setState(() {
        _isAnalyzing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(languageProvider.getText('plant_scanner')),
            actions: [
              IconButton(
                icon: const Icon(Icons.history),
                onPressed: _showScanHistory,
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_image != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _image!,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (_isAnalyzing)
                    const Center(child: CircularProgressIndicator())
                  else if (_analysis != null) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: RichText(
                          text: MessageFormatter.formatText(
                            _analysis!,
                            baseStyle: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 72, // Increased height
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero, // Remove default padding
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Theme.of(context).colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () => _captureImage(ImageSource.camera),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.camera_alt, size: 24),
                                  const SizedBox(height: 4),
                                  Text(
                                    languageProvider.getText('take_photo'),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 12, height: 1.2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SizedBox(
                          height: 72, // Increased height
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero, // Remove default padding
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Theme.of(context).colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () => _captureImage(ImageSource.gallery),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.photo_library, size: 24),
                                  const SizedBox(height: 4),
                                  Text(
                                    languageProvider.getText('pick_gallery'),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 12, height: 1.2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showScanHistory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.2,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, controller) => Consumer2<UserProvider, LanguageProvider>(
          builder: (context, userProvider, languageProvider, _) {
            final history = userProvider.scanHistory;
            if (history.isEmpty) {
              return Center(
                child: Text(languageProvider.getText('no_scan_history')),
              );
            }
            
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        languageProvider.getText('scan_history'),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          userProvider.clearScanHistory();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: controller,
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final scan = history[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _image = File(scan.imagePath);
                              _analysis = scan.analysis;
                            });
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(scan.imagePath),
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        scan.analysis.split('\n').first,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _formatDate(scan.timestamp),
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
