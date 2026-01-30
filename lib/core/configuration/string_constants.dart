/// String constants for the entire application.
/// All user-facing text should be defined here for easy localization.
class StringConstants {
  StringConstants._();

  // Application
  static const String applicationName = 'Ebisu';
  static const String applicationTagline = 'Level Up Your Life';

  // Navigation
  static const String navigationHome = 'Home';
  static const String navigationTodos = 'Quests';
  static const String navigationRoutines = 'Rituals';
  static const String navigationProgress = 'Progress';
  static const String navigationProfile = 'Profile';

  // Onboarding
  static const String onboardingWelcomeTitle = 'Welcome to Ebisu';
  static const String onboardingWelcomeSubtitle = 'Your adventure begins now';
  static const String onboardingNamePrompt = 'What shall we call you, adventurer?';
  static const String onboardingNameHint = 'Your name';
  static const String onboardingNameValidation = 'Enter a name';
  static const String onboardingStartButton = 'Begin';
  static const String onboardingNameTooShort = 'Too short (min 2)';
  static const String onboardingNameTooLong = 'Too long (max 20)';

  // Home
  static const String homeGreetingMorning = 'Good morning';
  static const String homeGreetingAfternoon = 'Good afternoon';
  static const String homeGreetingEvening = 'Good evening';
  static const String homeCurrentStreak = 'Streak';
  static const String homeDays = 'days';
  static const String homeDay = 'day';
  static const String homeTodaysFocus = 'Focus';
  static const String homeNoFocusTasks = 'All clear!';
  static const String homeQuickActions = 'Actions';
  static const String homeLevel = 'Lv';
  static const String homeExperiencePoints = 'XP';

  // Todos
  static const String todosTitle = 'Quests';
  static const String todosAddTask = 'New Quest';
  static const String todosEditTask = 'Edit Quest';
  static const String todosDeleteTask = 'Delete Quest';
  static const String todosTaskTitle = 'Title';
  static const String todosTaskTitleHint = 'What needs doing?';
  static const String todosTaskTitleValidation = 'Enter a title';
  static const String todosCategory = 'Skill';
  static const String todosWeight = 'Weight';
  static const String todosQuadrant = 'Priority';
  static const String todosSave = 'Save';
  static const String todosCancel = 'Cancel';
  static const String todosDelete = 'Delete';
  static const String todosConfirmDelete = 'Delete this quest?';
  static const String todosSpinWheel = 'Spin Wheel';
  static const String todosNoTasks = 'No quests';
  static const String todosAddFirstTask = 'Add your first quest';
  static const String todosCompleted = 'Done';
  static const String todosFilterAll = 'All';
  static const String todosFilterActive = 'Active';

  // Eisenhower Matrix Quadrants
  static const String quadrantUrgentImportant = 'Do First';
  static const String quadrantImportantNotUrgent = 'Schedule';
  static const String quadrantUrgentNotImportant = 'Delegate';
  static const String quadrantNotUrgentNotImportant = 'Eliminate';
  static const String quadrantUrgentImportantDescription = 'Urgent & Important';
  static const String quadrantImportantNotUrgentDescription = 'Important, Not Urgent';
  static const String quadrantUrgentNotImportantDescription = 'Urgent, Not Important';
  static const String quadrantNotUrgentNotImportantDescription = 'Not Urgent, Not Important';

  // Picker Wheel
  static const String pickerWheelTitle = 'Quest Wheel';
  static const String pickerWheelSpin = 'Spin!';
  static const String pickerWheelResult = 'Your quest:';
  static const String pickerWheelNoTasks = 'Add quests to spin';
  static const String pickerWheelCompleteTask = 'Complete';
  static const String pickerWheelSpinAgain = 'Again';

  // Routines
  static const String routinesTitle = 'Rituals';
  static const String routinesMorning = 'Morning Ritual';
  static const String routinesEvening = 'Evening Ritual';
  static const String routinesAddItem = 'Add Step';
  static const String routinesEditItem = 'Edit Step';
  static const String routinesDeleteItem = 'Delete Step';
  static const String routinesItemName = 'Step';
  static const String routinesItemNameHint = 'What to do?';
  static const String routinesItemNameValidation = 'Enter a step';
  static const String routinesNoItems = 'No steps yet';
  static const String routinesAddFirstItem = 'Add your first step';
  static const String routinesCompleted = 'Ritual complete!';
  static const String routinesProgress = 'Progress';
  static const String routinesMorningIcon = '☀️';
  static const String routinesEveningIcon = '🌙';

