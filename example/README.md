# Thai Word Segmentation & Line Breaking Examples

This example demonstrates the Thai Word Segmentation & Line Breaking Flutter plugin.

## Features Demonstrated

### 1. Text Segmentation
The plugin can break Thai text into individual words, respecting Thai language rules:
- Thai consonants are identified as word boundaries
- Vowels and tone marks attach to consonants
- Mixed Thai and English text is handled intelligently

### 2. Syllable Grouping
Text can be grouped by syllables for better understanding of Thai text structure:
- Groups consonants with their vowels and tone marks
- Preserves spaces and punctuation

### 3. Text Statistics
Get valuable information about Thai text:
- Character count
- Word count
- Syllable count

### 4. Line Breaking
Automatically break text into lines based on width constraints:
- Respects maximum width constraints
- Thai-aware breaking for better text flow
- Provides detailed line information (line number, position, width)

### 5. Custom Widgets
Use pre-built Flutter widgets for Thai text display:
- `ThaiLineBreakText` - Auto-breaking text widget
- `ThaiSegmentedText` - Custom-styled per-word
- `ThaiRichText` - Rich text support

## Code Examples

### Basic Segmentation
```dart
final segmenter = ThaiTextSegmenter();
List<String> words = segmenter.segment('สวัสดีชาวไทย');
// Result: ['สวัสดี', 'ชาวไทย']
```

### Line Breaking
```dart
final breaker = ThaiLineBreaker();
List<String> lines = breaker.breakLines(
  'สวัสดีชาวไทยยินดีต้อนรับ',
  textStyle: TextStyle(fontSize: 16),
  maxWidth: 200,
);
```

### Using Widgets
```dart
ThaiLineBreakText(
  'สวัสดีชาวไทยยินดีต้อนรับ',
  style: TextStyle(fontSize: 16),
  maxWidth: 300,
)
```

### Custom Controller
```dart
final controller = ThaiTextEditingController();
controller.text = 'สวัสดี';
print('Words: ${controller.getWordCount()}');
print('Syllables: ${controller.getSyllableCount()}');
```

## Running the Example

1. Navigate to the example directory:
```bash
cd example
```

2. Run the app:
```bash
flutter run
```

3. Try entering Thai text and see how it's segmented and broken into lines

## Thai Character Support

The plugin fully supports:
- Thai consonants (44 letters)
- Thai vowels (12 vowel positions)
- Tone marks (4 marks)
- Numbers and punctuation
- Mixed English/Thai text

## Tips for Best Results

1. **For optimal line breaking**: Use `breakLinesThaiAware()` for better Thai text flow
2. **For input validation**: Use `isThaiCharacter()` to check if text contains Thai
3. **For performance**: Cache segmentation results if text doesn't change frequently
4. **For UI**: Use the provided widgets for consistent Thai text display

## References

- Thai Unicode range: U+0E00 to U+0E7F
- Thai language structure: Consonant + Vowel combination
- Line breaking: Based on visual width constraints
