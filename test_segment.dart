import 'package:flutter/material.dart';
import 'package:thai_word_segmentation/thai_word_segmentation.dart';

void main() {
  final segmenter = ThaiTextSegmenter();
  final breaker = ThaiLineBreaker();

  // Test segmentation
  print('=== SEGMENT TEST ===');
  final segments = segmenter.segment('กรุงเทพมหานคร');
  print('Segments: $segments');
  print('Joined: ${segments.join("")}');

  // Test syllables
  print('\n=== SYLLABLES TEST ===');
  final syllables = segmenter.groupBySyllables('กรุงเทพมหานคร');
  print('Syllables: $syllables');
  print('Joined: ${syllables.join("")}');

  // Test line breaking
  print('\n=== LINE BREAK TEST (width 80.7) ===');
  final lines = breaker.breakLinesThaiAware('กรุงเทพมหานคร', textStyle: const TextStyle(fontSize: 16), maxWidth: 80.7);
  print('Lines: $lines');
  print('Joined: ${lines.join("")}');
}
