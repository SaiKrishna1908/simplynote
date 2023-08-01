import 'package:flutter/material.dart';

class AppColor {
  static bool darkTheme = true;
  // static const appPrimaryColor = Color(0xff2a2b46);
  // static const appSecondaryColor = Color(0xff1B262D);
  // static const appAccentColor = Color(0xffF4F4FB);

  static const appPrimaryColor = Color(0xffF4F4FB);
  static const appSecondaryColor = Color(0xff1B262D);
  static const appAccentColor = Color(0xff2a2b46);

  static final lightMode = ThemeData(
    primaryColor: appPrimaryColor,
    canvasColor: appAccentColor,
    buttonTheme: const ButtonThemeData(
      buttonColor: appSecondaryColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: appAccentColor,
      foregroundColor: appPrimaryColor,
      elevation: 0,
    ),
    textTheme: const TextTheme().apply(
      bodyColor: appAccentColor,
      displayColor: appAccentColor,
      decorationColor: appAccentColor,
    ),
    textSelectionTheme:
        TextSelectionThemeData(cursorColor: darken(AppColor.appPrimaryColor)),
    hintColor: lighten(appPrimaryColor, 0.5),
    fontFamily: 'Open-Sans',
  );

  static Color lighten(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }

  static Color darken(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }
}
