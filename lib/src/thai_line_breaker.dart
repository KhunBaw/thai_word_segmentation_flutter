part of '../thai_word_segmentation.dart';

/// Thai line breaker for wrapping text based on width constraints
class ThaiLineBreaker {
  final ThaiTextSegmenter _segmenter = ThaiTextSegmenter();

  /// Breaks text into lines based on maximum width and text style
  /// Returns a list of lines that fit within the specified width
  List<String> breakLines(
    String text, {
    required TextStyle textStyle,
    required double maxWidth,
    TextScaler textScaler = TextScaler.noScaling,
  }) {
    if (text.isEmpty) return [];

    final List<String> lines = [];
    final List<String> words = _segmenter.segment(text);

    String currentLine = '';

    for (String word in words) {
      if (word.isEmpty) continue;

      if (word == '\n') {
        lines.add(currentLine);
        currentLine = '';
        continue;
      }

      String testLine = currentLine.isEmpty ? word : currentLine + word;

      final painter = TextPainter(
        text: TextSpan(text: testLine, style: textStyle),
        textDirection: TextDirection.ltr,
        textScaler: textScaler,
      );
      painter.layout();

      if (currentLine.isEmpty) {
        currentLine = word;
      } else if (painter.width <= maxWidth + 0.05) {
        // Tiny epsilon for floating point
        currentLine = testLine;
      } else {
        lines.add(currentLine);
        currentLine = word;
      }
    }

    if (currentLine.isNotEmpty) {
      lines.add(currentLine);
    }

    return lines;
  }

  /// Breaks text into lines with Thai-aware word breaking
  /// More sophisticated approach that considers Thai text characteristics
  List<String> breakLinesThaiAware(
    String text, {
    required TextStyle textStyle,
    required double maxWidth,
    TextScaler textScaler = TextScaler.noScaling,
  }) {
    if (text.isEmpty) return [];

    final List<String> lines = [];
    final List<String> syllables = _segmenter.groupBySyllables(text);

    String currentLine = '';

    for (String syllable in syllables) {
      if (syllable.isEmpty) continue;

      if (syllable == '\n') {
        lines.add(currentLine);
        currentLine = '';
        continue;
      }

      String testLine = currentLine.isEmpty ? syllable : currentLine + syllable;

      final painter = TextPainter(
        text: TextSpan(text: testLine, style: textStyle),
        textDirection: TextDirection.ltr,
        textScaler: textScaler,
      );
      painter.layout();

      if (currentLine.isEmpty) {
        currentLine = syllable;
      } else if (painter.width <= maxWidth + 0.05) {
        currentLine = testLine;
      } else {
        lines.add(currentLine);
        currentLine = syllable;
      }
    }

    if (currentLine.isNotEmpty) {
      lines.add(currentLine);
    }

    return lines;
  }

  /// Breaks text and returns with line numbers and positions
  List<LineBreakInfo> breakLinesWithInfo(
    String text, {
    required TextStyle textStyle,
    required double maxWidth,
    TextScaler textScaler = TextScaler.noScaling,
  }) {
    final lines = breakLines(text, textStyle: textStyle, maxWidth: maxWidth, textScaler: textScaler);

    return List.generate(
      lines.length,
      (index) => LineBreakInfo(
        lineNumber: index + 1,
        text: lines[index],
        startOffset: _calculateOffset(text, lines, index),
        width: _calculateLineWidth(lines[index], textStyle, textScaler),
      ),
    );
  }

  /// Calculates the starting offset of a line in the original text
  int _calculateOffset(String text, List<String> lines, int lineIndex) {
    int offset = 0;
    for (int i = 0; i < lineIndex && i < lines.length; i++) {
      offset += lines[i].length;
    }
    return offset;
  }

  /// Calculates the width of a line in pixels
  double _calculateLineWidth(String line, TextStyle textStyle, TextScaler textScaler) {
    final painter = TextPainter(
      text: TextSpan(text: line, style: textStyle),
      textDirection: TextDirection.ltr,
      textScaler: textScaler,
    );
    painter.layout();
    return painter.width;
  }
}

/// Information about a broken line
class LineBreakInfo {
  final int lineNumber;
  final String text;
  final int startOffset;
  final double width;

  LineBreakInfo({required this.lineNumber, required this.text, required this.startOffset, required this.width});

  @override
  String toString() => 'Line $lineNumber: "$text" (width: ${width.toStringAsFixed(2)}px, offset: $startOffset)';
}
