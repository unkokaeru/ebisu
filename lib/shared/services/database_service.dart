import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ebisu/shared/models/models.dart';

/// Database service for managing Isar database operations.
class DatabaseService {
  DatabaseService._();

  static Isar? _instance;

  static Isar get instance {
    if (_instance == null) {
      throw StateError('Database not initialized. Call DatabaseService.initialize() first.');
    }
    return _instance!;
  }

  static Future<void> initialize() async {
    if (_instance != null) return;

    final String directoryPath;
    if (kIsWeb) {
      // On web, Isar uses IndexedDB - use empty string for directory
      directoryPath = '';
    } else {
      final directory = await getApplicationDocumentsDirectory();
      directoryPath = directory.path;
    }

    _instance = await Isar.open(
      [
        TodoSchema,
        TodoCategorySchema,
        RoutineItemSchema,
        RoutineCompletionSchema,
        OrganizationCategorySchema,
        DailyOrganizationLogSchema,
        PlayerProfileSchema,
        SkillSchema,
        AchievementSchema,
      ],
      directory: directoryPath,
      name: 'ebisu_database',
    );

    await _initializeDefaultData();
  }

  static Future<void> _initializeDefaultData() async {
    final database = instance;

    final existingAchievements = await database.achievements.count();
    if (existingAchievements == 0) {
      await _initializeAchievements(database);
    }
  }

  static Future<void> _initializeAchievements(Isar database) async {
    final achievements = [
      Achievement()
        ..key = 'first_steps'
        ..name = 'First Steps'
        ..description = 'Complete your first task'
        ..iconCodePoint = 0xe566
        ..iconEmoji = '👣'
        ..isUnlocked = false,
      Achievement()
        ..key = 'on_fire'
        ..name = 'On Fire'
        ..description = 'Maintain a 7-day streak'
        ..iconCodePoint = 0xe518
        ..iconEmoji = '🔥'
        ..isUnlocked = false,
      Achievement()
        ..key = 'dedicated'
        ..name = 'Dedicated'
        ..description = 'Maintain a 30-day streak'
        ..iconCodePoint = 0xe19b
        ..iconEmoji = '💎'
        ..isUnlocked = false,
      Achievement()
        ..key = 'completionist'
        ..name = 'Completionist'
        ..description = 'Reach level 10 in any organization category'
        ..iconCodePoint = 0xe3af
        ..iconEmoji = '🏆'
        ..isUnlocked = false,
      Achievement()
        ..key = 'early_bird'
        ..name = 'Early Bird'
        ..description = 'Complete a morning routine'
        ..iconCodePoint = 0xe518
        ..iconEmoji = '🌅'
        ..isUnlocked = false,
      Achievement()
        ..key = 'night_owl'
        ..name = 'Night Owl'
        ..description = 'Complete an evening routine'
        ..iconCodePoint = 0xe51c
        ..iconEmoji = '🦉'
        ..isUnlocked = false,
      Achievement()
        ..key = 'focused'
        ..name = 'Focused'
        ..description = 'Complete 5 urgent and important tasks'
        ..iconCodePoint = 0xe21b
        ..iconEmoji = '🎯'
        ..isUnlocked = false,
      Achievement()
        ..key = 'organized'
        ..name = 'Organized'
        ..description = 'Create your first organization category'
        ..iconCodePoint = 0xe2c7
        ..iconEmoji = '📁'
        ..isUnlocked = false,
      Achievement()
        ..key = 'routine_master'
        ..name = 'Routine Master'
        ..description = 'Complete both routines in one day'
        ..iconCodePoint = 0xe040
        ..iconEmoji = '⭐'
        ..isUnlocked = false,
      Achievement()
        ..key = 'level_up'
        ..name = 'Level Up'
        ..description = 'Reach player level 5'
        ..iconCodePoint = 0xe8e5
        ..iconEmoji = '📈'
        ..isUnlocked = false,
      Achievement()
        ..key = 'skillful'
        ..name = 'Skillful'
        ..description = 'Level up any skill to level 5'
        ..iconCodePoint = 0xe65f
        ..iconEmoji = '🧠'
        ..isUnlocked = false,
      Achievement()
        ..key = 'centurion'
        ..name = 'Centurion'
        ..description = 'Complete 100 tasks'
        ..iconCodePoint = 0xf028
        ..iconEmoji = '💯'
        ..isUnlocked = false,
      Achievement()
        ..key = 'streak_saver'
        ..name = 'Streak Saver'
        ..description = 'Complete a carried-over task'
        ..iconCodePoint = 0xf011
        ..iconEmoji = '🛡️'
        ..isUnlocked = false,
    ];

    await database.writeTxn(() async {
      await database.achievements.putAll(achievements);
    });
  }

  static Future<void> resetAllData() async {
    final database = instance;
    await database.writeTxn(() async {
      await database.clear();
    });
    await _initializeDefaultData();
  }

  static Future<void> close() async {
    await _instance?.close();
    _instance = null;
  }
}
