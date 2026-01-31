import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:ebisu/shared/services/database_service.dart';
import 'package:ebisu/shared/models/organization_category_model.dart';
import 'package:ebisu/shared/models/daily_organization_log_model.dart';
import 'package:ebisu/shared/models/player_profile_model.dart';
import 'package:ebisu/shared/models/skill_model.dart';
import 'package:ebisu/shared/models/achievement_model.dart';
import 'package:ebisu/core/configuration/numeric_constants.dart';
import 'package:ebisu/core/utilities/experience_calculator.dart';
import 'package:ebisu/core/utilities/date_time_utilities.dart';

final organizationCategoriesProvider = StreamProvider<List<OrganizationCategory>>((ref) async* {
  final isar = DatabaseService.instance;
  await for (final _ in isar.organizationCategorys.watchLazy(fireImmediately: true)) {
    yield await isar.organizationCategorys.where().sortByCreatedAt().findAll();
  }
});

/// Provider that groups skills by their ability index
final skillsByAbilityProvider = Provider<Map<int, List<OrganizationCategory>>>((ref) {
  final skills = ref.watch(organizationCategoriesProvider).valueOrNull ?? [];
  final Map<int, List<OrganizationCategory>> grouped = {};
  
  for (int i = 0; i < NumericConstants.abilityCount; i++) {
    grouped[i] = skills.where((s) => NumericConstants.safeAbilityIndex(s.abilityIndex) == i).toList();
  }
  
  return grouped;
});

/// Provider that calculates ability scores from associated skills
/// Each ability score is the average level of all skills under it (0 if no skills)
final abilityScoresProvider = Provider<List<int>>((ref) {
  final skillsByAbility = ref.watch(skillsByAbilityProvider);
  final todayLogs = ref.watch(todayOrganizationLogsProvider).valueOrNull ?? [];
  
  final List<int> scores = [];
  
  for (int abilityIndex = 0; abilityIndex < NumericConstants.abilityCount; abilityIndex++) {
    final skills = skillsByAbility[abilityIndex] ?? [];
    
    if (skills.isEmpty) {
      scores.add(0);
      continue;
    }
    
    // Calculate average level of all skills under this ability
    int totalLevel = 0;
    for (final skill in skills) {
      final log = todayLogs.where((l) => l.categoryId == skill.id).firstOrNull;
      final level = log?.completedLevel ?? NumericConstants.organizationMinLevel;
      totalLevel += level;
    }
    
    final averageLevel = (totalLevel / skills.length).round();
    scores.add(averageLevel);
  }
  
  return scores;
});

final organizationCategoryProvider = StreamProvider.family<OrganizationCategory?, int>((ref, categoryId) async* {
  final isar = DatabaseService.instance;
  await for (final _ in isar.organizationCategorys.watchLazy(fireImmediately: true)) {
    yield await isar.organizationCategorys.get(categoryId);
  }
});

final todayOrganizationLogsProvider = StreamProvider<List<DailyOrganizationLog>>((ref) async* {
  final isar = DatabaseService.instance;
  final today = DateTimeUtilities.startOfDay(DateTime.now());
  final tomorrow = today.add(const Duration(days: 1));

  await for (final _ in isar.dailyOrganizationLogs.watchLazy(fireImmediately: true)) {
    yield await isar.dailyOrganizationLogs
        .filter()
        .dateBetween(today, tomorrow)
        .findAll();
  }
});

final organizationLogForCategoryProvider = Provider.family<DailyOrganizationLog?, int>((ref, categoryId) {
  final logs = ref.watch(todayOrganizationLogsProvider).valueOrNull ?? [];
  return logs.where((log) => log.categoryId == categoryId).firstOrNull;
});

final organizationHistoryProvider = StreamProvider.family<List<DailyOrganizationLog>, int>((ref, categoryId) async* {
  final isar = DatabaseService.instance;
  final startDate = DateTime.now().subtract(const Duration(days: NumericConstants.chartHistoryDays));

  await for (final _ in isar.dailyOrganizationLogs.watchLazy(fireImmediately: true)) {
    yield await isar.dailyOrganizationLogs
        .filter()
        .categoryIdEqualTo(categoryId)
        .dateGreaterThan(startDate)
        .sortByDate()
        .findAll();
  }
});

class OrganizationController {
  static Future<OrganizationCategory> createCategory({
    required String name,
    required int iconCodePoint,
    required int colorValue,
    required List<String> levels,
    required int abilityIndex,
  }) async {
    if (levels.length != NumericConstants.organizationMaxLevel) {
      throw ArgumentError('Organization category must have exactly ${NumericConstants.organizationMaxLevel} levels');
    }

    final category = OrganizationCategory()
      ..name = name
      ..iconCodePoint = iconCodePoint
      ..colorValue = colorValue
      ..levels = levels
      ..abilityIndex = abilityIndex
      ..createdAt = DateTime.now();

    await DatabaseService.instance.writeTxn(() async {
      await DatabaseService.instance.organizationCategorys.put(category);
    });

    final skill = Skill()
      ..name = name
      ..iconCodePoint = iconCodePoint
      ..colorValue = colorValue
      ..experiencePoints = 0
      ..sourceType = 'organization_category'
      ..sourceId = category.id
      ..createdAt = DateTime.now();

    await DatabaseService.instance.writeTxn(() async {
      await DatabaseService.instance.skills.put(skill);
    });

    await _unlockAchievement('organized');

    return category;
  }

