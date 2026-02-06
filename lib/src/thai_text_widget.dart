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
      return _buildLineBreakText(context, maxWidth!);
    }

    // If maxWidth is not provided, use available width from parent
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use the constrained width, or a reasonable default if unconstrained
        final width = constraints.maxWidth.isFinite ? constraints.maxWidth : 300.0; // Default width if parent is unconstrained
        return _buildLineBreakText(context, width);
      },
    );
  }

  Widget _buildLineBreakText(BuildContext context, double width) {
    final breaker = ThaiLineBreaker();
    final textScaler = MediaQuery.textScalerOf(context);

    // Subtract a tiny margin to prevent edge clipping due to anti-aliasing
    final double effectiveWidth = width > 1.0 ? width - 0.2 : width;

    final lines = useThaiAwareBreaking
        ? breaker.breakLinesThaiAware(text, textStyle: style, maxWidth: effectiveWidth, textScaler: textScaler)
        : breaker.breakLines(text, textStyle: style, maxWidth: effectiveWidth, textScaler: textScaler);

    List<String> displayedLines = List.from(lines);

    if (maxLines != null && maxLines! > 0 && overflow == TextOverflow.ellipsis) {
      final displayCount = lines.length < maxLines! ? lines.length : maxLines!;
      displayedLines = lines.sublist(0, displayCount);

      if (lines.length > displayCount && displayedLines.isNotEmpty) {
        String lastLine = displayedLines[displayedLines.length - 1].trimRight();
        var chars = lastLine.characters;

        while (chars.isNotEmpty) {
          final painter = TextPainter(
            text: TextSpan(text: '${chars.toString()}…', style: style),
            textDirection: TextDirection.ltr,
            textScaler: textScaler,
          );
          painter.layout();
          if (painter.width <= effectiveWidth - 0.5 || chars.length <= 1) {
            break;
          }
          chars = chars.take(chars.length - 1);
        }
        displayedLines[displayedLines.length - 1] = '${chars.toString()}…';
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: _getCrossAxisAlignment(textAlign),
      children: [
        for (final line in displayedLines)
          Text(line, style: style, textAlign: textAlign, maxLines: 1, softWrap: false, overflow: TextOverflow.visible),
      ],
    );
  }

  CrossAxisAlignment _getCrossAxisAlignment(TextAlign alignment) {
    switch (alignment) {
      case TextAlign.right:
      case TextAlign.end:
        return CrossAxisAlignment.end;
      case TextAlign.center:
        return CrossAxisAlignment.center;
      default:
        return CrossAxisAlignment.start;
    }
  }
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
    final textScaler = MediaQuery.textScalerOf(context);

    final lines = breaker.breakLinesThaiAware(text, textStyle: defaultStyle, maxWidth: maxWidth, textScaler: textScaler);

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
    final textScaler = MediaQuery.textScalerOf(context);
    final fullText = spans.fold<String>('', (prev, span) => prev + span.text);

    if (!enableLineBreaking) {
      return RichText(
        textAlign: textAlign,
        text: TextSpan(
          children: [for (ThaiTextSpan span in spans) TextSpan(text: span.text, style: span.style)],
        ),
      );
    }

    final lines = breaker.breakLinesThaiAware(
      fullText,
      textStyle: _getDefaultStyle(),
      maxWidth: maxWidth,
      textScaler: textScaler,
    );

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
