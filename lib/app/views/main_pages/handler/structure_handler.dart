import '/helper/helper.dart';

class StructureHandler {
  static DateTime? _currentBackPressTime;

  static Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (_currentBackPressTime == null ||
        now.difference(_currentBackPressTime!) > const Duration(seconds: 2)) {
      _currentBackPressTime = now;
      Helper.toast('Press back again to exit');

      return Future.value(false);
    }
    return Future.value(true);
  }
}
