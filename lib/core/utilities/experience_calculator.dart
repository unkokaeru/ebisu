import 'dart:math';
import 'package:ebisu/core/configuration/numeric_constants.dart';
import 'package:ebisu/core/configuration/string_constants.dart';

/// Utility class for experience point calculations.
class ExperienceCalculator {
  ExperienceCalculator._();

  /// Calculate the player level based on total experience points.
  static int calculateLevel(int experiencePoints) {
    if (experiencePoints <= 0) return 1;
    return (sqrt(experiencePoints / NumericConstants.levelingBaseExperience)).floor() + 1;
  }

  /// Calculate experience points required for a specific level.
  static int experiencePointsForLevel(int level) {
    if (level <= 1) return 0;
    return NumericConstants.levelingBaseExperience * (level - 1) * (level - 1);
  }

  /// Calculate experience points required for the next level.
  static int experiencePointsForNextLevel(int currentExperiencePoints) {
    final currentLevel = calculateLevel(currentExperiencePoints);
    return experiencePointsForLevel(currentLevel + 1);
  }

  /// Calculate progress percentage towards next level.
  static double levelProgressPercentage(int currentExperiencePoints) {
    final currentLevel = calculateLevel(currentExperiencePoints);
    final currentLevelExperience = experiencePointsForLevel(currentLevel);
    final nextLevelExperience = experiencePointsForLevel(currentLevel + 1);

    final experienceInCurrentLevel = currentExperiencePoints - currentLevelExperience;
    final experienceNeeded = nextLevelExperience - currentLevelExperience;

    if (experienceNeeded == 0) return 1.0;
    return (experienceInCurrentLevel / experienceNeeded).clamp(0.0, 1.0);
  }

  /// Calculate experience points for completing a todo.
  static int calculateTodoExperiencePoints(int quadrant, int weight, int currentStreak) {
    double multiplier;
    switch (quadrant) {
      case NumericConstants.quadrantUrgentImportant:
        multiplier = NumericConstants.experienceMultiplierUrgentImportant;
        break;
      case NumericConstants.quadrantImportantNotUrgent:
        multiplier = NumericConstants.experienceMultiplierImportant;
        break;
      case NumericConstants.quadrantUrgentNotImportant:
        multiplier = NumericConstants.experienceMultiplierUrgent;
        break;
      default:
        multiplier = NumericConstants.experienceMultiplierDefault;
    }

    double baseExperience = NumericConstants.experiencePointsPerTodoBase * multiplier;
    
    double weightBonus = 1.0 + ((weight - 1) / 10.0);
    baseExperience *= weightBonus;

    if (currentStreak >= NumericConstants.streakBonusThreshold) {
      baseExperience *= NumericConstants.streakBonusMultiplier;
    }

    return baseExperience.round();
  }

  /// Calculate experience points for completing a routine item.
  static int calculateRoutineItemExperiencePoints(bool isFullRoutineCompleted, int currentStreak) {
    double experience = NumericConstants.experiencePointsPerRoutineItem.toDouble();

    if (isFullRoutineCompleted) {
      experience *= NumericConstants.experienceMultiplierFullRoutine;
    }

    if (currentStreak >= NumericConstants.streakBonusThreshold) {
      experience *= NumericConstants.streakBonusMultiplier;
    }

    return experience.round();
  }

  /// Calculate experience points for organization level completion.
  static int calculateOrganizationExperiencePoints(int level, int currentStreak) {
    double experience = (NumericConstants.experiencePointsOrganizationBase * level).toDouble();

    if (level == NumericConstants.organizationMaxLevel) {
      experience += NumericConstants.experiencePointsBonusLevelTen;
    }

    if (currentStreak >= NumericConstants.streakBonusThreshold) {
      experience *= NumericConstants.streakBonusMultiplier;
    }

    return experience.round();
  }

  /// Get rank title based on player level.
  static String getRankTitle(int level) {
    if (level >= 50) return StringConstants.rankLegend;
    if (level >= 40) return StringConstants.rankGrandmaster;
    if (level >= 30) return StringConstants.rankMaster;
    if (level >= 20) return StringConstants.rankExpert;
    if (level >= 15) return StringConstants.rankAdept;
    if (level >= 10) return StringConstants.rankJourneyman;
    if (level >= 5) return StringConstants.rankApprentice;
    return StringConstants.rankNovice;
  }

  /// Alias for getRankTitle - get rank for a given level.
  static String getRankForLevel(int level) {
    return getRankTitle(level);
  }

  /// Alias for experiencePointsForNextLevel.
  static int experienceForNextLevel(int currentExperiencePoints) {
    final currentLevel = calculateLevel(currentExperiencePoints);
    final nextLevelExp = experiencePointsForLevel(currentLevel + 1);
    return nextLevelExp - currentExperiencePoints;
  }

  /// Calculate experience progress within current level.
  static int experienceProgressInCurrentLevel(int currentExperiencePoints) {
    final currentLevel = calculateLevel(currentExperiencePoints);
    final currentLevelExp = experiencePointsForLevel(currentLevel);
    return currentExperiencePoints - currentLevelExp;
  }

  /// Alias for experiencePointsForLevel.
  static int experienceRequiredForLevel(int level) {
    return experiencePointsForLevel(level);
  }
}
