import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:ebisu/shared/services/database_service.dart';
import 'package:ebisu/shared/models/todo_model.dart';
import 'package:ebisu/shared/models/todo_category_model.dart';
import 'package:ebisu/shared/models/skill_model.dart';
import 'package:ebisu/shared/models/player_profile_model.dart';
import 'package:ebisu/core/configuration/numeric_constants.dart';
import 'package:ebisu/core/utilities/experience_calculator.dart';

final todosProvider = StreamProvider<List<Todo>>((ref) async* {
  final isar = DatabaseService.instance;
  await for (final _ in isar.todos.watchLazy(fireImmediately: true)) {
    yield await isar.todos.where().sortByCreatedAtDesc().findAll();
  }
});

final activeTodosProvider = Provider<List<Todo>>((ref) {
  final todos = ref.watch(todosProvider).valueOrNull ?? [];
  return todos.where((todo) => !todo.isCompleted).toList();
});

final completedTodosProvider = Provider<List<Todo>>((ref) {
  final todos = ref.watch(todosProvider).valueOrNull ?? [];
  return todos.where((todo) => todo.isCompleted).toList();
});

final todosByCategoryProvider = Provider.family<List<Todo>, int?>((ref, categoryId) {
  final todos = ref.watch(activeTodosProvider);
  if (categoryId == null) return todos;
  return todos.where((todo) => todo.categoryId == categoryId).toList();
});

final todosByQuadrantProvider = Provider.family<List<Todo>, int>((ref, quadrant) {
  final todos = ref.watch(activeTodosProvider);
  return todos.where((todo) => todo.quadrant == quadrant).toList();
});

final todoCategoriesProvider = StreamProvider<List<TodoCategory>>((ref) async* {
  final isar = DatabaseService.instance;
  await for (final _ in isar.todoCategorys.watchLazy(fireImmediately: true)) {
    yield await isar.todoCategorys.where().sortByCreatedAt().findAll();
  }
});

final urgentImportantTodosProvider = Provider<List<Todo>>((ref) {
  return ref.watch(todosByQuadrantProvider(NumericConstants.quadrantUrgentImportant));
});

class TodoController {
  static Future<Todo> createTodo({
    required String title,
    int? categoryId,
    required int quadrant,
    required int weight,
  }) async {
    final todo = Todo()
      ..title = title
      ..categoryId = categoryId
      ..quadrant = quadrant
      ..weight = weight
      ..isCompleted = false
      ..createdAt = DateTime.now()
      ..isCarriedOver = false;

    await DatabaseService.instance.writeTxn(() async {
      await DatabaseService.instance.todos.put(todo);
    });

    return todo;
  }

  static Future<void> updateTodo(Todo todo) async {
    await DatabaseService.instance.writeTxn(() async {
      await DatabaseService.instance.todos.put(todo);
    });
  }

  static Future<void> completeTodo(Todo todo) async {
    final profiles = await DatabaseService.instance.playerProfiles.where().findAll();
    final currentStreak = profiles.isNotEmpty ? profiles.first.currentStreak : 0;

    final experiencePoints = ExperienceCalculator.calculateTodoExperiencePoints(
      todo.quadrant,
      todo.weight,
      currentStreak,
    );

    todo.isCompleted = true;
    todo.completedAt = DateTime.now();

    await DatabaseService.instance.writeTxn(() async {
      await DatabaseService.instance.todos.put(todo);
    });

    final isUrgentImportant = todo.quadrant == NumericConstants.quadrantUrgentImportant;

    await _addExperience(experiencePoints, todo.categoryId);
    await _incrementTasksCompleted(isUrgentImportant: isUrgentImportant);

    if (todo.isCarriedOver) {
      await _checkCarriedOverAchievement();
    }
  }

  static Future<void> _addExperience(int experience, int? categoryId) async {
    final profiles = await DatabaseService.instance.playerProfiles.where().findAll();
    if (profiles.isEmpty) return;
    
    final profile = profiles.first;
    profile.totalExperiencePoints += experience;

    await DatabaseService.instance.writeTxn(() async {
      await DatabaseService.instance.playerProfiles.put(profile);
    });

    if (categoryId != null) {
      final skill = await DatabaseService.instance.skills
          .filter()
          .sourceIdEqualTo(categoryId)
          .sourceTypeEqualTo('todo_category')
          .findFirst();

      if (skill != null) {
        skill.experiencePoints += experience;
        await DatabaseService.instance.writeTxn(() async {
          await DatabaseService.instance.skills.put(skill);
        });
      }
    }
  }

  static Future<void> _incrementTasksCompleted({required bool isUrgentImportant}) async {
    final profiles = await DatabaseService.instance.playerProfiles.where().findAll();
    if (profiles.isEmpty) return;

    final profile = profiles.first;
    profile.totalTasksCompleted++;
    if (isUrgentImportant) {
      profile.urgentImportantTasksCompleted++;
    }

    await DatabaseService.instance.writeTxn(() async {
      await DatabaseService.instance.playerProfiles.put(profile);
    });
  }

  static Future<void> _checkCarriedOverAchievement() async {
    // Implementation for checking carried over achievement
  }

  static Future<void> uncompleteTodo(Todo todo) async {
    todo.isCompleted = false;
    todo.completedAt = null;

    await DatabaseService.instance.writeTxn(() async {
      await DatabaseService.instance.todos.put(todo);
    });
  }

  static Future<void> deleteTodo(int todoId) async {
    await DatabaseService.instance.writeTxn(() async {
      await DatabaseService.instance.todos.delete(todoId);
    });
  }

  static Future<TodoCategory> createCategory({
    required String name,
    required int iconCodePoint,
    required int colorValue,
    required int abilityIndex,
  }) async {
    final category = TodoCategory()
      ..name = name
      ..iconCodePoint = iconCodePoint
      ..colorValue = colorValue
      ..abilityIndex = abilityIndex
      ..createdAt = DateTime.now();

    await DatabaseService.instance.writeTxn(() async {
      await DatabaseService.instance.todoCategorys.put(category);
    });

    final skill = Skill()
      ..name = name
      ..iconCodePoint = iconCodePoint
      ..colorValue = colorValue
      ..experiencePoints = 0
      ..abilityIndex = abilityIndex
      ..sourceType = 'todo_category'
      ..sourceId = category.id
      ..createdAt = DateTime.now();

    await DatabaseService.instance.writeTxn(() async {
      await DatabaseService.instance.skills.put(skill);
    });

    return category;
  }

  static Future<void> updateCategory(TodoCategory category) async {
    await DatabaseService.instance.writeTxn(() async {
      await DatabaseService.instance.todoCategorys.put(category);
    });

    final skill = await DatabaseService.instance.skills
        .filter()
        .sourceIdEqualTo(category.id)
        .sourceTypeEqualTo('todo_category')
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
      await DatabaseService.instance.todoCategorys.delete(categoryId);
      
      final todos = await DatabaseService.instance.todos
          .filter()
          .categoryIdEqualTo(categoryId)
          .findAll();
      
      for (final todo in todos) {
        todo.categoryId = null;
        await DatabaseService.instance.todos.put(todo);
      }

      final skill = await DatabaseService.instance.skills
          .filter()
          .sourceIdEqualTo(categoryId)
          .sourceTypeEqualTo('todo_category')
          .findFirst();

      if (skill != null) {
        await DatabaseService.instance.skills.delete(skill.id);
      }
    });
  }
}
