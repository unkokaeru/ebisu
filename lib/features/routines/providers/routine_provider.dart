import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:ebisu/shared/services/database_service.dart';
import 'package:ebisu/shared/models/routine_item_model.dart';
import 'package:ebisu/shared/models/routine_completion_model.dart';
import 'package:ebisu/shared/models/player_profile_model.dart';
import 'package:ebisu/shared/models/achievement_model.dart';
import 'package:ebisu/core/utilities/experience_calculator.dart';
import 'package:ebisu/core/utilities/date_time_utilities.dart';

final morningRoutineItemsProvider = StreamProvider<List<RoutineItem>>((ref) async* {
  final isar = DatabaseService.instance;
  await for (final _ in isar.routineItems.watchLazy(fireImmediately: true)) {
    yield await isar.routineItems
        .filter()
        .routineTypeEqualTo(RoutineType.morning)
        .sortByOrderIndex()
        .findAll();
  }
});

final eveningRoutineItemsProvider = StreamProvider<List<RoutineItem>>((ref) async* {
  final isar = DatabaseService.instance;
  await for (final _ in isar.routineItems.watchLazy(fireImmediately: true)) {
    yield await isar.routineItems
        .filter()
        .routineTypeEqualTo(RoutineType.evening)
        .sortByOrderIndex()
        .findAll();
  }
});

final currentRoutineTypeProvider = StateProvider<RoutineType>((ref) {
  if (DateTimeUtilities.isMorningTime()) {
    return RoutineType.morning;
  } else if (DateTimeUtilities.isEveningTime()) {
    return RoutineType.evening;
  }
  return RoutineType.morning;
});

final todayMorningCompletionProvider = StreamProvider<RoutineCompletion?>((ref) async* {
  final isar = DatabaseService.instance;
  final today = DateTimeUtilities.startOfDay(DateTime.now());
  final tomorrow = today.add(const Duration(days: 1));

  await for (final _ in isar.routineCompletions.watchLazy(fireImmediately: true)) {
    final completions = await isar.routineCompletions
        .filter()
        .routineTypeEqualTo(RoutineType.morning.index)
        .dateBetween(today, tomorrow)
        .findAll();
    yield completions.isNotEmpty ? completions.first : null;
  }
});

final todayEveningCompletionProvider = StreamProvider<RoutineCompletion?>((ref) async* {
  final isar = DatabaseService.instance;
  final today = DateTimeUtilities.startOfDay(DateTime.now());
  final tomorrow = today.add(const Duration(days: 1));

  await for (final _ in isar.routineCompletions.watchLazy(fireImmediately: true)) {
    final completions = await isar.routineCompletions
        .filter()
        .routineTypeEqualTo(RoutineType.evening.index)
        .dateBetween(today, tomorrow)
        .findAll();
    yield completions.isNotEmpty ? completions.first : null;
  }
});

class RoutineController {
  static Future<RoutineItem> createRoutineItem({
    required RoutineType routineType,
    required String name,
    required int abilityIndex,
  }) async {
    final existingItems = await DatabaseService.instance.routineItems
        .filter()
        .routineTypeEqualTo(routineType)
        .findAll();

    final maxOrder = existingItems.isEmpty
        ? 0
        : existingItems.map((item) => item.orderIndex).reduce((a, b) => a > b ? a : b);

    final item = RoutineItem()
      ..routineType = routineType
      ..name = name
      ..orderIndex = maxOrder + 1
      ..abilityIndex = abilityIndex
      ..createdAt = DateTime.now();

    await DatabaseService.instance.writeTxn(() async {
      await DatabaseService.instance.routineItems.put(item);
    });

    return item;
  }

  static Future<void> updateRoutineItem(RoutineItem item) async {
    await DatabaseService.instance.writeTxn(() async {
      await DatabaseService.instance.routineItems.put(item);
    });
  }

  static Future<void> deleteRoutineItem(int itemId) async {
    await DatabaseService.instance.writeTxn(() async {
      await DatabaseService.instance.routineItems.delete(itemId);
    });
  }

  static Future<void> reorderRoutineItems(List<RoutineItem> items) async {
    await DatabaseService.instance.writeTxn(() async {
      for (int i = 0; i < items.length; i++) {
        items[i].orderIndex = i;
        await DatabaseService.instance.routineItems.put(items[i]);
      }
    });
  }

