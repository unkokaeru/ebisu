import 'package:flutter/material.dart';

/// Color constants for the entire application.
/// All colors should be defined here for easy theming.
class ColorConstants {
  ColorConstants._();

  // Primary Colors - Warm Terracotta
  static const Color primaryLight = Color(0xFFC27B5C);
  static const Color primaryDark = Color(0xFFE8A87C);

  // Secondary Colors - Sage Green
  static const Color secondaryLight = Color(0xFF85A98F);
  static const Color secondaryDark = Color(0xFF9CAF88);

  // Surface Colors
  static const Color surfaceLight = Color(0xFFFFF8F0);
  static const Color surfaceDark = Color(0xFF2D2A26);

  // Background Colors
  static const Color backgroundLight = Color(0xFFFFFAF5);
  static const Color backgroundDark = Color(0xFF1E1B18);

  // Accent Colors
  static const Color accentLight = Color(0xFFD4A5A5);
  static const Color accentDark = Color(0xFFD4A574);

  // Tertiary Colors - Dusty Blue
  static const Color tertiaryLight = Color(0xFF7BA3A8);
  static const Color tertiaryDark = Color(0xFF8FBFC4);

  // Error Colors
  static const Color errorLight = Color(0xFFB85C5C);
  static const Color errorDark = Color(0xFFE88787);

  // Success Colors
  static const Color successLight = Color(0xFF5C8B5C);
  static const Color successDark = Color(0xFF87C487);

  // Warning Colors
  static const Color warningLight = Color(0xFFD4A55C);
  static const Color warningDark = Color(0xFFE8C87C);

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF2D2A26);
  static const Color textPrimaryDark = Color(0xFFFFF8F0);
  static const Color textSecondaryLight = Color(0xFF5C5652);
  static const Color textSecondaryDark = Color(0xFFB8B0A8);

  // Outline Colors
  static const Color outlineLight = Color(0xFFD4CCC4);
  static const Color outlineDark = Color(0xFF4A4540);

  // Card Colors
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF353230);

  // Quadrant Colors (Eisenhower Matrix)
  static const Color quadrantUrgentImportant = Color(0xFFE87C7C);
  static const Color quadrantImportantNotUrgent = Color(0xFF7CB8E8);
  static const Color quadrantUrgentNotImportant = Color(0xFFE8D47C);
  static const Color quadrantNotUrgentNotImportant = Color(0xFFA8A8A8);

  // Ability Colors (6 core stats)
  static const List<Color> abilityColors = [
    Color(0xFFE87C7C), // Strength - Red
    Color(0xFF87C487), // Dexterity - Green
    Color(0xFFE8A87C), // Constitution - Orange
    Color(0xFF7CB8E8), // Intelligence - Blue
    Color(0xFF8787E8), // Wisdom - Purple
    Color(0xFFD487C4), // Charisma - Pink
  ];

  // Skill/Category Colors (for user selection)
  static const List<Color> categoryColors = [
    Color(0xFFE88787), // Coral
    Color(0xFFE8A87C), // Peach
    Color(0xFFE8D47C), // Butter
    Color(0xFF87C487), // Mint
    Color(0xFF7CB8E8), // Sky
    Color(0xFF8787E8), // Lavender
    Color(0xFFD487C4), // Rose
    Color(0xFF87D4C4), // Teal
    Color(0xFFD4A574), // Caramel
    Color(0xFFA8B87C), // Olive
  ];

  // Streak Colors
  static const Color streakActive = Color(0xFFE87C4C);
  static const Color streakInactive = Color(0xFFA8A8A8);

  // Experience Bar Colors
  static const Color experienceBarFilled = Color(0xFFD4A574);
  static const Color experienceBarEmpty = Color(0xFFE8E0D8);
  static const Color experienceBarFilledDark = Color(0xFFE8C87C);
  static const Color experienceBarEmptyDark = Color(0xFF4A4540);

  // Level Colors (gradient based on level)
  static const List<Color> levelGradient = [
    Color(0xFF8B7355), // Bronze
    Color(0xFFC0C0C0), // Silver
    Color(0xFFFFD700), // Gold
    Color(0xFF00CED1), // Diamond
    Color(0xFFFF69B4), // Master
  ];

  // Chart Colors
  static const Color chartLine = Color(0xFFC27B5C);
  static const Color chartFill = Color(0x40C27B5C);
  static const Color chartGrid = Color(0xFFE8E0D8);
  static const Color chartGridDark = Color(0xFF4A4540);

  // Shimmer Colors
  static const Color shimmerBase = Color(0xFFE8E0D8);
  static const Color shimmerHighlight = Color(0xFFFFFAF5);
  static const Color shimmerBaseDark = Color(0xFF353230);
  static const Color shimmerHighlightDark = Color(0xFF4A4540);

  // Overlay Colors
  static const Color overlayLight = Color(0x80000000);
  static const Color overlayDark = Color(0x80FFFFFF);

  // Achievement Colors
  static const Color achievementLocked = Color(0xFF8B8B8B);
  static const Color achievementUnlocked = Color(0xFFFFD700);
  static const Color achievementRare = Color(0xFF9B59B6);
  static const Color achievementEpic = Color(0xFFE67E22);
  static const Color achievementLegendary = Color(0xFFE74C3C);

  // Routine Colors
  static const Color routineMorning = Color(0xFFE8C87C);
  static const Color routineEvening = Color(0xFF7C8BE8);
}
