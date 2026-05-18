import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:yourpass/configs/app_colors.dart';

class AppTheme {
  // Light mode
  static final light = AppColors(
    text: HSLColor.fromAHSL(1.0, 220, 0.23, 0.05).toColor(),
    background: HSLColor.fromAHSL(1.0, 220, 0.26, 0.93).toColor(),
    primary: HSLColor.fromAHSL(1.0, 219, 0.29, 0.30).toColor(),
    secondary: HSLColor.fromAHSL(1.0, 219, 0.32, 0.66).toColor(),
    accent: HSLColor.fromAHSL(1.0, 219, 0.35, 0.43).toColor(),
  );

  // Dark mode
  static final dark = AppColors(
    text: HSLColor.fromAHSL(1.0, 220, 0.23, 0.95).toColor(),
    background: HSLColor.fromAHSL(1.0, 220, 0.26, 0.07).toColor(),
    primary: HSLColor.fromAHSL(1.0, 219, 0.29, 0.70).toColor(),
    secondary: HSLColor.fromAHSL(1.0, 219, 0.32, 0.34).toColor(),
    accent: HSLColor.fromAHSL(1.0, 219, 0.35, 0.57).toColor(),
  );
}

class AppThemeData {
  static ThemeData lightTheme = ThemeData(
    fontFamily: 'Sen',
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppTheme.light.background,
    primaryColor: AppTheme.light.accent,
    textTheme: TextTheme(bodyMedium: TextStyle(color: AppTheme.light.text)),
    colorScheme: ColorScheme.light(
      primary: AppTheme.light.primary,
      secondary: AppTheme.light.secondary,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: SharedAxisPageTransitionsBuilder(
          transitionType: SharedAxisTransitionType.horizontal,
        ),
        TargetPlatform.iOS: SharedAxisPageTransitionsBuilder(
          transitionType: SharedAxisTransitionType.horizontal,
        ),
        TargetPlatform.linux: SharedAxisPageTransitionsBuilder(
          transitionType: SharedAxisTransitionType.horizontal,
        ),
        TargetPlatform.macOS: SharedAxisPageTransitionsBuilder(
          transitionType: SharedAxisTransitionType.horizontal,
        ),
        TargetPlatform.windows: SharedAxisPageTransitionsBuilder(
          transitionType: SharedAxisTransitionType.horizontal,
        ),
      },
    ),
  );

  static ThemeData darkTheme = ThemeData(
    fontFamily: 'Sen',
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppTheme.dark.background,
    primaryColor: AppTheme.dark.accent,
    textTheme: TextTheme(bodyMedium: TextStyle(color: AppTheme.dark.text)),
    colorScheme: ColorScheme.dark(
      primary: AppTheme.dark.primary,
      secondary: AppTheme.dark.secondary,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: SharedAxisPageTransitionsBuilder(
          transitionType: SharedAxisTransitionType.horizontal,
        ),
        TargetPlatform.iOS: SharedAxisPageTransitionsBuilder(
          transitionType: SharedAxisTransitionType.horizontal,
        ),
        TargetPlatform.linux: SharedAxisPageTransitionsBuilder(
          transitionType: SharedAxisTransitionType.horizontal,
        ),
        TargetPlatform.macOS: SharedAxisPageTransitionsBuilder(
          transitionType: SharedAxisTransitionType.horizontal,
        ),
        TargetPlatform.windows: SharedAxisPageTransitionsBuilder(
          transitionType: SharedAxisTransitionType.horizontal,
        ),
      },
    ),
  );
}
