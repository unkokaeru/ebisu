import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:ebisu/shared/services/database_service.dart';
import 'package:ebisu/shared/models/player_profile_model.dart';
import 'package:ebisu/shared/models/achievement_model.dart';
import 'package:ebisu/shared/models/skill_model.dart';
import 'package:ebisu/shared/models/todo_model.dart';
import 'package:ebisu/shared/models/todo_category_model.dart';
import 'package:ebisu/shared/models/organization_category_model.dart';
import 'package:ebisu/shared/models/daily_organization_log_model.dart';
import 'package:ebisu/shared/models/routine_item_model.dart';
import 'package:ebisu/shared/models/routine_completion_model.dart';
import 'package:ebisu/core/utilities/experience_calculator.dart';
import 'package:ebisu/core/utilities/date_time_utilities.dart';
import 'package:ebisu/core/configuration/numeric_constants.dart';

final playerProfileProvider = StreamProvider<PlayerProfile?>((ref) async* {
  final isar = DatabaseService.instance;
  await for (final _ in isar.playerProfiles.watchLazy(fireImmediately: true)) {
    final profiles = await isar.playerProfiles.where().findAll();
    yield profiles.isNotEmpty ? profiles.first : null;
  }
});

final playerLevelProvider = Provider<int>((ref) {
  final profile = ref.watch(playerProfileProvider).valueOrNull;
  if (profile == null) return 1;
  return ExperienceCalculator.calculateLevel(profile.totalExperiencePoints);
});

final playerRankProvider = Provider<String>((ref) {
  final level = ref.watch(playerLevelProvider);
  return ExperienceCalculator.getRankTitle(level);
});

final allAchievementsProvider = StreamProvider<List<Achievement>>((ref) async* {
  final isar = DatabaseService.instance;
  await for (final _ in isar.achievements.watchLazy(fireImmediately: true)) {
    yield await isar.achievements.where().findAll();
  }
});

final unlockedAchievementsProvider = StreamProvider<List<Achievement>>((ref) async* {
  final isar = DatabaseService.instance;
  await for (final _ in isar.achievements.watchLazy(fireImmediately: true)) {
    yield await isar.achievements.filter().isUnlockedEqualTo(true).findAll();
  }
});

final allSkillsProvider = StreamProvider<List<Skill>>((ref) async* {
  final isar = DatabaseService.instance;
  await for (final _ in isar.skills.watchLazy(fireImmediately: true)) {
    yield await isar.skills.where().findAll();
  }
});

/// Provider for completed todos by ability
final completedTodosByAbilityProvider = FutureProvider<Map<int, int>>((ref) async {
  final isar = DatabaseService.instance;
  final completedTodos = await isar.todos.filter().isCompletedEqualTo(true).findAll();
  final categories = await isar.todoCategorys.where().findAll();
  
  final Map<int, int> countByAbility = {};
  for (int i = 0; i < NumericConstants.abilityCount; i++) {
    countByAbility[i] = 0;
  }
  
  for (final todo in completedTodos) {
    if (todo.categoryId != null) {
      final category = categories.firstWhere(
        (c) => c.id == todo.categoryId,
        orElse: () => TodoCategory()..abilityIndex = 0,
      );
      final safeIdx = NumericConstants.safeAbilityIndex(category.abilityIndex);
      countByAbility[safeIdx] = (countByAbility[safeIdx] ?? 0) + 1;
    }
  }
  
  return countByAbility;
});

/// Provider for completed routine items by ability
final completedRoutinesByAbilityProvider = FutureProvider<Map<int, int>>((ref) async {
  final isar = DatabaseService.instance;
  final completions = await isar.routineCompletions.where().findAll();
  final routineItems = await isar.routineItems.where().findAll();
  
  final Map<int, int> countByAbility = {};
  for (int i = 0; i < NumericConstants.abilityCount; i++) {
    countByAbility[i] = 0;
  }
  
  for (final completion in completions) {
    for (final itemId in completion.completedItemIds) {
      final item = routineItems.firstWhere(
        (r) => r.id == itemId,
        orElse: () => RoutineItem()..abilityIndex = 0,
      );
      final safeIdx = NumericConstants.safeAbilityIndex(item.abilityIndex);
      countByAbility[safeIdx] = (countByAbility[safeIdx] ?? 0) + 1;
    }
  }
  
  return countByAbility;
});

/// Provider for total activity count by ability (todos + routines)
final activityCountByAbilityProvider = Provider<Map<int, int>>((ref) {
  final todosByAbility = ref.watch(completedTodosByAbilityProvider).valueOrNull ?? {};
  final routinesByAbility = ref.watch(completedRoutinesByAbilityProvider).valueOrNull ?? {};
  
  final Map<int, int> total = {};
  for (int i = 0; i < NumericConstants.abilityCount; i++) {
    total[i] = (todosByAbility[i] ?? 0) + (routinesByAbility[i] ?? 0);
  }
  
  return total;
});

