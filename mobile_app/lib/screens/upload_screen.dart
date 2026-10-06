import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/api_service.dart';
import 'analysis_result_screen.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final ImagePicker _picker = ImagePicker();

  XFile? selectedImage;
  String selectedFramework = 'flutter';
  bool isLoading = false;

  Future<void> pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = image;
      });
    }
  }

  Future<void> analyzeImage() async {
    if (selectedImage == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      final result = await ApiService.analyzeScreenshot(
        imagePath: selectedImage!.path,
        framework: selectedFramework,
      );

      if (!mounted) return;

      debugPrint('AI Result: $result');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnalysisResultScreen(result: result),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      debugPrint('Analysis error: $e');

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Analysis failed: $e')));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analyze Screenshot')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            InkWell(
              onTap: isLoading ? null : pickImage,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: selectedImage == null
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_outlined, size: 50),
                          SizedBox(height: 12),
                          Text(
                            'Select Screenshot',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          File(selectedImage!.path),
                          fit: BoxFit.contain,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 24),

            DropdownButtonFormField<String>(
              value: selectedFramework,
              decoration: const InputDecoration(
                labelText: 'Framework',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'flutter', child: Text('Flutter')),
                DropdownMenuItem(value: 'ios', child: Text('iOS')),
                DropdownMenuItem(value: 'android', child: Text('Android')),
              ],
              onChanged: isLoading
                  ? null
                  : (value) {
                      if (value != null) {
                        setState(() {
                          selectedFramework = value;
                        });
                      }
                    },
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: selectedImage == null || isLoading
                    ? null
                    : analyzeImage,
                icon: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.auto_awesome),
                label: Text(isLoading ? 'Analyzing...' : 'Analyze with AI'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
