part of '../thai_word_segmentation.dart';

/// A widget that displays Thai text with custom line breaking
class ThaiLineBreakText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign textAlign;
  final double? maxWidth;
  final int? maxLines;
  final TextOverflow overflow;
  final bool useThaiAwareBreaking;

  const ThaiLineBreakText(
    this.text, {
    super.key,
    required this.style,
    this.textAlign = TextAlign.left,
    this.maxWidth,
    this.maxLines,
    this.overflow = TextOverflow.clip,
    this.useThaiAwareBreaking = true,
  });

  @override
  Widget build(BuildContext context) {
    if (maxWidth != null) {
      return _buildLineBreakText(maxWidth!);
    }

    // If maxWidth is not provided, use available width from parent
    return LayoutBuilder(
      builder: (context, constraints) {
        return _buildLineBreakText(constraints.maxWidth);
      },
    );
  }

  Widget _buildLineBreakText(double width) {
    final breaker = ThaiLineBreaker();
    final lines = useThaiAwareBreaking
        ? breaker.breakLinesThaiAware(text, textStyle: style, maxWidth: width)
        : breaker.breakLines(text, textStyle: style, maxWidth: width);

    int displayLines = lines.length;
    if (maxLines != null && maxLines! > 0) {
      displayLines = minLines(lines.length, maxLines!);
    }

    List<String> displayedLines = lines.sublist(0, displayLines);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < displayedLines.length; i++)
          Text(displayedLines[i], style: style, textAlign: textAlign, maxLines: 1, overflow: overflow),
      ],
    );
  }

  int minLines(int a, int b) => a < b ? a : b;
}

/// A widget that displays Thai text with custom styling based on words
class ThaiSegmentedText extends StatelessWidget {
  final String text;
  final TextStyle defaultStyle;
  final Map<String, TextStyle> wordStyles;
  final TextAlign textAlign;
  final double maxWidth;

  const ThaiSegmentedText(
    this.text, {
    super.key,
    required this.defaultStyle,
    this.wordStyles = const {},
    this.textAlign = TextAlign.left,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    // final segmenter = ThaiTextSegmenter();
    final breaker = ThaiLineBreaker();

    final lines = breaker.breakLinesThaiAware(text, textStyle: defaultStyle, maxWidth: maxWidth);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [for (String line in lines) _buildLineWithSegments(line, context)],
    );
  }

  Widget _buildLineWithSegments(String line, BuildContext context) {
    final segmenter = ThaiTextSegmenter();
    final words = segmenter.segment(line);

    return Wrap(
      alignment: WrapAlignment.start,
      textDirection: TextDirection.ltr,
      children: [
        for (String word in words)
          if (word.trim().isNotEmpty)
            Text(word, style: wordStyles[word] ?? defaultStyle, textAlign: textAlign)
          else if (word == ' ')
            const SizedBox(width: 4),
      ],
    );
  }
}

/// A widget that displays Thai text in a Rich format
class ThaiRichText extends StatelessWidget {
  final List<ThaiTextSpan> spans;
  final TextAlign textAlign;
  final double maxWidth;
  final bool enableLineBreaking;

  const ThaiRichText(
    this.spans, {
    super.key,
    this.textAlign = TextAlign.left,
    required this.maxWidth,
    this.enableLineBreaking = true,
  });

  @override
  Widget build(BuildContext context) {
    final breaker = ThaiLineBreaker();
    final fullText = spans.fold<String>('', (prev, span) => prev + span.text);

    if (!enableLineBreaking) {
      return RichText(
        textAlign: textAlign,
        text: TextSpan(
          children: [for (ThaiTextSpan span in spans) TextSpan(text: span.text, style: span.style)],
        ),
      );
    }

    final lines = breaker.breakLinesThaiAware(fullText, textStyle: _getDefaultStyle(), maxWidth: maxWidth);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [for (String line in lines) Text(line, style: _getDefaultStyle(), textAlign: textAlign)],
    );
  }

  TextStyle _getDefaultStyle() {
    if (spans.isEmpty) return const TextStyle();
    return spans.first.style ?? const TextStyle();
  }
}

/// A text span for use with ThaiRichText
class ThaiTextSpan {
  final String text;
  final TextStyle? style;

  ThaiTextSpan({required this.text, this.style});
}

/// A controller for Thai text that provides segmentation and breaking utilities
class ThaiTextEditingController extends TextEditingController {
  final ThaiTextSegmenter segmenter = ThaiTextSegmenter();
  final ThaiLineBreaker breaker = ThaiLineBreaker();

  /// Gets the segmented text
  List<String> getSegments() {
    return segmenter.segment(text);
  }

  /// Gets the broken lines for a given style and width
  List<String> getLines({required TextStyle style, required double maxWidth}) {
    return breaker.breakLines(text, textStyle: style, maxWidth: maxWidth);
  }

  /// Gets word count
  int getWordCount() {
    final segments = segmenter.segment(text);
    return segments.where((s) => s.trim().isNotEmpty && s != ' ').length;
  }

  /// Gets syllable count
  int getSyllableCount() {
    final syllables = segmenter.groupBySyllables(text);
    return syllables.length;
  }
}
