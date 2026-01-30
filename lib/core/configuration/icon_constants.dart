import 'package:flutter/material.dart';

/// Icon constants for the entire application.
/// Maps icon identifiers to Material Icons code points.
class IconConstants {
  IconConstants._();

  // Navigation
  static const IconData navigationHome = Icons.home_rounded;
  static const IconData navigationTodos = Icons.check_circle_rounded;
  static const IconData navigationRoutines = Icons.wb_sunny_rounded;
  static const IconData navigationProgress = Icons.bar_chart_rounded;
  static const IconData navigationProfile = Icons.person_rounded;

  // Actions
  static const IconData actionAdd = Icons.add_rounded;
  static const IconData actionEdit = Icons.edit_rounded;
  static const IconData actionDelete = Icons.delete_rounded;
  static const IconData actionSave = Icons.save_rounded;
  static const IconData actionClose = Icons.close_rounded;
  static const IconData actionSettings = Icons.settings_rounded;
  static const IconData actionMore = Icons.more_vert_rounded;
  static const IconData actionBack = Icons.arrow_back_rounded;
  static const IconData actionForward = Icons.arrow_forward_rounded;
  static const IconData actionSpin = Icons.casino_rounded;
  static const IconData actionComplete = Icons.check_rounded;
  static const IconData actionUndo = Icons.undo_rounded;
  static const IconData actionRedo = Icons.redo_rounded;
  static const IconData actionRefresh = Icons.refresh_rounded;
  static const IconData actionFilter = Icons.filter_list_rounded;
  static const IconData actionSort = Icons.sort_rounded;
  static const IconData actionSearch = Icons.search_rounded;

  // Status
  static const IconData statusComplete = Icons.check_circle_rounded;
  static const IconData statusIncomplete = Icons.radio_button_unchecked_rounded;
  static const IconData statusLocked = Icons.lock_rounded;
  static const IconData statusUnlocked = Icons.lock_open_rounded;
  static const IconData statusActive = Icons.circle_rounded;
  static const IconData statusInactive = Icons.circle_outlined;

  // Routines
  static const IconData routineMorning = Icons.wb_sunny_rounded;
  static const IconData routineEvening = Icons.nightlight_rounded;
  static const IconData routineSwitch = Icons.swap_horiz_rounded;

  // RPG
  static const IconData rpgExperience = Icons.auto_awesome_rounded;
  static const IconData rpgLevel = Icons.military_tech_rounded;
  static const IconData rpgStreak = Icons.local_fire_department_rounded;
  static const IconData rpgAchievement = Icons.emoji_events_rounded;
  static const IconData rpgSkill = Icons.psychology_rounded;
  static const IconData rpgStats = Icons.analytics_rounded;
  static const IconData rpgRank = Icons.star_rounded;

  // Abilities (D&D-style core stats)
  static const List<IconData> abilityIcons = [
    Icons.fitness_center_rounded,    // Strength
    Icons.directions_run_rounded,    // Dexterity
    Icons.favorite_rounded,          // Constitution
    Icons.psychology_rounded,        // Intelligence
    Icons.visibility_rounded,        // Wisdom
    Icons.record_voice_over_rounded, // Charisma
  ];

  // Quadrants
  static const IconData quadrantUrgentImportant = Icons.priority_high_rounded;
  static const IconData quadrantImportant = Icons.bookmark_rounded;
  static const IconData quadrantUrgent = Icons.schedule_rounded;
  static const IconData quadrantLow = Icons.low_priority_rounded;

  // Organization
  static const IconData organizationCategory = Icons.category_rounded;
  static const IconData organizationLevel = Icons.signal_cellular_alt_rounded;
  static const IconData organizationHistory = Icons.history_rounded;
  static const IconData organizationCheckIn = Icons.fact_check_rounded;
  static const IconData organizationCarriedOver = Icons.next_plan_rounded;

  // Charts
  static const IconData chartLine = Icons.show_chart_rounded;
  static const IconData chartBar = Icons.bar_chart_rounded;
  static const IconData chartPie = Icons.pie_chart_rounded;

  // Settings
  static const IconData settingsTheme = Icons.palette_rounded;
  static const IconData settingsThemeLight = Icons.light_mode_rounded;
  static const IconData settingsThemeDark = Icons.dark_mode_rounded;
  static const IconData settingsData = Icons.storage_rounded;
  static const IconData settingsExport = Icons.file_upload_rounded;
  static const IconData settingsImport = Icons.file_download_rounded;
  static const IconData settingsReset = Icons.restart_alt_rounded;
  static const IconData settingsAbout = Icons.info_rounded;
  static const IconData settingsPrivacy = Icons.privacy_tip_rounded;
  static const IconData settingsLicenses = Icons.description_rounded;