  // Organisation
  static const String organizationTitle = 'Skills';
  static const String organizationAddCategory = 'New Skill';
  static const String organizationEditCategory = 'Edit Skill';
  static const String organizationDeleteCategory = 'Delete Skill';
  static const String organizationCategoryName = 'Name';
  static const String organizationCategoryNameHint = 'Fitness, Learning, etc.';
  static const String organizationCategoryNameValidation = 'Enter a name';
  static const String organizationSelectAbility = 'Ability';

  // Abilities (core stats that skills contribute to)
  static const String abilitiesTitle = 'Abilities';
  static const List<String> abilityNames = [
    'Strength',
    'Dexterity',
    'Constitution',
    'Intelligence',
    'Wisdom',
    'Charisma',
  ];
  static const List<String> abilityDescriptions = [
    'Power & athletics',
    'Agility & finesse',
    'Health & resilience',
    'Learning & logic',
    'Insight & perception',
    'Presence & influence',
  ];
  static const String organizationLevels = 'Levels';
  static const String organizationLevelHint = 'Level';
  static const String organizationLevelValidation = 'All 10 levels required';
  static const String organizationNoCategories = 'No skills';
  static const String organizationAddFirstCategory = 'Add a skill to build abilities';
  static const String organizationTodayProgress = 'Today';
  static const String organizationHistory = 'History';
  static const String organizationCurrentLevel = 'Level';
  static const String organizationMaxLevel = '10';
  static const String organizationCheckIn = 'Check In';
  static const String organizationCarriedOver = 'From yesterday';

  // RPG / Profile
  static const String profileTitle = 'Profile';
  static const String profileLevel = 'Level';
  static const String profileTotalExperience = 'Total XP';
  static const String profileExperienceToNext = 'To next';
  static const String profileSkills = 'Skills';
  static const String profileAchievements = 'Achievements';
  static const String profileStats = 'Stats';
  static const String profileTotalTasksCompleted = 'Quests';
  static const String profileRoutinesCompleted = 'Rituals';
  static const String profileCurrentStreak = 'Streak';
  static const String profileLongestStreak = 'Best Streak';
  static const String profileMemberSince = 'Since';
  static const String profileRank = 'Rank';

  // Ranks (based on level)
  static const String rankNovice = 'Novice';
  static const String rankApprentice = 'Apprentice';
  static const String rankJourneyman = 'Journeyman';
  static const String rankAdept = 'Adept';
  static const String rankExpert = 'Expert';
  static const String rankMaster = 'Master';
  static const String rankGrandmaster = 'Grandmaster';
  static const String rankLegend = 'Legend';

  // Achievements
  static const String achievementUnlocked = 'Achievement!';
  static const String achievementLocked = 'Locked';
  static const String achievementFirstSteps = 'First Steps';
  static const String achievementFirstStepsDescription = 'Complete a quest';
  static const String achievementOnFire = 'On Fire';
  static const String achievementOnFireDescription = '7-day streak';
  static const String achievementDedicated = 'Dedicated';
  static const String achievementDedicatedDescription = '30-day streak';
  static const String achievementCompletionist = 'Completionist';
  static const String achievementCompletionistDescription = 'Max level any skill';
  static const String achievementEarlyBird = 'Early Bird';
  static const String achievementEarlyBirdDescription = 'Complete morning ritual';
  static const String achievementNightOwl = 'Night Owl';
  static const String achievementNightOwlDescription = 'Complete evening ritual';
  static const String achievementFocused = 'Focused';
  static const String achievementFocusedDescription = '5 urgent quests done';
  static const String achievementOrganized = 'Organised';
  static const String achievementOrganizedDescription = 'Create a skill';
  static const String achievementRoutineMaster = 'Ritual Master';
  static const String achievementRoutineMasterDescription = 'Both rituals in one day';
  static const String achievementLevelUp = 'Level Up';
  static const String achievementLevelUpDescription = 'Reach level 5';
  static const String achievementSkillful = 'Skilful';
  static const String achievementSkillfulDescription = 'Level 5 in any skill';
  static const String achievementCenturion = 'Centurion';
  static const String achievementCenturionDescription = '100 quests complete';
  static const String achievementStreakSaver = 'Streak Saver';
  static const String achievementStreakSaverDescription = 'Finish a carried quest';

