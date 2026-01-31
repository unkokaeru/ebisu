import 'package:flutter/material.dart';
import 'package:ebisu/core/configuration/color_constants.dart';
import 'package:ebisu/core/configuration/numeric_constants.dart';

/// Application theme configuration with Material 3 and cozy aesthetics.
class ApplicationTheme {
  ApplicationTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: ColorConstants.primaryLight,
        onPrimary: Colors.white,
        secondary: ColorConstants.secondaryLight,
        onSecondary: Colors.white,
        tertiary: ColorConstants.tertiaryLight,
        onTertiary: Colors.white,
        error: ColorConstants.errorLight,
        onError: Colors.white,
        surface: ColorConstants.surfaceLight,
        onSurface: ColorConstants.textPrimaryLight,
        outline: ColorConstants.outlineLight,
      ),
      scaffoldBackgroundColor: ColorConstants.backgroundLight,
      cardTheme: CardTheme(
        color: ColorConstants.cardLight,
        elevation: NumericConstants.elevationLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NumericConstants.borderRadiusMedium),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: ColorConstants.backgroundLight,
        foregroundColor: ColorConstants.textPrimaryLight,
        elevation: NumericConstants.elevationNone,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: ColorConstants.textPrimaryLight,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: ColorConstants.surfaceLight,
        selectedItemColor: ColorConstants.primaryLight,
        unselectedItemColor: ColorConstants.textSecondaryLight,
        type: BottomNavigationBarType.fixed,
        elevation: NumericConstants.elevationMedium,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: ColorConstants.surfaceLight,
        indicatorColor: ColorConstants.primaryLight.withOpacity(0.2),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: ColorConstants.primaryLight);
          }
          return const IconThemeData(color: ColorConstants.textSecondaryLight);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: ColorConstants.primaryLight,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            );
          }
          return const TextStyle(
            color: ColorConstants.textSecondaryLight,
            fontSize: 12,
          );
        }),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: ColorConstants.primaryLight,
        foregroundColor: Colors.white,
        elevation: NumericConstants.elevationMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NumericConstants.borderRadiusLarge),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstants.primaryLight,
          foregroundColor: Colors.white,
          elevation: NumericConstants.elevationLow,
          padding: const EdgeInsets.symmetric(
            horizontal: NumericConstants.paddingLarge,
            vertical: NumericConstants.paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(NumericConstants.borderRadiusMedium),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ColorConstants.primaryLight,
          side: const BorderSide(color: ColorConstants.primaryLight),
          padding: const EdgeInsets.symmetric(
            horizontal: NumericConstants.paddingLarge,
            vertical: NumericConstants.paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(NumericConstants.borderRadiusMedium),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ColorConstants.primaryLight,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ColorConstants.cardLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(NumericConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: ColorConstants.outlineLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(NumericConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: ColorConstants.outlineLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(NumericConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: ColorConstants.primaryLight, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(NumericConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: ColorConstants.errorLight),
        ),
        contentPadding: const EdgeInsets.all(NumericConstants.paddingMedium),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ColorConstants.primaryLight;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NumericConstants.borderRadiusSmall),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: ColorConstants.surfaceLight,
        selectedColor: ColorConstants.primaryLight.withOpacity(0.2),
        labelStyle: const TextStyle(color: ColorConstants.textPrimaryLight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NumericConstants.borderRadiusSmall),
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: ColorConstants.cardLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NumericConstants.borderRadiusLarge),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: ColorConstants.textPrimaryLight,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NumericConstants.borderRadiusSmall),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: ColorConstants.primaryLight,
        linearTrackColor: ColorConstants.outlineLight,
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: ColorConstants.primaryLight,
        thumbColor: ColorConstants.primaryLight,
        inactiveTrackColor: ColorConstants.outlineLight,
      ),
      dividerTheme: const DividerThemeData(
        color: ColorConstants.outlineLight,
        thickness: 1,
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: NumericConstants.paddingMedium,
          vertical: NumericConstants.paddingSmall,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NumericConstants.borderRadiusMedium),
        ),
      ),
      textTheme: _buildTextTheme(ColorConstants.textPrimaryLight, ColorConstants.textSecondaryLight),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: ColorConstants.primaryDark,
        onPrimary: ColorConstants.textPrimaryLight,
        secondary: ColorConstants.secondaryDark,
        onSecondary: ColorConstants.textPrimaryLight,
        tertiary: ColorConstants.tertiaryDark,
        onTertiary: ColorConstants.textPrimaryLight,
        error: ColorConstants.errorDark,
        onError: ColorConstants.textPrimaryLight,
        surface: ColorConstants.surfaceDark,
        onSurface: ColorConstants.textPrimaryDark,
        outline: ColorConstants.outlineDark,
      ),
      scaffoldBackgroundColor: ColorConstants.backgroundDark,
      cardTheme: CardTheme(
        color: ColorConstants.cardDark,
        elevation: NumericConstants.elevationLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NumericConstants.borderRadiusMedium),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: ColorConstants.backgroundDark,
        foregroundColor: ColorConstants.textPrimaryDark,
        elevation: NumericConstants.elevationNone,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: ColorConstants.textPrimaryDark,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: ColorConstants.surfaceDark,
        selectedItemColor: ColorConstants.primaryDark,
        unselectedItemColor: ColorConstants.textSecondaryDark,
        type: BottomNavigationBarType.fixed,
        elevation: NumericConstants.elevationMedium,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: ColorConstants.surfaceDark,
        indicatorColor: ColorConstants.primaryDark.withOpacity(0.2),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: ColorConstants.primaryDark);
          }
          return const IconThemeData(color: ColorConstants.textSecondaryDark);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: ColorConstants.primaryDark,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            );
          }
          return const TextStyle(
            color: ColorConstants.textSecondaryDark,
            fontSize: 12,
          );
        }),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: ColorConstants.primaryDark,
        foregroundColor: ColorConstants.textPrimaryLight,
        elevation: NumericConstants.elevationMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NumericConstants.borderRadiusLarge),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstants.primaryDark,
          foregroundColor: ColorConstants.textPrimaryLight,
          elevation: NumericConstants.elevationLow,
          padding: const EdgeInsets.symmetric(
            horizontal: NumericConstants.paddingLarge,
            vertical: NumericConstants.paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(NumericConstants.borderRadiusMedium),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ColorConstants.primaryDark,
          side: const BorderSide(color: ColorConstants.primaryDark),
          padding: const EdgeInsets.symmetric(
            horizontal: NumericConstants.paddingLarge,
            vertical: NumericConstants.paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(NumericConstants.borderRadiusMedium),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ColorConstants.primaryDark,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ColorConstants.cardDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(NumericConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: ColorConstants.outlineDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(NumericConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: ColorConstants.outlineDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(NumericConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: ColorConstants.primaryDark, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(NumericConstants.borderRadiusMedium),
          borderSide: const BorderSide(color: ColorConstants.errorDark),
        ),
        contentPadding: const EdgeInsets.all(NumericConstants.paddingMedium),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ColorConstants.primaryDark;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(ColorConstants.textPrimaryLight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NumericConstants.borderRadiusSmall),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: ColorConstants.surfaceDark,
        selectedColor: ColorConstants.primaryDark.withOpacity(0.2),
        labelStyle: const TextStyle(color: ColorConstants.textPrimaryDark),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NumericConstants.borderRadiusSmall),
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: ColorConstants.cardDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NumericConstants.borderRadiusLarge),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: ColorConstants.textPrimaryDark,
        contentTextStyle: const TextStyle(color: ColorConstants.textPrimaryLight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NumericConstants.borderRadiusSmall),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: ColorConstants.primaryDark,
        linearTrackColor: ColorConstants.outlineDark,
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: ColorConstants.primaryDark,
        thumbColor: ColorConstants.primaryDark,
        inactiveTrackColor: ColorConstants.outlineDark,
      ),
      dividerTheme: const DividerThemeData(
        color: ColorConstants.outlineDark,
        thickness: 1,
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: NumericConstants.paddingMedium,
          vertical: NumericConstants.paddingSmall,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NumericConstants.borderRadiusMedium),
        ),
      ),
      textTheme: _buildTextTheme(ColorConstants.textPrimaryDark, ColorConstants.textSecondaryDark),
    );
  }

  static TextTheme _buildTextTheme(Color primaryColor, Color secondaryColor) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: primaryColor,
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: primaryColor,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: primaryColor,
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: primaryColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: primaryColor,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: secondaryColor,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: secondaryColor,
      ),
    );
  }
}
