# Thai Word Segmentation & Line Breaking Plugin

A Flutter plugin for intelligent Thai text word segmentation and line breaking. This package provides utilities for properly handling Thai text layout in Flutter applications, including word segmentation, line breaking, and custom widgets.

## 📚 Documentation Languages

- **English**: [README.md](./README.md) (you are here)
- **Thai (ไทย)**: [USAGE_GUIDE_TH.md](./USAGE_GUIDE_TH.md) - คู่มือการใช้งานเชิงลึก
- **Thai Quick Start**: [QUICKSTART_TH.md](./QUICKSTART_TH.md) - เริ่มต้นใช้งานอย่างรวดเร็ว

## Features

- **Thai Text Segmentation**: Break Thai text into words/syllables respecting Thai language rules
- **Smart Line Breaking**: Automatically break Thai text into lines based on width constraints
- **Flutter Widgets**: Pre-built widgets for easy Thai text display
- **Text Controller**: Custom TextEditingController with Thai text utilities
- **Rich Text Support**: Support for mixed Thai and English text
- **Syllable Grouping**: Group Thai text by syllables for better text handling

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  thai_word_segmentation:
    path: ./
```

Then run:

```bash
flutter pub get
```

## Usage

### 1. Text Segmentation

```dart
import 'package:thai_word_segmentation/thai_word_segmentation.dart';

final segmenter = ThaiTextSegmenter();

// Segment text into words
List<String> words = segmenter.segment('สวัสดีชาวไทย');
// Result: ['สวัสดี', 'ชาวไทย']

// Group by syllables
List<String> syllables = segmenter.groupBySyllables('สวัสดีชาวไทย');
```

### 2. Line Breaking

```dart
final breaker = ThaiLineBreaker();

// Break into lines based on width
List<String> lines = breaker.breakLines(
  'สวัสดีชาวไทยยินดีต้อนรับ',
  textStyle: TextStyle(fontSize: 16),
  maxWidth: 200,
);

// Thai-aware breaking
List<String> lines = breaker.breakLinesThaiAware(
  'สวัสดีชาวไทย',
  textStyle: TextStyle(fontSize: 16),
  maxWidth: 150,
);

// Get detailed line information
List<LineBreakInfo> lineInfo = breaker.breakLinesWithInfo(
  'สวัสดีชาวไทย',
  textStyle: TextStyle(fontSize: 16),
  maxWidth: 200,
);
```

### 3. Using Widgets


#### ThaiLineBreakText
Thai text with automatic line breaking (maxWidth is optional):

```dart
// Option 1: Let it use parent width (simplest)
ThaiLineBreakText(
  'สวัสดีชาวไทยยินดีต้อนรับคุณ',
  style: TextStyle(fontSize: 16),
)

// Option 2: Specify custom maxWidth
ThaiLineBreakText(
  'สวัสดีชาวไทยยินดีต้อนรับคุณ',
  style: TextStyle(fontSize: 16),
  maxWidth: 300,
)
```

#### ThaiSegmentedText
Thai text with custom word styling:

```dart
ThaiSegmentedText(
  'สวัสดี ชาวไทย',
  defaultStyle: TextStyle(fontSize: 16),
  wordStyles: {
    'สวัสดี': TextStyle(fontSize: 16, color: Colors.red),
    'ชาวไทย': TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  },
  maxWidth: 300,
)
```

#### ThaiRichText
Rich text with Thai support:

```dart
ThaiRichText(
  [
    ThaiTextSpan(
      text: 'สวัสดี ',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
    ThaiTextSpan(
      text: 'ชาวไทย',
      style: TextStyle(fontSize: 16, color: Colors.blue),
    ),
  ],
  maxWidth: 300,
)
```

### 4. Custom Text Controller

```dart
final controller = ThaiTextEditingController();

TextField(
  controller: controller,
  onChanged: (text) {
    print('Word count: ${controller.getWordCount()}');
    print('Syllables: ${controller.getSyllableCount()}');
  },
)

// Get segments
List<String> segments = controller.getSegments();

// Get lines
List<String> lines = controller.getLines(
  style: TextStyle(fontSize: 16),
  maxWidth: 300,
);
```

## Thai Character Recognition

The plugin recognizes:
- **Thai Consonants**: All standard Thai consonants (ก-๏)
- **Thai Vowels**: Above, below, and tone marks
- **Diacritics**: Thai vowel marks and tone marks
- **Mixed Text**: Seamlessly handles English, numbers, and punctuation mixed with Thai

## Technical Details

### Unicode Ranges
- Thai characters: U+0E00 to U+0E7F
- Includes consonants, vowels, tone marks, and numerals

### Breaking Algorithm
1. Identifies Thai consonants as word boundaries
2. Attaches vowels and diacritics to consonants
3. Respects explicit spaces and newlines
4. Handles mixed Thai-English text

## API Reference

### ThaiTextSegmenter
- `List<String> segment(String text)` - Break text into words
- `List<String> groupBySyllables(String text)` - Group by syllables
- `bool isThaiCharacter(String char)` - Check if character is Thai
- `bool isThaiConsonant(String char)` - Check if character is Thai consonant
- `bool isThaiDiacritic(String char)` - Check if character is diacritic

### ThaiLineBreaker
- `List<String> breakLines()` - Break text into lines
- `List<String> breakLinesThaiAware()` - Thai-aware line breaking
- `List<LineBreakInfo> breakLinesWithInfo()` - Break with position info

### Widgets
- `ThaiLineBreakText` - Auto-breaking text widget
- `ThaiSegmentedText` - Custom-styled text widget
- `ThaiRichText` - Rich text widget
- `ThaiTextEditingController` - Custom controller

## Documentation

### English
- [Getting Started Guide](./USAGE_GUIDE.md)
- [Quick Reference](./USAGE_GUIDE.md#quick-start)
- [API Documentation](./README.md#api-reference)

### Thai (ไทย)
- [คู่มือการใช้งาน](./USAGE_GUIDE_TH.md) - คู่มือเชิงลึกสำหรับผู้ใช้ภาษาไทย
- [เริ่มต้นใช้งาน](./QUICKSTART_TH.md) - เริ่มต้นใช้งานอย่างรวดเร็ว (5 ตัวอย่าง)

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Author

Created for proper Thai text handling in Flutter applications.
