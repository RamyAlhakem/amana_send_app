import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/global/variables.dart';

import '/app/theme/colors/dark_colors.dart';
import '/app/theme/colors/light_colors.dart';
import '/services/lang_service.dart';
import 'colors/main_colors.dart';
import 'style/dark_text_style.dart';
import 'style/light_text_style.dart';

class Themes {
  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: LangService.isAR() ? 'almarai' : 'work_sans',
      textTheme: TextTheme(
        titleSmall: const TextStyle(color: DarkColors.hint, fontSize: 12),
        titleMedium: const TextStyle(color: MainColors.color2),
        labelLarge: DarkTextStyle.t2,
        labelMedium: DarkTextStyle.t1,
      ),
      scaffoldBackgroundColor: DarkColors.sec,
      dialogBackgroundColor: DarkColors.main,
      cardColor: DarkColors.main,
      canvasColor: DarkColors.third,
      primaryColor: DarkColors.main,
      bannerTheme:
          const MaterialBannerThemeData(dividerColor: Colors.transparent),
      badgeTheme: BadgeThemeData(
        backgroundColor: Colors.green,
        alignment: AlignmentDirectional.lerp(
          AlignmentDirectional.topEnd,
          AlignmentDirectional.bottomStart,
          5,
        ),
        largeSize: 22,
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: DarkColors.fillColor,
        errorStyle: const TextStyle(color: Colors.white),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: MainColors.color1,
          foregroundColor: Colors.white,
        ),
      ),
      buttonTheme: const ButtonThemeData(
        colorScheme: ColorScheme.dark(
          primary: MainColors.color1,
          secondary: DarkColors.third,
          surface: DarkColors.third,
        ),
        textTheme: ButtonTextTheme.primary,
        buttonColor: DarkColors.third,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: DarkColors.main,
        contentTextStyle: TextStyle(color: Colors.white),
      ),
      dividerColor: DarkColors.third,
      iconTheme: const IconThemeData(color: DarkColors.d1),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: DarkColors.sec,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Global.brightnessLight(),
          statusBarIconBrightness: Global.brightnessLight(),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: DarkColors.main,
        selectedIconTheme: IconThemeData(color: MainColors.color2),
        unselectedIconTheme: IconThemeData(color: LightColors.d3),
        selectedLabelStyle: TextStyle(
          color: MainColors.color2,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          color: LightColors.d3,
          fontSize: 12,
          fontWeight: FontWeight.w300,
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: MainColors.color1,
        secondary: MainColors.color2,
        surface: Color.fromARGB(94, 57, 58, 59),
      ),
      switchTheme: SwitchThemeData(
        thumbColor:
            WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return null;
          }
          if (states.contains(WidgetState.selected)) {
            return MainColors.color3;
          }
          return null;
        }),
        trackColor:
            WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return null;
          }
          if (states.contains(WidgetState.selected)) {
            return MainColors.color3;
          }
          return null;
        }),
      ),
      radioTheme: RadioThemeData(
        fillColor:
            WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return null;
          }
          if (states.contains(WidgetState.selected)) {
            return MainColors.color3;
          }
          return null;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor:
            WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return null;
          }
          if (states.contains(WidgetState.selected)) {
            return MainColors.color3;
          }
          return null;
        }),
      ),
    );
  }

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: LangService.isAR() ? 'almarai' : 'work_sans',
      textTheme: TextTheme(
        titleSmall: const TextStyle(color: LightColors.d3, fontSize: 12),
        titleMedium: const TextStyle(color: MainColors.color1),
        labelLarge: LightTextStyle.t2,
        labelMedium: LightTextStyle.t1,
      ),
      scaffoldBackgroundColor: LightColors.sec,
      dialogBackgroundColor: LightColors.main,
      cardColor: LightColors.main,
      canvasColor: LightColors.sec,
      dividerColor: LightColors.border,
      primaryColor: LightColors.main,
      bannerTheme:
          const MaterialBannerThemeData(dividerColor: Colors.transparent),
      badgeTheme: BadgeThemeData(
        backgroundColor: Colors.green,
        alignment: AlignmentDirectional.lerp(
          AlignmentDirectional.topEnd,
          AlignmentDirectional.bottomStart,
          5,
        ),
        largeSize: 22,
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      ),
      colorScheme: const ColorScheme.light(
        primary: MainColors.color1,
        secondary: MainColors.color2,
        surface: Color.fromARGB(94, 214, 217, 222),
      ),
      // inputDecorationTheme: const InputDecorationTheme(
      //   fillColor: LightColors.fillColor,
      // ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: MainColors.color1,
          foregroundColor: Colors.white,
        ),
      ),
      buttonTheme: const ButtonThemeData(
        colorScheme: ColorScheme.light(
          primary: MainColors.color1,
          secondary: LightColors.third,
          surface: LightColors.sec,
        ),
        textTheme: ButtonTextTheme.primary,
      ),
      iconTheme: const IconThemeData(color: LightColors.d1),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: LightColors.main,
        contentTextStyle: TextStyle(color: Colors.black),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: LightColors.sec,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Global.brightnessLight(),
          statusBarIconBrightness: Global.brightnessLight(),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: LightColors.main,
        selectedIconTheme: IconThemeData(color: MainColors.color3),
        unselectedIconTheme: IconThemeData(color: LightColors.d1),
        selectedLabelStyle: TextStyle(
          color: MainColors.color2,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          color: LightColors.d1,
          fontSize: 12,
          fontWeight: FontWeight.w300,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor:
            WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return null;
          }
          if (states.contains(WidgetState.selected)) {
            return MainColors.color3;
          }
          return null;
        }),
        trackColor:
            WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return null;
          }
          if (states.contains(WidgetState.selected)) {
            return MainColors.color3;
          }
          return null;
        }),
      ),
      radioTheme: RadioThemeData(
        fillColor:
            WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return null;
          }
          if (states.contains(WidgetState.selected)) {
            return MainColors.color3;
          }
          return null;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor:
            WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return null;
          }
          if (states.contains(WidgetState.selected)) {
            return MainColors.color3;
          }
          return null;
        }),
      ),
    );
  }
}
