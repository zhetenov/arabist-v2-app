bool isArabic(String input) {
  final regex = RegExp(r'[\u0600-\u06FF]');
  return regex.hasMatch(input);
}

String? getArabicLetters(String text) {
  if (text.isEmpty) return null;
  return text.replaceAll(RegExp('[ًٌٍَُِّْـ]'), '');
}

String? replaceArabicLettersToEasyArabicLetters(String? text) {
  if (text == null) return null;
  return text
      .replaceAll('أ', 'ا')
      .replaceAll('إ', 'ا')
      .replaceAll('آ', 'ا')
      .replaceAll('ى', 'ي')
      .replaceAll('ة', 'ه')
      .replaceAll('ؤ', 'و')
      .replaceAll('ئ', 'ي');
}
