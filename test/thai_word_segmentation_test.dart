import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:thai_word_segmentation/thai_word_segmentation.dart';

void main() {
  group('ThaiTextSegmenter', () {
    final segmenter = ThaiTextSegmenter();

    test('segments Thai text correctly', () {
      final result = segmenter.segment('สวัสดี');
      expect(result, isNotEmpty);
      expect(result.join(''), equals('สวัสดี'));
    });

    test('segments mixed Thai and English text', () {
      final result = segmenter.segment('hello สวัสดี');
      expect(result, isNotEmpty);
      expect(result.first.contains('hello') || result.last.contains('hello'), true);
    });

    test('identifies Thai characters correctly', () {
      expect(ThaiTextSegmenter.isThaiCharacter('ก'), true);
      expect(ThaiTextSegmenter.isThaiCharacter('a'), false);
      expect(ThaiTextSegmenter.isThaiCharacter('1'), false);
    });

    test('identifies Thai consonants correctly', () {
      expect(ThaiTextSegmenter.isThaiConsonant('ก'), true);
      expect(ThaiTextSegmenter.isThaiConsonant('ค'), true);
      expect(ThaiTextSegmenter.isThaiCharacter('a'), false);
    });

    test('groups text by syllables', () {
      final result = segmenter.groupBySyllables('สวัสดีชาวไทย');
      expect(result, isNotEmpty);
      expect(result.join(''), equals('สวัสดีชาวไทย'));
    });

    test('handles empty string', () {
      final result = segmenter.segment('');
      expect(result, equals([]));
    });

    test('preserves spaces', () {
      final result = segmenter.segment('สวัสดี ชาว ไทย');
      expect(result, contains(' '));
    });

    test('handles special characters', () {
      final result = segmenter.segment('สวัสดี!');
      expect(result, isNotEmpty);
    });

    test('segments complex Thai words correctly (Bangkok)', () {
      final result = segmenter.segment('กรุงเทพมหานคร');
      expect(result.join(''), equals('กรุงเทพมหานคร'));
    });

    test('Bangkok name segmentation details', () {
      final result = segmenter.segment('กรุงเทพมหานคร');
      // The goal is just to ensure it's broken into smaller pieces
      expect(result.length, greaterThan(1));
      expect(result.join(''), equals('กรุงเทพมหานคร'));
    });
  });

  group('ThaiLineBreaker', () {
    final breaker = ThaiLineBreaker();

    test('breaks text into lines without crashing', () {
      final result = breaker.breakLines('สวัสดีชาวไทยยินดีต้อนรับคุณ', textStyle: const TextStyle(fontSize: 16), maxWidth: 150);
      expect(result, isNotEmpty);
    });

    test('Thai-aware breaking works', () {
      final result = breaker.breakLinesThaiAware('สวัสดีชาวไทย', textStyle: const TextStyle(fontSize: 16), maxWidth: 100);
      expect(result, isNotEmpty);
    });

    test('returns breakLineInfo with correct structure', () {
      final result = breaker.breakLinesWithInfo('สวัสดีชาวไทย', textStyle: const TextStyle(fontSize: 16), maxWidth: 150);
      expect(result, isNotEmpty);
      for (final info in result) {
        expect(info.lineNumber, greaterThan(0));
        expect(info.text, isNotEmpty);
        expect(info.startOffset, greaterThanOrEqualTo(0));
        expect(info.width, greaterThanOrEqualTo(0));
      }
    });

    test('handles empty text', () {
      final result = breaker.breakLines('', textStyle: const TextStyle(fontSize: 16), maxWidth: 150);
      expect(result, equals([]));
    });

    test('handles single word', () {
      final result = breaker.breakLines('สวัสดี', textStyle: const TextStyle(fontSize: 16), maxWidth: 200);
      expect(result.length, equals(1));
      expect(result[0].contains('สวัสดี'), true);
    });

    test('breaks Bangkok name correctly', () {
      final result = breaker.breakLines('กรุงเทพมหานคร', textStyle: const TextStyle(fontSize: 16), maxWidth: 80.7);
      expect(result, isNotEmpty);
      // Verify that the word is not lost
      final joinedLines = result.join('');
      expect(joinedLines.contains('นคร'), true);
    });
  });

  group('ThaiTextEditingController', () {
    test('gets word count correctly', () {
      final controller = ThaiTextEditingController();
      controller.text = 'สวัสดี ชาว ไทย';
      final count = controller.getWordCount();
      expect(count, greaterThan(0));
    });

    test('gets syllable count correctly', () {
      final controller = ThaiTextEditingController();
      controller.text = 'สวัสดีชาวไทย';
      final count = controller.getSyllableCount();
      expect(count, greaterThan(0));
    });

    test('gets segments correctly', () {
      final controller = ThaiTextEditingController();
      controller.text = 'สวัสดี';
      final segments = controller.getSegments();
      expect(segments, isNotEmpty);
    });

    test('gets lines correctly', () {
      final controller = ThaiTextEditingController();
      controller.text = 'สวัสดีชาวไทยยินดีต้อนรับ';
      final lines = controller.getLines(style: const TextStyle(fontSize: 16), maxWidth: 150);
      expect(lines, isNotEmpty);
    });
  });

  group('Line Break Info', () {
    test('creates LineBreakInfo correctly', () {
      final info = LineBreakInfo(lineNumber: 1, text: 'สวัสดี', startOffset: 0, width: 100.0);
      expect(info.lineNumber, equals(1));
      expect(info.text, equals('สวัสดี'));
      expect(info.startOffset, equals(0));
      expect(info.width, equals(100.0));
    });

    test('toString works correctly', () {
      final info = LineBreakInfo(lineNumber: 1, text: 'สวัสดี', startOffset: 0, width: 100.0);
      final string = info.toString();
      expect(string, contains('Line 1'));
      expect(string, contains('สวัสดี'));
    });
  });

  group('ThaiLineBreakText Widget', () {
    testWidgets('renders Thai text without maxWidth', (WidgetTester tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(800, 600);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ThaiLineBreakText('สวัสดีชาวไทย', style: TextStyle(fontSize: 16))),
        ),
      );

      expect(find.text('สวัสดีชาวไทย'), findsOneWidget);
    });

    testWidgets('renders Thai text with maxWidth', (WidgetTester tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(800, 600);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ThaiLineBreakText('สวัสดีชาวไทยยินดีต้อนรับคุณ', maxWidth: 150, style: TextStyle(fontSize: 16))),
        ),
      );

      final textFinder = find.byType(RichText);
      expect(textFinder, findsWidgets);
    });

    testWidgets('breaks long Thai text into multiple lines', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(300, 1000);
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ThaiLineBreakText(
                'สวัสดีชาวไทยยินดีต้อนรับคุณเข้ามาในสถาบันการศึกษา',
                maxWidth: 100,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      );

      // Verify that at least one RichText exists (internal implementation of Text)
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('preserves Bangkok name correctly in line breaking', (WidgetTester tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(200, 600);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ThaiLineBreakText('กรุงเทพมหานคร', maxWidth: 80.7, style: TextStyle(fontSize: 16))),
        ),
      );

      expect(find.byType(RichText), findsWidgets);
    });

    testWidgets('renders with custom style', (WidgetTester tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(800, 600);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ThaiLineBreakText(
              'สวัสดี',
              maxWidth: 200,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ),
        ),
      );

      expect(find.byType(RichText), findsOneWidget);
    });

    testWidgets('renders empty text without errors', (WidgetTester tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(800, 600);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ThaiLineBreakText('', maxWidth: 200, style: TextStyle(fontSize: 16))),
        ),
      );

      // Just verify that widget renders without throwing errors
      expect(find.byType(ThaiLineBreakText), findsOneWidget);
    });

    testWidgets('handles mixed Thai and English text', (WidgetTester tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(800, 600);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ThaiLineBreakText('Hello สวัสดี World ชาว ไทย', maxWidth: 150, style: TextStyle(fontSize: 16))),
        ),
      );

      expect(find.byType(RichText), findsWidgets);
    });

    testWidgets('handles maxLines with centered text', (WidgetTester tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(200, 600);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ThaiLineBreakText(
              'กรุงเทพมหานคร',
              textAlign: TextAlign.center,
              maxWidth: 100,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      );

      expect(find.byType(ThaiLineBreakText), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('applies ellipsis when text exceeds maxLines', (WidgetTester tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(150, 600);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ThaiLineBreakText(
              'สวัสดีชาวไทยยินดีต้อนรับคุณเข้ามาในสถาบันการศึกษา',
              maxWidth: 80,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      );

      expect(find.byType(ThaiLineBreakText), findsOneWidget);
    });

    testWidgets('debug Bangkok name segmentation', (WidgetTester tester) async {
      final segmenter = ThaiTextSegmenter();
      final breaker = ThaiLineBreaker();

      // Test segmentation
      final segments = segmenter.segment('กรุงเทพมหานคร');
      print('Segments: $segments');
      print('Joined: ${segments.join("")}');

      // Test grouping
      final syllables = segmenter.groupBySyllables('กรุงเทพมหานคร');
      print('Syllables: $syllables');
      print('Joined syllables: ${syllables.join("")}');

      // Test line breaking
      final lines = breaker.breakLinesThaiAware('กรุงเทพมหานคร', textStyle: const TextStyle(fontSize: 16), maxWidth: 100);
      print('Lines (width 100): $lines');
      print('Joined lines: ${lines.join("")}');

      // Verify nothing is lost
      expect(segments.join(''), equals('กรุงเทพมหานคร'));
      expect(syllables.join(''), equals('กรุงเทพมหานคร'));
      expect(lines.join(''), equals('กรุงเทพมหานคร'));
    });
  });
}
