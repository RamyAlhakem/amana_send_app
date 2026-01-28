import 'package:flutter/material.dart';
import 'package:amana_send/localization/app_localizations.dart';

extension ContextExtension on BuildContext {
  AppLocalizations get arb => AppLocalizations.of(this)!;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
}
