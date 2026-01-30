import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:ebisu/shared/services/database_service.dart';
import 'package:ebisu/shared/models/models.dart';

/// Result of an export/import operation.
class DataOperationResult {
  final bool success;
  final String message;
  final String? filePath;

  DataOperationResult({
    required this.success,
    required this.message,
    this.filePath,
  });
}

/// Service for exporting and importing all application data.
class DataExportService {
  DataExportService._();

  static const String _fileExtension = 'ebisu';
  static const int _exportVersion = 1;

  /// Exports all data to a user-selected location.
  static Future<DataOperationResult> exportData() async {
    try {
      // Let user pick save location
      final String? outputPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Export Ebisu Data',
        fileName: 'ebisu_backup_${_formatDateForFilename(DateTime.now())}.$_fileExtension',
        type: FileType.custom,
        allowedExtensions: [_fileExtension, 'json'],
      );

      if (outputPath == null) {
        return DataOperationResult(
          success: false,
          message: 'Export cancelled',
        );
      }

      // Gather all data
      final exportData = await _gatherAllData();

      // Write to file
      final file = File(outputPath);
      final jsonString = const JsonEncoder.withIndent('  ').convert(exportData);
      await file.writeAsString(jsonString);

      return DataOperationResult(
        success: true,
        message: 'Data exported successfully',
        filePath: outputPath,
      );
    } catch (e) {
      debugPrint('Export error: $e');
      return DataOperationResult(
        success: false,
        message: 'Export failed: ${e.toString()}',
      );
    }
  }

  /// Imports data from a user-selected file.
  static Future<DataOperationResult> importData() async {
    try {
      // Let user pick file to import
      final result = await FilePicker.platform.pickFiles(
        dialogTitle: 'Import Ebisu Data',
        type: FileType.custom,
        allowedExtensions: [_fileExtension, 'json'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        return DataOperationResult(
          success: false,
          message: 'Import cancelled',
        );
      }

      final filePath = result.files.single.path;
      if (filePath == null) {
        return DataOperationResult(
          success: false,
          message: 'Could not access file',
        );
      }

      // Read and parse file
      final file = File(filePath);
      final jsonString = await file.readAsString();
      final Map<String, dynamic> importData = json.decode(jsonString);

      // Validate export version
      final version = importData['exportVersion'] as int? ?? 0;
      if (version > _exportVersion) {
        return DataOperationResult(
          success: false,
          message: 'This backup was created with a newer version of Ebisu. Please update the app.',
        );
      }

      // Import all data
      await _restoreAllData(importData);

      return DataOperationResult(
        success: true,
        message: 'Data imported successfully',
        filePath: filePath,
      );
    } catch (e) {
      debugPrint('Import error: $e');
      return DataOperationResult(
        success: false,
        message: 'Import failed: ${e.toString()}',
      );
    }
  }

  /// Gets export data preview (for showing what will be imported).
  static Future<Map<String, int>?> getImportPreview(String filePath) async {
    try {
      final file = File(filePath);
      final jsonString = await file.readAsString();
      final Map<String, dynamic> data = json.decode(jsonString);

      return {
        'profile': data['playerProfile'] != null ? 1 : 0,
        'todos': (data['todos'] as List?)?.length ?? 0,
        'todoCategories': (data['todoCategories'] as List?)?.length ?? 0,
        'routineItems': (data['routineItems'] as List?)?.length ?? 0,
        'routineCompletions': (data['routineCompletions'] as List?)?.length ?? 0,
        'organizationCategories': (data['organizationCategories'] as List?)?.length ?? 0,
        'organizationLogs': (data['dailyOrganizationLogs'] as List?)?.length ?? 0,
        'skills': (data['skills'] as List?)?.length ?? 0,
        'achievements': (data['achievements'] as List?)?.length ?? 0,
      };
    } catch (e) {
      return null;
    }
  }

  static Future<Map<String, dynamic>> _gatherAllData() async {
    final db = DatabaseService.instance;

    // Fetch all data from each collection
    final todos = await db.todos.where().findAll();
    final todoCategories = await db.todoCategorys.where().findAll();
    final routineItems = await db.routineItems.where().findAll();
    final routineCompletions = await db.routineCompletions.where().findAll();
    final organizationCategories = await db.organizationCategorys.where().findAll();
    final dailyOrganizationLogs = await db.dailyOrganizationLogs.where().findAll();
    final playerProfile = await db.playerProfiles.where().findFirst();
    final skills = await db.skills.where().findAll();
    final achievements = await db.achievements.where().findAll();

    return {
      'exportVersion': _exportVersion,
      'exportDate': DateTime.now().toIso8601String(),
      'appVersion': '1.0.0',
      'playerProfile': playerProfile != null ? _profileToJson(playerProfile) : null,
      'todos': todos.map(_todoToJson).toList(),
      'todoCategories': todoCategories.map(_todoCategoryToJson).toList(),
      'routineItems': routineItems.map(_routineItemToJson).toList(),
      'routineCompletions': routineCompletions.map(_routineCompletionToJson).toList(),
      'organizationCategories': organizationCategories.map(_organizationCategoryToJson).toList(),
      'dailyOrganizationLogs': dailyOrganizationLogs.map(_dailyOrganizationLogToJson).toList(),
      'skills': skills.map(_skillToJson).toList(),
      'achievements': achievements.map(_achievementToJson).toList(),
    };
  }

  static Future<void> _restoreAllData(Map<String, dynamic> data) async {
    final db = DatabaseService.instance;

    // Clear existing data first
    await db.writeTxn(() async {
      await db.clear();
    });

    await db.writeTxn(() async {
      // Restore player profile
      if (data['playerProfile'] != null) {
        final profile = _profileFromJson(data['playerProfile']);
        await db.playerProfiles.put(profile);
      }

      // Restore todo categories
      if (data['todoCategories'] != null) {
        final categories = (data['todoCategories'] as List)
            .map((json) => _todoCategoryFromJson(json))
            .toList();
        await db.todoCategorys.putAll(categories);
      }

      // Restore todos
      if (data['todos'] != null) {
        final todos = (data['todos'] as List)
            .map((json) => _todoFromJson(json))
            .toList();
        await db.todos.putAll(todos);
      }

      // Restore routine items
      if (data['routineItems'] != null) {
        final items = (data['routineItems'] as List)
            .map((json) => _routineItemFromJson(json))
            .toList();
        await db.routineItems.putAll(items);
      }

      // Restore routine completions
      if (data['routineCompletions'] != null) {
        final completions = (data['routineCompletions'] as List)
            .map((json) => _routineCompletionFromJson(json))
            .toList();
        await db.routineCompletions.putAll(completions);
      }

      // Restore organization categories
      if (data['organizationCategories'] != null) {
        final categories = (data['organizationCategories'] as List)
            .map((json) => _organizationCategoryFromJson(json))
            .toList();
        await db.organizationCategorys.putAll(categories);
      }

      // Restore daily organization logs
      if (data['dailyOrganizationLogs'] != null) {
        final logs = (data['dailyOrganizationLogs'] as List)
            .map((json) => _dailyOrganizationLogFromJson(json))
            .toList();
        await db.dailyOrganizationLogs.putAll(logs);
      }

      // Restore skills
      if (data['skills'] != null) {
        final skills = (data['skills'] as List)
            .map((json) => _skillFromJson(json))
            .toList();
        await db.skills.putAll(skills);
      }

      // Restore achievements
      if (data['achievements'] != null) {
        final achievements = (data['achievements'] as List)
            .map((json) => _achievementFromJson(json))
            .toList();
        await db.achievements.putAll(achievements);
      }
    });
  }

  // === JSON Serialization Helpers ===

  static String _formatDateForFilename(DateTime date) {
    return '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}_${date.hour.toString().padLeft(2, '0')}${date.minute.toString().padLeft(2, '0')}';
  }

  // Player Profile
  static Map<String, dynamic> _profileToJson(PlayerProfile profile) => {
        'id': profile.id,
        'playerName': profile.playerName,
        'totalExperiencePoints': profile.totalExperiencePoints,
        'currentStreak': profile.currentStreak,
        'longestStreak': profile.longestStreak,
        'totalTasksCompleted': profile.totalTasksCompleted,
        'totalRoutinesCompleted': profile.totalRoutinesCompleted,
        'urgentImportantTasksCompleted': profile.urgentImportantTasksCompleted,
        'lastActiveDate': profile.lastActiveDate.toIso8601String(),
        'createdAt': profile.createdAt.toIso8601String(),
      };

  static PlayerProfile _profileFromJson(Map<String, dynamic> json) => PlayerProfile()
    ..id = json['id'] as int
    ..playerName = json['playerName'] as String
    ..totalExperiencePoints = json['totalExperiencePoints'] as int
    ..currentStreak = json['currentStreak'] as int
    ..longestStreak = json['longestStreak'] as int
    ..totalTasksCompleted = json['totalTasksCompleted'] as int
    ..totalRoutinesCompleted = json['totalRoutinesCompleted'] as int
    ..urgentImportantTasksCompleted = json['urgentImportantTasksCompleted'] as int? ?? 0
    ..lastActiveDate = DateTime.parse(json['lastActiveDate'])
    ..createdAt = DateTime.parse(json['createdAt']);

  // Todo
  static Map<String, dynamic> _todoToJson(Todo todo) => {
        'id': todo.id,
        'title': todo.title,
        'categoryId': todo.categoryId,
        'quadrant': todo.quadrant,
        'weight': todo.weight,
        'isCompleted': todo.isCompleted,
        'isCarriedOver': todo.isCarriedOver,
        'createdAt': todo.createdAt.toIso8601String(),
        'completedAt': todo.completedAt?.toIso8601String(),
      };

  static Todo _todoFromJson(Map<String, dynamic> json) => Todo()
    ..id = json['id'] as int
    ..title = json['title'] as String
    ..categoryId = json['categoryId'] as int?
    ..quadrant = json['quadrant'] as int
    ..weight = json['weight'] as int? ?? 1
    ..isCompleted = json['isCompleted'] as bool
    ..isCarriedOver = json['isCarriedOver'] as bool? ?? false
    ..createdAt = DateTime.parse(json['createdAt'])
    ..completedAt = json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null;

  // Todo Category
  static Map<String, dynamic> _todoCategoryToJson(TodoCategory category) => {
        'id': category.id,
        'name': category.name,
        'iconCodePoint': category.iconCodePoint,
        'colorValue': category.colorValue,
        'abilityIndex': category.abilityIndex,
        'createdAt': category.createdAt.toIso8601String(),
      };

  static TodoCategory _todoCategoryFromJson(Map<String, dynamic> json) => TodoCategory()
    ..id = json['id'] as int
    ..name = json['name'] as String
    ..iconCodePoint = json['iconCodePoint'] as int
    ..colorValue = json['colorValue'] as int
    ..abilityIndex = json['abilityIndex'] as int? ?? 0
    ..createdAt = DateTime.parse(json['createdAt']);

  // Routine Item
  static Map<String, dynamic> _routineItemToJson(RoutineItem item) => {
        'id': item.id,
        'name': item.name,
        'routineType': item.routineType.index,
        'orderIndex': item.orderIndex,
        'abilityIndex': item.abilityIndex,
        'createdAt': item.createdAt.toIso8601String(),
      };

  static RoutineItem _routineItemFromJson(Map<String, dynamic> json) => RoutineItem()
    ..id = json['id'] as int
    ..name = json['name'] as String
    ..routineType = RoutineType.values[json['routineType'] as int]
    ..orderIndex = json['orderIndex'] as int
    ..abilityIndex = json['abilityIndex'] as int? ?? 0
    ..createdAt = DateTime.parse(json['createdAt']);

  // Routine Completion
  static Map<String, dynamic> _routineCompletionToJson(RoutineCompletion completion) => {
        'id': completion.id,
        'routineType': completion.routineType,
        'date': completion.date.toIso8601String(),
        'completedItemIds': completion.completedItemIds,
        'isFullyCompleted': completion.isFullyCompleted,
      };

  static RoutineCompletion _routineCompletionFromJson(Map<String, dynamic> json) => RoutineCompletion()
    ..id = json['id'] as int
    ..routineType = json['routineType'] as int
    ..date = DateTime.parse(json['date'])
    ..completedItemIds = List<int>.from(json['completedItemIds'])
    ..isFullyCompleted = json['isFullyCompleted'] as bool;

  // Organization Category
  static Map<String, dynamic> _organizationCategoryToJson(OrganizationCategory category) => {
        'id': category.id,
        'name': category.name,
        'iconCodePoint': category.iconCodePoint,
        'colorValue': category.colorValue,
        'abilityIndex': category.abilityIndex,
        'levels': category.levels,
        'createdAt': category.createdAt.toIso8601String(),
      };

  static OrganizationCategory _organizationCategoryFromJson(Map<String, dynamic> json) => OrganizationCategory()
    ..id = json['id'] as int
    ..name = json['name'] as String
    ..iconCodePoint = json['iconCodePoint'] as int
    ..colorValue = json['colorValue'] as int
    ..abilityIndex = json['abilityIndex'] as int
    ..levels = List<String>.from(json['levels'])
    ..createdAt = DateTime.parse(json['createdAt']);

  // Daily Organization Log
  static Map<String, dynamic> _dailyOrganizationLogToJson(DailyOrganizationLog log) => {
        'id': log.id,
        'categoryId': log.categoryId,
        'date': log.date.toIso8601String(),
        'completedLevel': log.completedLevel,
        'isCarriedOver': log.isCarriedOver,
      };

  static DailyOrganizationLog _dailyOrganizationLogFromJson(Map<String, dynamic> json) => DailyOrganizationLog()
    ..id = json['id'] as int
    ..categoryId = json['categoryId'] as int
    ..date = DateTime.parse(json['date'])
    ..completedLevel = json['completedLevel'] as int
    ..isCarriedOver = json['isCarriedOver'] as bool? ?? false;

  // Skill
  static Map<String, dynamic> _skillToJson(Skill skill) => {
        'id': skill.id,
        'name': skill.name,
        'description': skill.description,
        'abilityIndex': skill.abilityIndex,
        'experiencePoints': skill.experiencePoints,
        'iconCodePoint': skill.iconCodePoint,
        'colorValue': skill.colorValue,
        'sourceType': skill.sourceType,
        'sourceId': skill.sourceId,
        'createdAt': skill.createdAt.toIso8601String(),
      };

  static Skill _skillFromJson(Map<String, dynamic> json) => Skill()
    ..id = json['id'] as int
    ..name = json['name'] as String
    ..description = json['description'] as String? ?? ''
    ..abilityIndex = json['abilityIndex'] as int? ?? 0
    ..experiencePoints = json['experiencePoints'] as int
    ..iconCodePoint = json['iconCodePoint'] as int
    ..colorValue = json['colorValue'] as int
    ..sourceType = json['sourceType'] as String
    ..sourceId = json['sourceId'] as int
    ..createdAt = DateTime.parse(json['createdAt']);

  // Achievement
  static Map<String, dynamic> _achievementToJson(Achievement achievement) => {
        'id': achievement.id,
        'key': achievement.key,
        'name': achievement.name,
        'description': achievement.description,
        'iconCodePoint': achievement.iconCodePoint,
        'iconEmoji': achievement.iconEmoji,
        'isUnlocked': achievement.isUnlocked,
        'unlockedAt': achievement.unlockedAt?.toIso8601String(),
      };

  static Achievement _achievementFromJson(Map<String, dynamic> json) => Achievement()
    ..id = json['id'] as int
    ..key = json['key'] as String
    ..name = json['name'] as String
    ..description = json['description'] as String
    ..iconCodePoint = json['iconCodePoint'] as int
    ..iconEmoji = json['iconEmoji'] as String? ?? '🏆'
    ..isUnlocked = json['isUnlocked'] as bool
    ..unlockedAt = json['unlockedAt'] != null ? DateTime.parse(json['unlockedAt']) : null;
}
