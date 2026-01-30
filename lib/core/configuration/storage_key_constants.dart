/// Storage key constants for persistent data.
/// All SharedPreferences and database keys should be defined here.
class StorageKeyConstants {
  StorageKeyConstants._();

  // SharedPreferences Keys
  static const String keyThemeMode = 'theme_mode';
  static const String keyPlayerName = 'player_name';
  static const String keyOnboardingComplete = 'onboarding_complete';
  static const String keyLastActiveDate = 'last_active_date';

  // Database Names
  static const String databaseName = 'ebisu_database';

  // Collection Names (Isar)
  static const String collectionTodo = 'todos';
  static const String collectionTodoCategory = 'todo_categories';
  static const String collectionRoutine = 'routines';
  static const String collectionRoutineItem = 'routine_items';
  static const String collectionRoutineCompletion = 'routine_completions';
  static const String collectionOrganizationCategory = 'organization_categories';
  static const String collectionDailyOrganizationLog = 'daily_organization_logs';
  static const String collectionPlayerProfile = 'player_profiles';
  static const String collectionSkill = 'skills';
  static const String collectionAchievement = 'achievements';
}