  static Future<void> _unlockAchievement(String achievementKey) async {
    final achievement = await DatabaseService.instance.achievements
        .filter()
        .keyEqualTo(achievementKey)
        .findFirst();

    if (achievement != null && !achievement.isUnlocked) {
      achievement.isUnlocked = true;
      achievement.unlockedAt = DateTime.now();

      await DatabaseService.instance.writeTxn(() async {
        await DatabaseService.instance.achievements.put(achievement);
      });
    }
  }

  static Future<void> updateCategory(OrganizationCategory category) async {
    if (category.levels.length != NumericConstants.organizationMaxLevel) {
      throw ArgumentError('Organization category must have exactly ${NumericConstants.organizationMaxLevel} levels');
    }

    await DatabaseService.instance.writeTxn(() async {
      await DatabaseService.instance.organizationCategorys.put(category);
    });

    final skill = await DatabaseService.instance.skills
        .filter()
        .sourceIdEqualTo(category.id)
        .sourceTypeEqualTo('organization_category')
        .findFirst();

    if (skill != null) {
      skill.name = category.name;
      skill.iconCodePoint = category.iconCodePoint;
      skill.colorValue = category.colorValue;
      skill.abilityIndex = category.abilityIndex;

      await DatabaseService.instance.writeTxn(() async {
        await DatabaseService.instance.skills.put(skill);
      });
    }
  }

  static Future<void> deleteCategory(int categoryId) async {
    await DatabaseService.instance.writeTxn(() async {
      await DatabaseService.instance.organizationCategorys.delete(categoryId);

      final logs = await DatabaseService.instance.dailyOrganizationLogs
          .filter()
          .categoryIdEqualTo(categoryId)
          .findAll();

      for (final log in logs) {
        await DatabaseService.instance.dailyOrganizationLogs.delete(log.id);
      }

      final skill = await DatabaseService.instance.skills
          .filter()
          .sourceIdEqualTo(categoryId)
          .sourceTypeEqualTo('organization_category')
          .findFirst();

      if (skill != null) {
        await DatabaseService.instance.skills.delete(skill.id);
      }
    });
  }

  static Future<void> logOrganizationLevel({
    required int categoryId,
    required int completedLevel,
  }) async {
    final today = DateTimeUtilities.startOfDay(DateTime.now());
    final tomorrow = today.add(const Duration(days: 1));

    var existingLog = await DatabaseService.instance.dailyOrganizationLogs
        .filter()
        .categoryIdEqualTo(categoryId)
        .dateBetween(today, tomorrow)
        .findFirst();

    final previousLevel = existingLog?.completedLevel ?? 0;

    if (existingLog == null) {
      existingLog = DailyOrganizationLog()
        ..categoryId = categoryId
        ..date = today
        ..completedLevel = completedLevel
        ..isCarriedOver = false;
    } else {
      existingLog.completedLevel = completedLevel;
    }

    await DatabaseService.instance.writeTxn(() async {
      await DatabaseService.instance.dailyOrganizationLogs.put(existingLog!);
    });

    if (completedLevel > previousLevel) {
      final profiles = await DatabaseService.instance.playerProfiles.where().findAll();
      final currentStreak = profiles.isNotEmpty ? profiles.first.currentStreak : 0;

      int totalExperience = 0;

      for (int level = previousLevel + 1; level <= completedLevel; level++) {
        totalExperience += ExperienceCalculator.calculateOrganizationExperiencePoints(
          level,
          currentStreak,
        );
      }

      await _addExperience(totalExperience, categoryId);

      if (completedLevel == NumericConstants.organizationMaxLevel) {
        await _unlockAchievement('completionist');
      }
    }
  }

  static Future<void> _addExperience(int experience, int categoryId) async {
    final profiles = await DatabaseService.instance.playerProfiles.where().findAll();
    if (profiles.isEmpty) return;
    
    final profile = profiles.first;
    profile.totalExperiencePoints += experience;

    await DatabaseService.instance.writeTxn(() async {
      await DatabaseService.instance.playerProfiles.put(profile);
    });

    final skill = await DatabaseService.instance.skills
        .filter()
        .sourceIdEqualTo(categoryId)
        .sourceTypeEqualTo('organization_category')
        .findFirst();

    if (skill != null) {
      skill.experiencePoints += experience;
      await DatabaseService.instance.writeTxn(() async {
        await DatabaseService.instance.skills.put(skill);
      });
    }
  }

  static Future<void> carryOverIncompleteTasks() async {
    final yesterday = DateTimeUtilities.startOfDay(
      DateTime.now().subtract(const Duration(days: 1)),
    );
    final today = DateTimeUtilities.startOfDay(DateTime.now());

    final yesterdayLogs = await DatabaseService.instance.dailyOrganizationLogs
        .filter()
        .dateBetween(yesterday, today)
        .findAll();

    for (final log in yesterdayLogs) {
      if (log.completedLevel < NumericConstants.organizationMaxLevel) {
        final existingTodayLog = await DatabaseService.instance.dailyOrganizationLogs
            .filter()
            .categoryIdEqualTo(log.categoryId)
            .dateBetween(today, today.add(const Duration(days: 1)))
            .findFirst();

        if (existingTodayLog == null) {
          final newLog = DailyOrganizationLog()
            ..categoryId = log.categoryId
            ..date = today
            ..completedLevel = log.completedLevel
            ..isCarriedOver = true;

          await DatabaseService.instance.writeTxn(() async {
            await DatabaseService.instance.dailyOrganizationLogs.put(newLog);
          });
        }
      }
    }
  }
}