  // Category Icons - RPG/D&D Character Stats & Skills
  static const List<IconData> categoryIcons = [
    // Physical Stats
    Icons.fitness_center_rounded,    // Strength
    Icons.directions_run_rounded,    // Dexterity/Agility
    Icons.favorite_rounded,          // Constitution/Health
    // Mental Stats
    Icons.psychology_rounded,        // Intelligence
    Icons.auto_awesome_rounded,      // Wisdom
    Icons.record_voice_over_rounded, // Charisma
    // Skills & Proficiencies
    Icons.shield_rounded,            // Defense/Armor
    Icons.bolt_rounded,              // Magic/Arcana
    Icons.explore_rounded,           // Exploration/Survival
    Icons.handshake_rounded,         // Diplomacy/Persuasion
    Icons.visibility_rounded,        // Perception/Investigation
    Icons.healing_rounded,           // Medicine/Restoration
    // Crafting & Knowledge
    Icons.build_rounded,             // Crafting/Smithing
    Icons.menu_book_rounded,         // Lore/History
    Icons.science_rounded,           // Alchemy/Nature
    Icons.music_note_rounded,        // Performance/Arts
    // Adventure & Combat
    Icons.gps_fixed_rounded,         // Ranged/Archery
    Icons.flash_on_rounded,          // Stealth/Thievery
    Icons.groups_rounded,            // Leadership/Command
    Icons.pets_rounded,              // Animal Handling/Companion
    // Home & Living
    Icons.home_rounded,              // Room/Home
    Icons.bed_rounded,               // Bedroom
    Icons.kitchen_rounded,           // Kitchen
    Icons.cleaning_services_rounded, // Cleaning
    // Vehicle & Transport
    Icons.directions_car_rounded,    // Car
    Icons.two_wheeler_rounded,       // Motorcycle/Bike
    Icons.local_gas_station_rounded, // Fuel/Maintenance
    // Personal Care & Hygiene
    Icons.face_rounded,              // Skin/Face
    Icons.brush_rounded,             // Hair/Grooming
    Icons.clean_hands_rounded,       // Hand Hygiene
    Icons.sentiment_very_satisfied_rounded, // Teeth/Dental
    Icons.self_improvement_rounded,  // Personal/Wellness
    Icons.spa_rounded,               // Self-care
    // Academic & Professional
    Icons.school_rounded,            // Academic/Education
    Icons.work_rounded,              // Professional/Work
    Icons.business_center_rounded,   // Career
    Icons.laptop_rounded,            // Tech/Digital
    Icons.account_balance_rounded,   // Finance/Banking
    // Lifestyle
    Icons.restaurant_rounded,        // Food/Nutrition
    Icons.local_cafe_rounded,        // Coffee/Breaks
    Icons.shopping_bag_rounded,      // Shopping
    Icons.checkroom_rounded,         // Wardrobe/Clothing
    Icons.sports_esports_rounded,    // Gaming/Hobbies
    Icons.movie_rounded,             // Entertainment
  ];

  // Achievement Icons
  static const IconData achievementFirstSteps = Icons.directions_walk_rounded;
  static const IconData achievementOnFire = Icons.local_fire_department_rounded;
  static const IconData achievementDedicated = Icons.diamond_rounded;
  static const IconData achievementCompletionist = Icons.military_tech_rounded;
  static const IconData achievementEarlyBird = Icons.wb_sunny_rounded;
  static const IconData achievementNightOwl = Icons.nightlight_rounded;
  static const IconData achievementFocused = Icons.center_focus_strong_rounded;
  static const IconData achievementOrganized = Icons.folder_rounded;
  static const IconData achievementRoutineMaster = Icons.repeat_rounded;
  static const IconData achievementLevelUp = Icons.trending_up_rounded;
  static const IconData achievementSkillful = Icons.auto_awesome_rounded;
  static const IconData achievementCenturion = Icons.workspace_premium_rounded;
  static const IconData achievementStreakSaver = Icons.shield_rounded;

  // Misc
  static const IconData empty = Icons.inbox_rounded;
  static const IconData error = Icons.error_rounded;
  static const IconData warning = Icons.warning_rounded;
  static const IconData info = Icons.info_rounded;
  static const IconData success = Icons.check_circle_rounded;
  static const IconData loading = Icons.hourglass_empty_rounded;
  static const IconData calendar = Icons.calendar_today_rounded;
  static const IconData time = Icons.access_time_rounded;
  static const IconData drag = Icons.drag_indicator_rounded;

  // Profile
  static const IconData profileAvatar = Icons.person_rounded;
  static const IconData profileStreak = Icons.local_fire_department_rounded;
  static const IconData profileSkillsIcon = Icons.psychology_rounded;
  static const IconData experienceIcon = Icons.star_rounded;

  // Navigation (feature screens)
  static const IconData todosNavigationIcon = Icons.check_circle_rounded;
  static const IconData routinesNavigationIcon = Icons.wb_sunny_rounded;

  // Settings (additional)
  static const IconData settingsVersion = Icons.info_outline_rounded;
  static const IconData settingsLightMode = Icons.light_mode_rounded;
  static const IconData settingsDarkMode = Icons.dark_mode_rounded;
  static const IconData settingsSystemTheme = Icons.brightness_auto_rounded;
}