/// Provider that groups actual Skill objects by their ability index
final actualSkillsByAbilityProvider = Provider<Map<int, List<Skill>>>((ref) {
  final skills = ref.watch(allSkillsProvider).valueOrNull ?? [];
  final Map<int, List<Skill>> grouped = {};
  
  for (int i = 0; i < NumericConstants.abilityCount; i++) {
    grouped[i] = skills.where((s) => NumericConstants.safeAbilityIndex(s.abilityIndex) == i).toList();
  }
  
  return grouped;
});

/// Provider that calculates ability scores from actual skills' experience
final actualAbilityScoresProvider = Provider<List<int>>((ref) {
  final skillsByAbility = ref.watch(actualSkillsByAbilityProvider);
  
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
      final level = ExperienceCalculator.calculateLevel(skill.experiencePoints);
      totalLevel += level;
    }
    
    final averageLevel = (totalLevel / skills.length).round();
    scores.add(averageLevel);
  }
  
  return scores;
});

class PlayerProfileController {
  /// Checks and updates the streak on app startup.
  /// Resets streak if user missed a day.
  static Future<void> checkAndUpdateStreak() async {
    final profiles = await DatabaseService.instance.playerProfiles.where().findAll();
    if (profiles.isEmpty) return;

    final profile = profiles.first;
    final today = DateTimeUtilities.startOfDay(DateTime.now());
    final lastActive = DateTimeUtilities.startOfDay(profile.lastActiveDate);

    // If last active was today, do nothing
    if (DateTimeUtilities.isSameDay(today, lastActive)) {
      return;
    }

    // If last active was yesterday, streak continues (will be incremented on first activity)
    if (DateTimeUtilities.isYesterday(profile.lastActiveDate)) {
      return;
    }

    // If more than 1 day has passed, reset streak
    if (today.difference(lastActive).inDays > 1) {
      profile.currentStreak = 0;
      profile.lastActiveDate = DateTime.now();
      
      await DatabaseService.instance.writeTxn(() async {
        await DatabaseService.instance.playerProfiles.put(profile);
      });
    }
  }

  /// Syncs all category abilityIndex values from their corresponding skills.
  /// This fixes any data inconsistencies from before the sync mechanism was added.
  static Future<void> syncAllCategoryAbilities() async {
    final skills = await DatabaseService.instance.skills.where().findAll();
    
    await DatabaseService.instance.writeTxn(() async {
      for (final skill in skills) {
        if (skill.sourceType == 'todo_category') {
          final category = await DatabaseService.instance.todoCategorys
              .get(skill.sourceId);
          if (category != null && category.abilityIndex != skill.abilityIndex) {
            category.abilityIndex = skill.abilityIndex;
            await DatabaseService.instance.todoCategorys.put(category);
          }
        } else if (skill.sourceType == 'organization_category') {
          final category = await DatabaseService.instance.organizationCategorys
              .get(skill.sourceId);
          if (category != null && category.abilityIndex != skill.abilityIndex) {
            category.abilityIndex = skill.abilityIndex;
            await DatabaseService.instance.organizationCategorys.put(category);
          }
        }
      }
    });
  }

  /// Updates a skill and syncs the abilityIndex back to the source category
  static Future<void> updateSkill(Skill skill) async {
    await DatabaseService.instance.writeTxn(() async {
      await DatabaseService.instance.skills.put(skill);

      // Sync abilityIndex back to source category
      if (skill.sourceType == 'todo_category') {
        final category = await DatabaseService.instance.todoCategorys
            .get(skill.sourceId);
        if (category != null) {
          category.abilityIndex = skill.abilityIndex;
          await DatabaseService.instance.todoCategorys.put(category);
        }
      } else if (skill.sourceType == 'organization_category') {
        final category = await DatabaseService.instance.organizationCategorys
            .get(skill.sourceId);
        if (category != null) {
          category.abilityIndex = skill.abilityIndex;
          await DatabaseService.instance.organizationCategorys.put(category);
        }
      }
    });
  }

  /// Deletes a skill and its source category (todo category or organization category)
  static Future<void> deleteSkill(int skillId) async {
    final skill = await DatabaseService.instance.skills.get(skillId);
    if (skill == null) return;

    await DatabaseService.instance.writeTxn(() async {
      // Delete the source category first
      if (skill.sourceType == 'todo_category') {
        // Unlink todos from this category
        final todos = await DatabaseService.instance.todos
            .filter()
            .categoryIdEqualTo(skill.sourceId)
            .findAll();
        for (final todo in todos) {
          todo.categoryId = null;
          await DatabaseService.instance.todos.put(todo);
        }
        await DatabaseService.instance.todoCategorys.delete(skill.sourceId);
      } else if (skill.sourceType == 'organization_category') {
        // Delete organization logs for this category
        final logs = await DatabaseService.instance.dailyOrganizationLogs
            .filter()
            .categoryIdEqualTo(skill.sourceId)
            .findAll();
        for (final log in logs) {
          await DatabaseService.instance.dailyOrganizationLogs.delete(log.id);
        }
        await DatabaseService.instance.organizationCategorys.delete(skill.sourceId);
      }

      // Delete the skill itself
      await DatabaseService.instance.skills.delete(skillId);
    });
  }

