part of '../thai_word_segmentation.dart';

/// Thai text segmenter for breaking text into words
class ThaiTextSegmenter {
  // Thai Unicode ranges
  static const int _thaiStart = 0x0E00;
  static const int _thaiEnd = 0x0E7F;

  // Thai character classes
  // static const List<int> _thaiVowels = [0x0E31, 0x0E34, 0x0E35, 0x0E36, 0x0E37, 0x0E47, 0x0E48, 0x0E49, 0x0E4A, 0x0E4B, 0x0E4C, 0x0E4D];
  // static const List<int> _thaiToneMarks = [0x0E48, 0x0E49, 0x0E4A, 0x0E4B, 0x0E4C];
  static const List<int> _thaiDiacritics = [
    0x0E31,
    0x0E34,
    0x0E35,
    0x0E36,
    0x0E37,
    0x0E47,
    0x0E48,
    0x0E49,
    0x0E4A,
    0x0E4B,
    0x0E4C,
    0x0E4D,
  ];

  // Thai consonants that can be word boundaries
  static const List<int> _thaiConsonants = [
    0x0E01,
    0x0E02,
    0x0E03,
    0x0E04,
    0x0E05,
    0x0E06,
    0x0E07,
    0x0E08,
    0x0E09,
    0x0E0A,
    0x0E0B,
    0x0E0C,
    0x0E0D,
    0x0E0E,
    0x0E0F,
    0x0E10,
    0x0E11,
    0x0E12,
    0x0E13,
    0x0E14,
    0x0E15,
    0x0E16,
    0x0E17,
    0x0E18,
    0x0E19,
    0x0E1A,
    0x0E1B,
    0x0E1C,
    0x0E1D,
    0x0E1E,
    0x0E1F,
    0x0E20,
    0x0E21,
    0x0E22,
    0x0E23,
    0x0E24,
    0x0E25,
    0x0E26,
    0x0E27,
    0x0E28,
    0x0E29,
    0x0E2A,
    0x0E2B,
    0x0E2C,
    0x0E2D,
    0x0E2E,
    0x0E2F,
  ];

  /// Checks if character is Thai character
  static bool isThaiCharacter(String char) {
    if (char.isEmpty) return false;
    int codeUnit = char.codeUnitAt(0);
    return codeUnit >= _thaiStart && codeUnit <= _thaiEnd;
  }

  /// Checks if character is Thai consonant
  static bool isThaiConsonant(String char) {
    if (char.isEmpty) return false;
    int codeUnit = char.codeUnitAt(0);
    return _thaiConsonants.contains(codeUnit);
  }

  /// Checks if character is Thai vowel or diacritic
  static bool isThaiDiacritic(String char) {
    if (char.isEmpty) return false;
    int codeUnit = char.codeUnitAt(0);
    return _thaiDiacritics.contains(codeUnit);
  }

  /// Segments Thai text into words
  /// Returns a list of words based on Thai syllable structure
  List<String> segment(String text) {
    if (text.isEmpty) return [];

    List<String> words = [];
    String currentWord = '';

    for (int i = 0; i < text.length; i++) {
      String char = text[i];
      // int codeUnit = char.codeUnitAt(0);

      // Handle Thai characters
      if (isThaiCharacter(char)) {
        if (isThaiConsonant(char)) {
          // Start of a new syllable
          if (currentWord.isNotEmpty) {
            words.add(currentWord);
          }
          currentWord = char;
        } else if (isThaiDiacritic(char)) {
          // Diacritics attach to consonants
          currentWord += char;
        } else {
          // Thai vowels
          currentWord += char;
        }
      } else if (char == ' ' || char == '\n' || char == '\t') {
        // Space or newline breaks words
        if (currentWord.isNotEmpty) {
          words.add(currentWord);
          currentWord = '';
        }
        // Keep space as a separate token for layout purposes
        words.add(char);
      } else {
        // Non-Thai characters (English, numbers, punctuation)
        if (currentWord.isNotEmpty && isThaiCharacter(currentWord[0])) {
          words.add(currentWord);
          currentWord = char;
        } else {
          currentWord += char;
        }

        // Check if next character is Thai
        if (i + 1 < text.length && isThaiCharacter(text[i + 1]) && !isThaiDiacritic(text[i + 1])) {
          if (currentWord.isNotEmpty) {
            words.add(currentWord);
            currentWord = '';
          }
        }
      }
    }

    if (currentWord.isNotEmpty) {
      words.add(currentWord);
    }

    return words;
  }

  /// Segments text while preserving spaces
  List<String> segmentWithSpaces(String text) {
    return segment(text);
  }

  /// Groups words into syllables based on Thai text rules
  List<String> groupBySyllables(String text) {
    List<String> words = segment(text);
    List<String> syllables = [];
    String currentSyllable = '';

    for (String word in words) {
      if (word == ' ' || word == '\n' || word == '\t') {
        if (currentSyllable.isNotEmpty) {
          syllables.add(currentSyllable);
          currentSyllable = '';
        }
        continue;
      }

      // Check if word is Thai
      if (word.isNotEmpty && isThaiCharacter(word[0])) {
        // If we have a current syllable, add it to list
        if (currentSyllable.isNotEmpty && !isThaiCharacter(currentSyllable[0])) {
          syllables.add(currentSyllable);
          currentSyllable = word;
        } else {
          currentSyllable += word;
        }
      } else {
        // Non-Thai word
        if (currentSyllable.isNotEmpty) {
          syllables.add(currentSyllable);
          currentSyllable = '';
        }
        currentSyllable += word;
      }
    }

    if (currentSyllable.isNotEmpty) {
      syllables.add(currentSyllable);
    }

    return syllables;
  }
}
