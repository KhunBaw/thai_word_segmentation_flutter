# Thai Word Segmentation Plugin - Quick Usage Guide

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  thai_word_segmentation:
    path: ./thai_word_segmentation
```

## Quick Start

### Import the Package
```dart
import 'package:thai_word_segmentation/thai_word_segmentation.dart';
```

## Core Classes

### 1. ThaiTextSegmenter
Breaks text into words and syllables.

```dart
final segmenter = ThaiTextSegmenter();

// Segment text into words
List<String> words = segmenter.segment('สวัสดีชาวไทย');

// Group by syllables
List<String> syllables = segmenter.groupBySyllables('สวัสดีชาวไทย');

// Check character type
bool isThai = ThaiTextSegmenter.isThaiCharacter('ก');
bool isConsonant = ThaiTextSegmenter.isThaiConsonant('ค');
bool isDiacritic = ThaiTextSegmenter.isThaiDiacritic('่');
```

### 2. ThaiLineBreaker
Breaks text into lines based on width constraints.

```dart
final breaker = ThaiLineBreaker();

// Basic line breaking
List<String> lines = breaker.breakLines(
  'สวัสดีชาวไทยยินดีต้อนรับ',
  textStyle: TextStyle(fontSize: 16),
  maxWidth: 200,
);

// Thai-aware breaking (recommended)
List<String> lines = breaker.breakLinesThaiAware(
  'สวัสดีชาวไทยยินดีต้อนรับ',
  textStyle: TextStyle(fontSize: 16),
  maxWidth: 200,
);

// Get detailed information
List<LineBreakInfo> info = breaker.breakLinesWithInfo(
  'สวัสดีชาวไทยยินดีต้อนรับ',
  textStyle: TextStyle(fontSize: 16),
  maxWidth: 200,
);
```

## Flutter Widgets

### 1. ThaiLineBreakText
Automatically breaks Thai text into lines (maxWidth is optional).

```dart
// Option 1: Without maxWidth (uses parent width)
ThaiLineBreakText(
  'สวัสดีชาวไทยยินดีต้อนรับคุณเข้ามาในประเทศไทย',
  style: TextStyle(fontSize: 16),
)

// Option 2: With custom maxWidth
ThaiLineBreakText(
  'สวัสดีชาวไทยยินดีต้อนรับคุณเข้ามาในประเทศไทย',
  style: TextStyle(fontSize: 16),
  maxWidth: 300,
  maxLines: 3,
  useThaiAwareBreaking: true,
)
```

### 2. ThaiSegmentedText
Allows custom styling per word/segment.

```dart
ThaiSegmentedText(
  'สวัสดี ชาวไทย',
  defaultStyle: TextStyle(fontSize: 16),
  wordStyles: {
    'สวัสดี': TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
    'ชาวไทย': TextStyle(fontSize: 16, color: Colors.blue),
  },
  maxWidth: 300,
)
```

### 3. ThaiRichText
Rich text with Thai support.

```dart
ThaiRichText(
  [
    ThaiTextSpan(
      text: 'สวัสดี ',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
    ),
    ThaiTextSpan(
      text: 'ชาวไทย',
      style: TextStyle(fontSize: 16, color: Colors.blue),
    ),
  ],
  maxWidth: 300,
  enableLineBreaking: true,
)
```

## Custom Text Controller

Extend TextEditingController with Thai utilities.

```dart
final controller = ThaiTextEditingController();

TextField(
  controller: controller,
  onChanged: (text) {
    // Get segmented words
    List<String> segments = controller.getSegments();
    
    // Get word count
    int words = controller.getWordCount();
    
    // Get syllable count
    int syllables = controller.getSyllableCount();
    
    // Get broken lines
    List<String> lines = controller.getLines(
      style: TextStyle(fontSize: 16),
      maxWidth: 300,
    );
  },
)
```

## Common Use Cases

### Case 1: Display Thai Text with Automatic Line Breaking
```dart
ThaiLineBreakText(
  thaiText,
  style: const TextStyle(fontSize: 16),
  maxWidth: MediaQuery.of(context).size.width - 32,
)
```

### Case 2: Build a Text Input with Character Count
```dart
final controller = ThaiTextEditingController();

TextField(
  controller: controller,
  onChanged: (_) => setState(() {}),
)

Text('Characters: ${controller.text.length}')
Text('Words: ${controller.getWordCount()}')
Text('Syllables: ${controller.getSyllableCount()}')
```

### Case 3: Highlight Thai Words in Text
```dart
ThaiSegmentedText(
  text,
  defaultStyle: const TextStyle(fontSize: 14),
  wordStyles: {
    'สวัสดี': const TextStyle(fontSize: 14, color: Colors.red),
    'ยินดี': const TextStyle(fontSize: 14, color: Colors.blue),
  },
  maxWidth: 300,
)
```

### Case 4: Process Thai Text Programmatically
```dart
final segmenter = ThaiTextSegmenter();
final words = segmenter.segment('สวัสดีชาวไทย');

for (String word in words) {
  print('Word: $word');
  // Process each word
}
```

## Performance Tips

1. **Cache Segmentation Results**: If you're segmenting the same text multiple times, cache the results.
   ```dart
   final cachedWords = segmenter.segment(text);
   // Reuse cachedWords instead of calling segment() again
   ```

2. **Use Thai-Aware Breaking**: For better results with Thai text:
   ```dart
   // Prefer this
   breaker.breakLinesThaiAware(text, ...)
   // Over this
   breaker.breakLines(text, ...)
   ```

3. **Measure Width Carefully**: Ensure you're providing accurate `maxWidth` values:
   ```dart
   double maxWidth = MediaQuery.of(context).size.width - (16 * 2); // Account for padding
   ```

## Troubleshooting

### Text Not Segmenting Correctly
- Ensure your text is valid Thai Unicode (U+0E00 to U+0E7F)
- Check that tone marks and vowels are correctly attached to consonants

### Line Breaking Issues
- Verify the `maxWidth` is set correctly
- Use `breakLinesThaiAware()` for better Thai text handling
- Check your TextStyle (font size affects width)

### Mixed Script Issues
- The plugin handles English + Thai automatically
- Ensure fonts support both scripts

## Thai Character Ranges

| Element | Unicode Range |
|---------|---------------|
| Thai Characters | U+0E00 to U+0E7F |
| Consonants | 44 characters |
| Vowels | 12 vowel positions |
| Tone Marks | 4 marks |
| Thai Numerals | 10 digits |

## More Examples

See the `example/` folder for a complete Flutter app demonstrating all features.

## API Reference

[See README.md for detailed API documentation](./README.md)

## Contributing

Contributions are welcome! Please submit issues and pull requests.

## License

MIT License - See LICENSE file for details.