  static Future<void> toggleRoutineItemCompletion({
    required RoutineType routineType,
    required int itemId,
    required bool isCompleted,
  }) async {
    final today = DateTimeUtilities.startOfDay(DateTime.now());
    final tomorrow = today.add(const Duration(days: 1));

    var completion = await DatabaseService.instance.routineCompletions
        .filter()
        .routineTypeEqualTo(routineType.index)
        .dateBetween(today, tomorrow)
        .findFirst();

    completion ??= RoutineCompletion()
      ..routineType = routineType.index
      ..date = today
      ..completedItemIds = []
      ..isFullyCompleted = false;

    if (isCompleted) {
      if (!completion.completedItemIds.contains(itemId)) {
        completion.completedItemIds = [...completion.completedItemIds, itemId];
      }
    } else {
      completion.completedItemIds = completion.completedItemIds.where((id) => id != itemId).toList();
    }

    final allItems = await DatabaseService.instance.routineItems
        .filter()
        .routineTypeEqualTo(routineType)
        .findAll();

    final wasFullyCompleted = completion.isFullyCompleted;
    completion.isFullyCompleted = allItems.isNotEmpty &&
        allItems.every((item) => completion!.completedItemIds.contains(item.id));

    await DatabaseService.instance.writeTxn(() async {
      await DatabaseService.instance.routineCompletions.put(completion!);
    });

    if (isCompleted) {
      final profiles = await DatabaseService.instance.playerProfiles.where().findAll();
      final currentStreak = profiles.isNotEmpty ? profiles.first.currentStreak : 0;

      final experience = ExperienceCalculator.calculateRoutineItemExperiencePoints(
        completion.isFullyCompleted,
        currentStreak,
      );

      await _addExperience(experience);

      if (completion.isFullyCompleted && !wasFullyCompleted) {
        await _incrementRoutinesCompleted();

        if (routineType == RoutineType.morning) {
          await _unlockAchievement('early_bird');
        } else {
          await _unlockAchievement('night_owl');
        }

        await _checkRoutineMasterAchievement();
      }
    }
  }

  static Future<void> _addExperience(int experience) async {
    final profiles = await DatabaseService.instance.playerProfiles.where().findAll();
    if (profiles.isEmpty) return;
    
    final profile = profiles.first;
    profile.totalExperiencePoints += experience;

    await DatabaseService.instance.writeTxn(() async {
      await DatabaseService.instance.playerProfiles.put(profile);
    });
  }

  static Future<void> _incrementRoutinesCompleted() async {
    final profiles = await DatabaseService.instance.playerProfiles.where().findAll();
    if (profiles.isEmpty) return;

    final profile = profiles.first;
    profile.totalRoutinesCompleted++;

    await DatabaseService.instance.writeTxn(() async {
      await DatabaseService.instance.playerProfiles.put(profile);
    });
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

  static Future<void> _checkRoutineMasterAchievement() async {
    final today = DateTimeUtilities.startOfDay(DateTime.now());
    final tomorrow = today.add(const Duration(days: 1));

    final morningCompletion = await DatabaseService.instance.routineCompletions
        .filter()
        .routineTypeEqualTo(RoutineType.morning.index)
        .dateBetween(today, tomorrow)
        .findFirst();

    final eveningCompletion = await DatabaseService.instance.routineCompletions
        .filter()
        .routineTypeEqualTo(RoutineType.evening.index)
        .dateBetween(today, tomorrow)
        .findFirst();

    if (morningCompletion?.isFullyCompleted == true &&
        eveningCompletion?.isFullyCompleted == true) {
      await _unlockAchievement('routine_master');
    }
  }

  static Future<List<int>> getCompletedItemIdsForToday(RoutineType routineType) async {
    final today = DateTimeUtilities.startOfDay(DateTime.now());
    final tomorrow = today.add(const Duration(days: 1));

    final completion = await DatabaseService.instance.routineCompletions
        .filter()
        .routineTypeEqualTo(routineType.index)
        .dateBetween(today, tomorrow)
        .findFirst();

    return completion?.completedItemIds ?? [];
  }
}
