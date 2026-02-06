part of '../thai_word_segmentation.dart';

/// Thai text segmenter for breaking text into words
class ThaiTextSegmenter {
  // Thai Unicode ranges
  static const int _thaiStart = 0x0E00;
  static const int _thaiEnd = 0x0E7F;

  // Thai character classes
  // All Thai vowels and combining marks that should attach to consonants
  static const List<int> _thaiDiacritics = [
    // Tone marks
    0x0E48, // ่ (mai tho)
    0x0E49, // ้ (mai tri)
    0x0E4A, // ๊ (mai chattawa)
    0x0E4B, // ๋ (mai chattawa)
    // Vowel signs above
    0x0E31, // ํ (mai han akat)
    0x0E34, // ิ (sara i)
    0x0E35, // ี (sara ii)
    0x0E36, // ึ (sara ue)
    0x0E37, // ื (sara uee)
    // Vowel signs below
    0x0E38, // ุ (sara u)
    0x0E39, // ู (sara uu)
    // Other combining marks
    0x0E3A, // ฺ (phinthu)
    0x0E46, // ๖ (maiyamok)
    0x0E4C, // ์ (thanthakhat)
    0x0E4D, // ์ (nikhahit)
    // Vowel stems (can be standalone or with consonants)
    0x0E32, // า (sara aa)
    0x0E40, // เ (sara e)
    0x0E41, // แ (sara ae)
    0x0E42, // โ (sara o)
    0x0E43, // ไ (sara ai maimuan)
    0x0E44, // ใ (sara ai maimalai)
    0x0E45, // ๅ (lakkhangyao)
    0x0E47, // ๗ (yamakkan)
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

  /// Checks if character is Thai vowel stem (standalone vowel)
  static bool isThaiVowelStem(String char) {
    if (char.isEmpty) return false;
    int codeUnit = char.codeUnitAt(0);
    // Vowel stems that can appear before consonants
    return [0x0E32, 0x0E40, 0x0E41, 0x0E42, 0x0E43, 0x0E44, 0x0E45].contains(codeUnit);
  }

  /// Checks if character is Thai vowel or diacritic
  static bool isThaiDiacritic(String char) {
    if (char.isEmpty) return false;
    int codeUnit = char.codeUnitAt(0);
    return _thaiDiacritics.contains(codeUnit);
  }

  /// Segments Thai text into syllables/words using a more cohesive rule-based approach
  List<String> segment(String text) {
    if (text.isEmpty) return [];

    final List<String> result = [];
    final characters = text.characters;
    String current = '';

    for (int i = 0; i < characters.length; i++) {
      final String char = characters.elementAt(i);

      if (!isThaiCharacter(char)) {
        if (current.isNotEmpty && isThaiCharacter(current[0])) {
          result.add(current);
          current = '';
        }

        if (char == ' ' || char == '\n' || char == '\t') {
          if (current.isNotEmpty) result.add(current);
          result.add(char);
          current = '';
        } else {
          current += char;
        }
        continue;
      }

      // Thai logic
      if (current.isNotEmpty && !isThaiCharacter(current[0])) {
        result.add(current);
        current = '';
      }

      bool shouldBreak = false;
      if (current.isNotEmpty) {
        int charCode = char.codeUnitAt(0);
        bool isPreVowel = [0x0E40, 0x0E41, 0x0E42, 0x0E43, 0x0E44].contains(charCode);

        if (isPreVowel) {
          // Rule: Always break before a pre-vowel (starts a new syllable)
          shouldBreak = true;
        } else if (isThaiConsonant(char)) {
          // Check the state of the current segment
          bool hasConsonant = current.characters.any((c) => isThaiConsonant(c));
          bool hasVowelOrDiacritic = current.characters.any((c) => isThaiCharacter(c) && !isThaiConsonant(c));

          if (hasConsonant && hasVowelOrDiacritic) {
            // We already have a CV pattern.
            // Peek next character: if it's a following vowel/diacritic, then THIS consonant is a new start.
            bool nextIsFollowingVowel = false;
            if (i + 1 < characters.length) {
              final next = characters.elementAt(i + 1);
              if (isThaiCharacter(next) && !isThaiConsonant(next)) {
                int nextCode = next.codeUnitAt(0);
                bool nextIsPreVowel = [0x0E40, 0x0E41, 0x0E42, 0x0E43, 0x0E44].contains(nextCode);
                if (!nextIsPreVowel) {
                  nextIsFollowingVowel = true;
                }
              }
            }

            if (nextIsFollowingVowel) {
              shouldBreak = true;
            } else {
              // Look-ahead to see if next is another consonant.
              // If we already have a final consonant, we must break.
              // Simple: assume a syllable can have at most one final consonant.
              int cCount = current.characters.where((c) => isThaiConsonant(c)).length;
              if (cCount >= 2) {
                // Probably already has CVC or CCV.
                shouldBreak = true;
              } else {
                // CV + [C]. This C is likely a final consonant.
                shouldBreak = false;
              }
            }
          } else if (hasConsonant && !hasVowelOrDiacritic) {
            // Current has C but no vowel. Check for cluster (e.g., 'กร', 'ปล').
            int cCount = current.characters.where((c) => isThaiConsonant(c)).length;
            if (cCount >= 2) {
              // Try to avoid breaking mid-cluster if possible, but 2 is a safe limit for basic rules.
              shouldBreak = true;
            }
          }
        }
      }

      if (shouldBreak) {
        result.add(current);
        current = char;
      } else {
        current += char;
      }
    }

    if (current.isNotEmpty) {
      result.add(current);
    }
    return result;
  }

  /// Segments text while preserving spaces
  List<String> segmentWithSpaces(String text) {
    return segment(text);
  }

  /// Groups words into syllables based on Thai text rules
  List<String> groupBySyllables(String text) {
    // Current implementation of segment() is already quite granular (syllable level).
    // We just return the segments but ensure we don't over-glue Thai text.
    return segment(text);
  }
}
