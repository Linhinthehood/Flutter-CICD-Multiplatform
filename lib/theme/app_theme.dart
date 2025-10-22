// lib/theme/app_theme.dart
import 'package:flutter/cupertino.dart';

class AppTheme {
  // Light Theme Colors
  static const Color lightPrimaryColor = CupertinoColors.systemBlue;
  static const Color lightBackgroundColor =
      CupertinoColors.systemGroupedBackground;
  static const Color lightSecondaryBackgroundColor =
      CupertinoColors.systemBackground;
  static const Color lightTextColor = CupertinoColors.label;
  static const Color lightSecondaryTextColor = CupertinoColors.secondaryLabel;
  static const Color lightTertiaryTextColor = CupertinoColors.tertiaryLabel;
  static const Color lightSeparatorColor = CupertinoColors.separator;
  static const Color lightBorderColor = CupertinoColors.systemGrey4;

  // Dark Theme Colors
  static const Color darkPrimaryColor = CupertinoColors.systemBlue;
  static const Color darkBackgroundColor = CupertinoColors.black;
  static const Color darkSecondaryBackgroundColor = CupertinoColors.systemGrey6;
  static const Color darkTextColor = CupertinoColors.white;
  static const Color darkSecondaryTextColor =
      CupertinoColors.secondarySystemFill;
  static const Color darkTertiaryTextColor = CupertinoColors.tertiarySystemFill;
  static const Color darkSeparatorColor = CupertinoColors.separator;
  static const Color darkBorderColor = CupertinoColors.systemGrey3;

  // Light Theme
  static CupertinoThemeData get lightTheme {
    return const CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: lightPrimaryColor,
      scaffoldBackgroundColor: lightBackgroundColor,
      barBackgroundColor: lightSecondaryBackgroundColor,
      textTheme: CupertinoTextThemeData(
        primaryColor: lightTextColor,
        textStyle: TextStyle(
          color: lightTextColor,
          fontSize: 17,
        ),
        actionTextStyle: TextStyle(
          color: lightPrimaryColor,
          fontSize: 17,
        ),
        tabLabelTextStyle: TextStyle(
          color: lightSecondaryTextColor,
          fontSize: 10,
        ),
        navTitleTextStyle: TextStyle(
          color: lightTextColor,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        navLargeTitleTextStyle: TextStyle(
          color: lightTextColor,
          fontSize: 34,
          fontWeight: FontWeight.w400,
        ),
        navActionTextStyle: TextStyle(
          color: lightPrimaryColor,
          fontSize: 17,
        ),
        pickerTextStyle: TextStyle(
          color: lightTextColor,
          fontSize: 21,
        ),
        dateTimePickerTextStyle: TextStyle(
          color: lightTextColor,
          fontSize: 21,
        ),
      ),
    );
  }

  // Dark Theme
  static CupertinoThemeData get darkTheme {
    return const CupertinoThemeData(
      brightness: Brightness.dark,
      primaryColor: darkPrimaryColor,
      scaffoldBackgroundColor: darkBackgroundColor,
      barBackgroundColor: darkSecondaryBackgroundColor,
      textTheme: CupertinoTextThemeData(
        primaryColor: darkTextColor,
        textStyle: TextStyle(
          color: darkTextColor,
          fontSize: 17,
        ),
        actionTextStyle: TextStyle(
          color: darkPrimaryColor,
          fontSize: 17,
        ),
        tabLabelTextStyle: TextStyle(
          color: darkSecondaryTextColor,
          fontSize: 10,
        ),
        navTitleTextStyle: TextStyle(
          color: darkTextColor,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        navLargeTitleTextStyle: TextStyle(
          color: darkTextColor,
          fontSize: 34,
          fontWeight: FontWeight.w400,
        ),
        navActionTextStyle: TextStyle(
          color: darkPrimaryColor,
          fontSize: 17,
        ),
        pickerTextStyle: TextStyle(
          color: darkTextColor,
          fontSize: 21,
        ),
        dateTimePickerTextStyle: TextStyle(
          color: darkTextColor,
          fontSize: 21,
        ),
      ),
    );
  }

  // Helper methods to get colors based on theme
  static Color getBackgroundColor(BuildContext context) {
    final brightness = CupertinoTheme.of(context).brightness;
    return brightness == Brightness.dark
        ? darkBackgroundColor
        : lightBackgroundColor;
  }

  static Color getSecondaryBackgroundColor(BuildContext context) {
    final brightness = CupertinoTheme.of(context).brightness;
    return brightness == Brightness.dark
        ? darkSecondaryBackgroundColor
        : lightSecondaryBackgroundColor;
  }

  static Color getTextColor(BuildContext context) {
    final brightness = CupertinoTheme.of(context).brightness;
    return brightness == Brightness.dark ? darkTextColor : lightTextColor;
  }

  static Color getSecondaryTextColor(BuildContext context) {
    final brightness = CupertinoTheme.of(context).brightness;
    return brightness == Brightness.dark
        ? darkSecondaryTextColor
        : lightSecondaryTextColor;
  }

  static Color getSeparatorColor(BuildContext context) {
    final brightness = CupertinoTheme.of(context).brightness;
    return brightness == Brightness.dark
        ? darkSeparatorColor
        : lightSeparatorColor;
  }

  static Color getBorderColor(BuildContext context) {
    final brightness = CupertinoTheme.of(context).brightness;
    return brightness == Brightness.dark ? darkBorderColor : lightBorderColor;
  }
}
