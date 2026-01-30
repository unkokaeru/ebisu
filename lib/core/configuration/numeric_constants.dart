import 'package:flutter/material.dart';

/// Numeric constants for the entire application.
/// All magic numbers should be defined here for easy adjustment.
class NumericConstants {
  NumericConstants._();

  // Experience Points
  static const int experiencePointsPerTodoBase = 10;
  static const double experienceMultiplierUrgentImportant = 2.0;
  static const double experienceMultiplierImportant = 1.5;
  static const double experienceMultiplierUrgent = 1.2;
  static const double experienceMultiplierDefault = 1.0;
  static const int experiencePointsPerRoutineItem = 5;
  static const double experienceMultiplierFullRoutine = 1.5;
  static const int experiencePointsOrganizationBase = 5;
  static const int experiencePointsBonusLevelTen = 50;

  // Leveling
  static const int levelingBaseExperience = 100;
  static const int levelingExponent = 2;

  // Streaks
  static const int streakBonusThreshold = 7;
  static const double streakBonusMultiplier = 1.25;

  // Organization / Skills
  static const int organizationMaxLevel = 10;
  static const int organizationMinLevel = 1;

  // Abilities
  static const int abilityCount = 6;
  static const int abilityStrength = 0;
  static const int abilityDexterity = 1;
  static const int abilityConstitution = 2;
  static const int abilityIntelligence = 3;
  static const int abilityWisdom = 4;
  static const int abilityCharisma = 5;

  /// Safely clamp an ability index to valid range (0-5).
  /// Handles invalid values from old database records.
  static int safeAbilityIndex(int index) {
    if (index < 0 || index >= abilityCount) return 0;
    return index;
  }

  // Todo Weights
  static const int todoWeightMin = 1;
  static const int todoWeightMax = 10;
  static const int todoWeightDefault = 5;

  // Quadrants
  static const int quadrantUrgentImportant = 1;
  static const int quadrantImportantNotUrgent = 2;
  static const int quadrantUrgentNotImportant = 3;
  static const int quadrantNotUrgentNotImportant = 4;

  // Animation Durations (milliseconds)
  static const int animationDurationFast = 150;
  static const int animationDurationMedium = 300;
  static const int animationDurationSlow = 500;
  static const int animationDurationWheelSpin = 3000;
  static const int animationDurationCelebration = 2000;

  // UI Dimensions
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusExtraLarge = 24.0;
  static const double borderRadiusCircular = 100.0;

  static const double paddingTiny = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingExtraLarge = 32.0;

  static const double iconSizeTiny = 12.0;
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeExtraLarge = 48.0;
  static const double iconSizeHuge = 64.0;

  static const double elevationNone = 0.0;
  static const double elevationLow = 1.0;
  static const double elevationMedium = 2.0;
  static const double elevationHigh = 4.0;

  // Picker Wheel
  static const double wheelDiameter = 300.0;
  static const double wheelSpinVelocity = 10.0;
  static const double wheelFriction = 0.97;
  static const int wheelMinSpins = 3;
  static const int wheelMaxSpins = 6;

  // Charts
  static const int chartHistoryDays = 7;
  static const int chartHistoryDaysExtended = 30;
  static const double chartBarWidth = 12.0;
  static const double chartLineWidth = 3.0;

  // Validation
  static const int nameMinLength = 2;
  static const int nameMaxLength = 20;
  static const int taskTitleMaxLength = 100;
  static const int routineItemMaxLength = 50;
  static const int categoryNameMaxLength = 30;
  static const int levelDescriptionMaxLength = 50;

  // Time Constants (hours)
  static const int morningStartHour = 5;
  static const int morningEndHour = 12;
  static const int eveningStartHour = 17;
  static const int eveningEndHour = 23;

  // Achievement Thresholds
  static const int achievementStreakWeek = 7;
  static const int achievementStreakMonth = 30;
  static const int achievementTasksForFocused = 5;
  static const int achievementTasksForCenturion = 100;
  static const int achievementLevelForLevelUp = 5;
  static const int achievementSkillLevelForSkillful = 5;

  // Progress Bar
  static const double progressBarHeight = 8.0;
  static const double progressBarHeightLarge = 12.0;

  // Card Dimensions
  static const double cardMinHeight = 80.0;
  static const double cardMaxWidth = 400.0;

  // Bottom Navigation
  static const int bottomNavigationItemCount = 5;
}
