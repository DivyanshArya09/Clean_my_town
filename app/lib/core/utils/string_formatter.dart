extension StringCapitalizer on String {
  String capitalizeFirstLetterOfEachWord() {
    if (isEmpty) {
      return this;
    }
    final List<String> words =
        split(RegExp(r'\s+')).where((word) => word.isNotEmpty).toList();

    final List<String> capitalizedWords = words.map((word) {
      final firstChar = word.substring(0, 1).toUpperCase();
      final remainingChars =
          word.substring(1).replaceAll(RegExp(r'\u00A0'), ' ');
      return firstChar + remainingChars;
    }).toList();

    return capitalizedWords.join(' ');
  }
}
