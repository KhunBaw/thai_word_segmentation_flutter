import 'package:flutter/material.dart';
import 'package:thai_word_segmentation/thai_word_segmentation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thai Word Segmentation Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const ThaiSegmentationDemo(),
    );
  }
}

class ThaiSegmentationDemo extends StatefulWidget {
  const ThaiSegmentationDemo({Key? key}) : super(key: key);

  @override
  State<ThaiSegmentationDemo> createState() => _ThaiSegmentationDemoState();
}

class _ThaiSegmentationDemoState extends State<ThaiSegmentationDemo> {
  late ThaiTextEditingController _controller;
  final ThaiTextSegmenter _segmenter = ThaiTextSegmenter();
  // final ThaiLineBreaker _breaker = ThaiLineBreaker();

  @override
  void initState() {
    super.initState();
    _controller = ThaiTextEditingController();
    _controller.text = 'สวัสดีชาวไทย ยินดีต้อนรับคุณ';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thai Word Segmentation & Line Breaking')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input TextField
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Input Text', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _controller,
                      minLines: 3,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Enter Thai text here',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Text Segmentation
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Text Segmentation (Words)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _buildSegmentationResult(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Syllables
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Syllable Grouping', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _buildSyllableResult(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Statistics
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Text Statistics', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _buildStatistics(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Line Breaking Example
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Line Breaking (Max Width: 200px)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _buildLineBreakingExample(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ThaiText Widget Demo
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('ThaiTextWidget Demo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ThaiLineBreakText(
                      _controller.text,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      maxWidth: 300,
                      useThaiAwareBreaking: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentationResult() {
    final segments = _controller.getSegments();
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        for (String segment in segments)
          if (segment.trim().isNotEmpty)
            Chip(label: Text(segment), backgroundColor: Colors.blue[100])
          else if (segment == ' ')
            const Chip(label: Text('SPACE'), backgroundColor: Colors.grey),
      ],
    );
  }

  Widget _buildSyllableResult() {
    final syllables = _segmenter.groupBySyllables(_controller.text);
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        for (String syllable in syllables)
          if (syllable.trim().isNotEmpty) Chip(label: Text(syllable), backgroundColor: Colors.green[100]),
      ],
    );
  }

  Widget _buildStatistics() {
    final wordCount = _controller.getWordCount();
    final syllableCount = _controller.getSyllableCount();
    final charCount = _controller.text.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text('Character Count: $charCount'), Text('Word Count: $wordCount'), Text('Syllable Count: $syllableCount')],
    );
  }

  Widget _buildLineBreakingExample() {
    final lines = _controller.getLines(style: const TextStyle(fontSize: 14), maxWidth: 200);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (String line in lines)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.amber[50],
              child: Text(line, style: const TextStyle(fontSize: 14)),
            ),
          ),
      ],
    );
  }
}
