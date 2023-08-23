class Tools {
  static List<bool> setSelect(List<dynamic> elements, List<bool> selection) {
    /// To unselect [selection], pass empty boolean list value.
    final set = List<bool>.generate(elements.length, (i) => false);
    if (selection.isEmpty) selection = set;
    if (elements.length > selection.length) selection = set;

    return selection;
  }
}