  // Categories (default suggestions)
  static const String categoryWork = 'Work';
  static const String categoryPersonal = 'Personal';
  static const String categoryHealth = 'Health';
  static const String categoryLearning = 'Learning';
  static const String categoryFinance = 'Finance';
  static const String categorySocial = 'Social';
  static const String categoryCreative = 'Creative';
  static const String categoryHome = 'Home';

  // Settings
  static const String settingsTitle = 'Settings';
  static const String settingsAppearance = 'Appearance';
  static const String settingsTheme = 'Theme';
  static const String settingsThemeLight = 'Light';
  static const String settingsThemeDark = 'Dark';
  static const String settingsThemeSystem = 'System';
  static const String settingsData = 'Data';
  static const String settingsExport = 'Export';
  static const String settingsImport = 'Import';
  static const String settingsExportData = 'Export';
  static const String settingsExportDataDescription = 'Save progress to file';
  static const String settingsExportDataConfirmation = 'Export all data to JSON?';
  static const String settingsExportSuccess = 'Exported';
  static const String settingsImportData = 'Import';
  static const String settingsImportDataDescription = 'Restore from file';
  static const String settingsImportDataConfirmation = 'Replace all data?';
  static const String settingsImportSuccess = 'Imported';
  static const String settingsResetData = 'Reset';
  static const String settingsResetDataDescription = 'Delete all progress';
  static const String settingsResetDataConfirmation = 'Delete everything? Cannot undo.';
  static const String settingsResetSuccess = 'Reset complete';
  static const String settingsReset = 'Reset';
  static const String settingsResetConfirm = 'Cannot undo. Continue?';
  static const String settingsAbout = 'About';
  static const String settingsVersion = 'Version';
  static const String settingsPrivacy = 'Privacy';
  static const String settingsLicenses = 'Licences';
  static const String settingsLicensesDescription = 'Third-party licences';
  static const String settingsPlayingSince = 'Since';
  static const String settingsTasks = 'Quests';
  static const String settingsStreak = 'Streak';

  // Profile Screen
  static const String profileExperiencePoints = 'XP';
  static const String profileToNextLevel = 'to next';
  static const String profileNoSkillsYet = 'Complete quests to unlock';
  static const String profileNoAchievementsYet = 'Unlock through play';

  // Achievements Screen
  static const String achievementsTitle = 'Achievements';
  static const String achievementsUnlocked = 'Unlocked';
  static const String achievementLockedDescription = 'Keep playing';
  static const String achievementUnlockedOn = 'Unlocked';

  // Skills Screen
  static const String skillsTitle = 'Skills';
  static const String skillsTotal = 'Skills';
  static const String skillsTotalExperience = 'XP';
  static const String skillsEmptyTitle = 'No Skills';
  static const String skillsEmptyDescription = 'Complete quests to unlock';
  static const String skillsProgress = 'To next level';

  // Quick Actions / Home
  static const String homeSeeAll = 'All';

  // General Actions
  static const String actionCancel = 'Cancel';
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String add = 'Add';
  static const String confirm = 'Confirm';
  static const String yes = 'Yes';
  static const String no = 'No';
  static const String ok = 'OK';
  static const String error = 'Error';
  static const String success = 'Success';
  static const String loading = 'Loading...';
  static const String retry = 'Retry';
  static const String close = 'Close';
  static const String done = 'Done';
  static const String next = 'Next';
  static const String back = 'Back';
  static const String skip = 'Skip';

  // Time
  static const String today = 'Today';
  static const String yesterday = 'Yesterday';
  static const String thisWeek = 'This Week';
  static const String thisMonth = 'This Month';
  static const String allTime = 'All Time';

  // Experience notifications
  static const String experienceGained = 'XP gained';
  static const String leveledUp = 'Level Up!';
  static const String newRankAchieved = 'New Rank Achieved';
  static const String skillLevelUp = 'Skill Level Up';

  // Skills
  static const String skillsEditSkill = 'Edit Skill';
  static const String skillsEditAbility = 'Ability';
  static const String skillsDeleteSkill = 'Delete Skill';
  static const String skillsDeleteConfirm = 'Delete';

  // Tooltips
  static const String tooltipAddTask = 'New quest';
  static const String tooltipSpinWheel = 'Spin wheel';
  static const String tooltipSwitchRoutine = 'Switch ritual';
  static const String tooltipViewHistory = 'History';
  static const String tooltipSettings = 'Settings';
}