  static Future<void> addExperience(int amount, {int? skillSourceId, String? skillSourceType}) async {
    final profiles = await DatabaseService.instance.playerProfiles.where().findAll();
    if (profiles.isEmpty) return;

    final profile = profiles.first;
    final oldLevel = ExperienceCalculator.calculateLevel(profile.totalExperiencePoints);

    profile.totalExperiencePoints += amount;

    final today = DateTimeUtilities.startOfDay(DateTime.now());
    final lastActive = DateTimeUtilities.startOfDay(profile.lastActiveDate);

    if (!DateTimeUtilities.isSameDay(today, lastActive)) {
      if (DateTimeUtilities.isYesterday(profile.lastActiveDate)) {
        profile.currentStreak += 1;
      } else if (today.difference(lastActive).inDays > 1) {
        profile.currentStreak = 1;
      }

      if (profile.currentStreak > profile.longestStreak) {
        profile.longestStreak = profile.currentStreak;
      }
    }

    profile.lastActiveDate = DateTime.now();

    await DatabaseService.instance.writeTxn(() async {
      await DatabaseService.instance.playerProfiles.put(profile);
    });

    if (skillSourceId != null && skillSourceType != null) {
      await _addSkillExperience(skillSourceId, skillSourceType, amount);
    }

    final newLevel = ExperienceCalculator.calculateLevel(profile.totalExperiencePoints);
    if (newLevel > oldLevel) {
      await _checkLevelAchievements(newLevel);
    }

    await _checkStreakAchievements(profile.currentStreak);
  }

  static Future<void> _addSkillExperience(int sourceId, String sourceType, int amount) async {
    final existingSkill = await DatabaseService.instance.skills
        .filter()
        .sourceIdEqualTo(sourceId)
        .sourceTypeEqualTo(sourceType)
        .findFirst();

    if (existingSkill != null) {
      final oldLevel = ExperienceCalculator.calculateLevel(existingSkill.experiencePoints);
      existingSkill.experiencePoints += amount;
      
      await DatabaseService.instance.writeTxn(() async {
        await DatabaseService.instance.skills.put(existingSkill);
      });

      final newLevel = ExperienceCalculator.calculateLevel(existingSkill.experiencePoints);
      if (newLevel > oldLevel) {
        await _checkSkillAchievements(newLevel);
      }
    }
  }

  static Future<void> incrementTasksCompleted({bool isUrgentImportant = false}) async {
    final profiles = await DatabaseService.instance.playerProfiles.where().findAll();
    if (profiles.isEmpty) return;

    final profile = profiles.first;
    profile.totalTasksCompleted += 1;

    if (isUrgentImportant) {
      profile.urgentImportantTasksCompleted += 1;
    }

    await DatabaseService.instance.writeTxn(() async {
      await DatabaseService.instance.playerProfiles.put(profile);
    });

    await _checkTaskAchievements(profile.totalTasksCompleted, profile.urgentImportantTasksCompleted);
  }

  static Future<void> incrementRoutinesCompleted() async {
    final profiles = await DatabaseService.instance.playerProfiles.where().findAll();
    if (profiles.isEmpty) return;

    final profile = profiles.first;
    profile.totalRoutinesCompleted += 1;

    await DatabaseService.instance.writeTxn(() async {
      await DatabaseService.instance.playerProfiles.put(profile);
    });
  }

  static Future<void> _checkTaskAchievements(int totalTasks, int urgentImportantTasks) async {
    if (totalTasks >= 1) {
      await unlockAchievement('first_steps');
    }

    if (totalTasks >= 100) {
      await unlockAchievement('centurion');
    }

    if (urgentImportantTasks >= 5) {
      await unlockAchievement('focused');
    }
  }

  static Future<void> _checkStreakAchievements(int streak) async {
    if (streak >= 7) {
      await unlockAchievement('on_fire');
    }

    if (streak >= 30) {
      await unlockAchievement('dedicated');
    }
  }

  static Future<void> _checkLevelAchievements(int level) async {
    if (level >= 5) {
      await unlockAchievement('level_up');
    }
  }

  static Future<void> _checkSkillAchievements(int skillLevel) async {
    if (skillLevel >= 5) {
      await unlockAchievement('skillful');
    }
  }

  static Future<void> unlockAchievement(String key) async {
    final achievement = await DatabaseService.instance.achievements
        .filter()
        .keyEqualTo(key)
        .findFirst();

    if (achievement != null && !achievement.isUnlocked) {
      achievement.isUnlocked = true;
      achievement.unlockedAt = DateTime.now();

      await DatabaseService.instance.writeTxn(() async {
        await DatabaseService.instance.achievements.put(achievement);
      });
    }
  }

  static Future<void> checkCarriedOverAchievement() async {
    await unlockAchievement('streak_saver');
  }
}
