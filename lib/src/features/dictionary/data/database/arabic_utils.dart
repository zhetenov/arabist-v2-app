
const arabicLeters = 'ضصثقفغعهخحجشسبلتنمكظطذدزراأإآيىئوؤ';
const easyArabicLeters = 'ضصثقفغعهخحجشسبلتنمكظطذدزراااايىىوو';
bool isArabic(String word) {
  for (int i = 0; i < word.length; i++) {
    if (arabicLeters.contains(word[i])) {
      return true;
    }
  }
  return false;
}

String? getArabicLetters(String text) {
  return deleteNotAvailableLetters(arabicLeters, text);
}

String? deleteNotAvailableLetters(String availableLetters, String text) {
  final StringBuffer sb = StringBuffer();
  for (final ch in text.split('')) {
    if (availableLetters.contains(ch)) {
      sb.write(ch);
    }
  }
  return sb.toString().isEmpty ? null : sb.toString();
}

String? replaceArabicLettersToEasyArabicLetters(String? text) {
  if (text == null) {
    return null;
  }

  final StringBuffer sb = StringBuffer();
  for (final ch in text.split('')) {
    final int i = easyArabicLeters.indexOf(ch);
    if (i != -1) {
      final ch2 = easyArabicLeters[i];
      sb.write(ch2);
    }
  }
  return sb.toString();
}
