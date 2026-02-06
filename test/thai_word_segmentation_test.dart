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
}
