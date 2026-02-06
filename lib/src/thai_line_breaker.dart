part of '../thai_word_segmentation.dart';

/// Thai line breaker for wrapping text based on width constraints
class ThaiLineBreaker {
  final ThaiTextSegmenter _segmenter = ThaiTextSegmenter();

  /// Breaks text into lines based on maximum width and text style
  /// Returns a list of lines that fit within the specified width
  List<String> breakLines(String text, {required TextStyle textStyle, required double maxWidth}) {
    if (text.isEmpty) return [];

    final List<String> lines = [];
    final List<String> words = _segmenter.segment(text);

    String currentLine = '';
    double currentWidth = 0;

    for (String word in words) {
      // Skip empty words
      if (word.isEmpty) continue;

      // Handle explicit line breaks
      if (word == '\n') {
        if (currentLine.isNotEmpty) {
          lines.add(currentLine.trim());
        }
        currentLine = '';
        currentWidth = 0;
        continue;
      }

      // Calculate width of current word
      final wordPainter = TextPainter(
        text: TextSpan(text: word, style: textStyle),
        textDirection: TextDirection.ltr,
      );
      wordPainter.layout();

      final wordWidth = wordPainter.width;
      // final spaceWidth = word == ' '
      //     ? 0.0
      //     : 4.0; // Approximate space width

      // Check if word fits in current line
      if (currentLine.isEmpty) {
        currentLine = word;
        currentWidth = wordWidth;
      } else if (currentWidth + wordWidth <= maxWidth) {
        currentLine += word;
        currentWidth += wordWidth;
      } else {
        // Word doesn't fit, start a new line
        if (currentLine.isNotEmpty) {
          lines.add(currentLine);
        }
        currentLine = word;
        currentWidth = wordWidth;
      }
    }

    // Add last line
    if (currentLine.isNotEmpty) {
      lines.add(currentLine);
    }

    return lines;
  }

  /// Breaks text into lines with Thai-aware word breaking
  /// More sophisticated approach that considers Thai text characteristics
  List<String> breakLinesThaiAware(String text, {required TextStyle textStyle, required double maxWidth}) {
    if (text.isEmpty) return [];

    final List<String> lines = [];
    final List<String> syllables = _segmenter.groupBySyllables(text);

    String currentLine = '';
    double currentWidth = 0;

    for (String syllable in syllables) {
      if (syllable.isEmpty) continue;

      if (syllable.contains('\n')) {
        if (currentLine.isNotEmpty) {
          lines.add(currentLine);
        }
        currentLine = '';
        currentWidth = 0;
        continue;
      }

      final syllablePainter = TextPainter(
        text: TextSpan(text: syllable, style: textStyle),
        textDirection: TextDirection.ltr,
      );
      syllablePainter.layout();

      final syllableWidth = syllablePainter.width;

      if (currentLine.isEmpty) {
        currentLine = syllable;
        currentWidth = syllableWidth;
      } else if (currentWidth + syllableWidth <= maxWidth) {
        currentLine += syllable;
        currentWidth += syllableWidth;
      } else {
        if (currentLine.isNotEmpty) {
          lines.add(currentLine);
        }
        currentLine = syllable;
        currentWidth = syllableWidth;
      }
    }

    if (currentLine.isNotEmpty) {
      lines.add(currentLine);
    }

    return lines;
  }

  /// Breaks text and returns with line numbers and positions
  List<LineBreakInfo> breakLinesWithInfo(String text, {required TextStyle textStyle, required double maxWidth}) {
    final lines = breakLines(text, textStyle: textStyle, maxWidth: maxWidth);

    return List.generate(
      lines.length,
      (index) => LineBreakInfo(
        lineNumber: index + 1,
        text: lines[index],
        startOffset: _calculateOffset(text, lines, index),
        width: _calculateLineWidth(lines[index], textStyle),
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
  double _calculateLineWidth(String line, TextStyle textStyle) {
    final painter = TextPainter(
      text: TextSpan(text: line, style: textStyle),
      textDirection: TextDirection.ltr,
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
