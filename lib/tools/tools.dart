class Tools {
  static List<bool> setSelect(List<dynamic> elements, List<bool> selection) {
    /// To unselect [selection], pass empty boolean list value.
    final set = List<bool>.generate(elements.length, (i) => false);
    if (selection.isEmpty) selection = set;
    if (elements.length > selection.length) selection = set;

    return selection;
  }

  static List<num> extractNumbers(String input) {
    List<num> numbers = [];
    RegExp regExp = RegExp(r'\d+(\.\d+)?'); // Match integers and decimals

    Iterable<Match> matches = regExp.allMatches(input);

    for (Match match in matches) {
      numbers.add(num.parse(match.group(0)!));
    }

    return numbers;
  }
}
