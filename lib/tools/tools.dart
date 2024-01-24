import 'package:flutter/material.dart';

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

  static String nicePrice(double price) {
    try {
      final double fraction = (price % 1);
      final int fixed = fraction != 0 ? 2 : 0;
      final String nice = price.toStringAsFixed(fixed);
      final List<String> parts = nice.split('.');

      // Add commas for thousands separator
      parts.first = parts.first.replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]},');

      // Check if decimal part is zero
      if (parts.length > 1 && int.tryParse(parts[1]) == 0) {
        return parts.first; // No decimal part if it's zero
      } else {
        return parts.join('.'); // Include two decimal places
      }
    } catch (e) {
      debugPrint('Error formatting price: $e');
      return '';
    }
  }
}
